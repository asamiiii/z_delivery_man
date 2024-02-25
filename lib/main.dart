import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:z_delivery_man/core/config/app_theme.dart';
import 'package:z_delivery_man/core/constants/app_bloc_providers.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_strings.dart';
import 'package:z_delivery_man/notification_helper.dart';
import 'package:z_delivery_man/screens/home/home_delivery/home_delivery.dart';
import 'package:z_delivery_man/screens/home/home_provider.dart/home_screen.dart';
import 'package:z_delivery_man/screens/login/login_screen.dart';
import '/../screens/order_details/order_details_screen.dart';
import '/../shared/widgets/components.dart';
import '/../shared/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'bloc_observer.dart';
import 'firebase_options.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  
  AppNotification().init();

  token = CacheHelper.getData(key: 'token');
  debugPrint('token : $token');
  debugPrint('token : $token');
  isDeliveryMan = CacheHelper.getData(key: 'type');
  Widget widget;
  if (token != null && token!.isNotEmpty) {
    if (isDeliveryMan == true) {
      widget = const HomeDelivery();
    } else {
      widget = const HomeScreen();
    }
  } else {
    widget = const LoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.startWidget}) : super(key: key);
  final Widget? startWidget;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('message: $message');
        navigateAndReplace(
            navState.currentContext!,
            OrderDetailsScreen(
              orderId: int.tryParse(message.data['order_id']),
            ));
      }
      AppNotification.firebaseCloudMessagingListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
        providers: AppProviders.appProviders,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navState,
          title: AppStrings.appName,
          theme: AppTheme.them,
          home: widget.startWidget,
        ),
      );
    });
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:z_delivery_man/core/config/app_theme.dart';
import 'package:z_delivery_man/core/constants/app_bloc_providers.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_strings.dart';
import 'package:z_delivery_man/screens/login/login_screen.dart';
import '/../screens/home/home_screen.dart';
import '/../screens/order_details/order_details_screen.dart';
import '/../shared/widgets/components.dart';
import '/../shared/widgets/constants.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'bloc_observer.dart';
import 'firebase_options.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageType}');
  navigateAndReplace(
      navState.currentContext!,
      OrderDetailsScreen(
        orderId: int.tryParse(message.data['order_id']),
      ));
}

final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // debugPrint('x : $x');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  token = CacheHelper.getData(key: 'token');
  isDeliveryMan = CacheHelper.getData(key: 'type');
  // token = null;
  Widget widget;
  if (token != null && token!.isNotEmpty) {
    widget = const HomeScreen();
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
  void firebaseCloudMessagingListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message?.notification;
      debugPrint("notification on message : ${message?.data.entries}");

      AndroidNotification? androidNotification = message?.notification?.android;
      debugPrint("androidNotification : ${androidNotification?.tag}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
      debugPrint('message : ${message.data['order_id']} ${message.notification?.body}');
      navigateAndReplace(
          navState.currentContext!,
          OrderDetailsScreen(
            orderId: int.tryParse(message.data['order_id']),
            fromNotification: true,
          ));
    });
  }

  @override
  void initState() {
    // TODO: impleme nt initState
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        // Navigator.pushNamed(context, '/message',
        //     arguments: M essageArguments(message, true)
        debugPrint('message: $message');
        navigateAndReplace(
            navState.currentContext!,
            OrderDetailsScreen(
              orderId: int.tryParse(message.data['order_id']),
            ));
      }
      firebaseCloudMessagingListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
        providers: AppProviders.appProviders,
        // create: (context) => OrderslistCubit(),
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

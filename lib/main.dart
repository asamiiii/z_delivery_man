import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:z_delivery_man/core/config/app_theme.dart';
import 'package:z_delivery_man/core/constants/app_bloc_providers.dart';
import 'package:z_delivery_man/core/constants/app_strings/app_strings.dart';
import 'package:z_delivery_man/screens/home/home_delivery.dart';
import 'package:z_delivery_man/screens/login/login_screen.dart';
import '/../screens/home/home_screen.dart';
import '/../screens/order_details/order_details_screen.dart';
import '/../shared/widgets/components.dart';
import '/../shared/widgets/constants.dart';
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
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
// Future<void> initializeAmplify() async {
//   try {
//     await Amplify.addPlugins([
//       // AmplifyAuthCognito(),
//       AmplifyStorageS3(),
//     ]);
//     await Amplify.configure(amplifyconfig);
//     print('Amplify initialized successfully.');
//   } catch (e) {
//     print('Could not initialize Amplify: $e');
//   }
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  // debugPrint('x : $x');
  // await initializeAmplify();
  // await uploadExampleData();
  // await ScreenUtil.ensureScreenSize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  token = CacheHelper.getData(key: 'token');
  debugPrint('token : $token');
  isDeliveryMan = CacheHelper.getData(key: 'type');
  // configureAmplify();
  // token = null;
  Widget widget;
  if (token != null && token!.isNotEmpty) {
    if(isDeliveryMan==true){
      widget =  HomeDelivery();
    }else{
      widget =  HomeScreen();
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

// bool amplifyConfigured = false;
//   var amplifyConfig = '''{"foo": "bar"}''';
// // Platform messages are asynchronous, so we initialize in an async method.
//   void configureAmplify() async {
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     // if (!mounted) return;
//     await Amplify.configure(amplifyConfig);
//     try {
//         amplifyConfigured = true;
//      debugPrint('amplifyConfigured');
//     } on Exception catch (e) {
//       safePrint('Aplify Error : $e');
//     }
//   }


// Future<void> uploadExampleData() async {
//   const dataString = 'Example file contents';

//   try {
//     final result = await Amplify.Storage.uploadData(
//       data: S3DataPayload.string(dataString),
//       key: 'ExampleKey',
//       onProgress: (progress) {
//         safePrint('Transferred bytes: ${progress.transferredBytes}');
//       },
//     ).result;

//     safePrint('Uploaded data to location: ${result.uploadedItem.key}');
//   } on StorageException catch (e) {
//     safePrint(e.message);
//   }
// }
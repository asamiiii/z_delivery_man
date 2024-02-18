import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:z_delivery_man/main.dart';
import 'package:z_delivery_man/screens/order_details/order_details_screen.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';

class AppNotification{
final _firebaseMessaging = FirebaseMessaging.instance;
   Future<void> init()async{
     await _firebaseMessaging.requestPermission();
     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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

static void firebaseCloudMessagingListeners() {
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
}
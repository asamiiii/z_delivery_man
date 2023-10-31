// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB7X2qkSkUOH5j2FvuxC8h6P6DUb2xtvYE',
    appId: '1:651189661928:web:6d0b9f145a1b5a7cfc595d',
    messagingSenderId: '651189661928',
    projectId: 'deliveryman-e8fa7',
    authDomain: 'deliveryman-e8fa7.firebaseapp.com',
    storageBucket: 'deliveryman-e8fa7.appspot.com',
    measurementId: 'G-ECTGBG4VFE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLgvfvdeECWK9csyldZhg8enL-i27JmPg',
    appId: '1:651189661928:android:54c5121cc6507d47fc595d',
    messagingSenderId: '651189661928',
    projectId: 'deliveryman-e8fa7',
    storageBucket: 'deliveryman-e8fa7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBbu1US9u_f8CBsR9qcQfTHLTM-LTx51k',
    appId: '1:651189661928:ios:d3f911415db7c08cfc595d',
    messagingSenderId: '651189661928',
    projectId: 'deliveryman-e8fa7',
    storageBucket: 'deliveryman-e8fa7.appspot.com',
    iosBundleId: 'com.example.zDeliveryMan',
  );
}

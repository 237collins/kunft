// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAXi80nG9f42cHI-Y5KhEdSkVczHcA52E8',
    appId: '1:874658104545:web:442a0831817426483123a0',
    messagingSenderId: '874658104545',
    projectId: 'kunft-3f7db',
    authDomain: 'kunft-3f7db.firebaseapp.com',
    storageBucket: 'kunft-3f7db.firebasestorage.app',
    measurementId: 'G-R93HLQ0VTE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVKLD1Kz1KI6AclxVJO8rkUKGJw-bC5rc',
    appId: '1:874658104545:android:33f7802ea424fabc3123a0',
    messagingSenderId: '874658104545',
    projectId: 'kunft-3f7db',
    storageBucket: 'kunft-3f7db.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDO0-cPochDfqZh4btVKeQx1erBAIeyfOI',
    appId: '1:874658104545:ios:677395602e2dc2063123a0',
    messagingSenderId: '874658104545',
    projectId: 'kunft-3f7db',
    storageBucket: 'kunft-3f7db.firebasestorage.app',
    iosClientId: '874658104545-s1158765q7vt6nkskh79akbuudfi2nh0.apps.googleusercontent.com',
    iosBundleId: 'com.example.kunft',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAXi80nG9f42cHI-Y5KhEdSkVczHcA52E8',
    appId: '1:874658104545:web:e5aed6a49b395c273123a0',
    messagingSenderId: '874658104545',
    projectId: 'kunft-3f7db',
    authDomain: 'kunft-3f7db.firebaseapp.com',
    storageBucket: 'kunft-3f7db.firebasestorage.app',
    measurementId: 'G-N67Z2BXPER',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDO0-cPochDfqZh4btVKeQx1erBAIeyfOI',
    appId: '1:874658104545:ios:677395602e2dc2063123a0',
    messagingSenderId: '874658104545',
    projectId: 'kunft-3f7db',
    storageBucket: 'kunft-3f7db.firebasestorage.app',
    iosClientId: '874658104545-s1158765q7vt6nkskh79akbuudfi2nh0.apps.googleusercontent.com',
    iosBundleId: 'com.example.kunft',
  );

}
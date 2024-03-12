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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD9-EfJrmoBi2C31hkBdEDxC2Tj4p4AzKk',
    appId: '1:929345678957:web:91fb79033fff4d3b35d964',
    messagingSenderId: '929345678957',
    projectId: 'konami-bet',
    authDomain: 'konami-bet.firebaseapp.com',
    storageBucket: 'konami-bet.appspot.com',
    measurementId: 'G-8JC2WWBSSS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkZVAGLDyQ9e-HdKDj-cMJzl8pI1O-zFU',
    appId: '1:929345678957:android:8a023502843dd3a135d964',
    messagingSenderId: '929345678957',
    projectId: 'konami-bet',
    storageBucket: 'konami-bet.appspot.com',
  );
}

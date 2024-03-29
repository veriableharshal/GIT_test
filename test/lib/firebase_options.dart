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
        return macos;
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
    apiKey: 'AIzaSyBKJDprCGxkFvxGdFCo5eQf2UgOIJD8ZO4',
    appId: '1:35882450225:web:bae5e360482e45e2b44410',
    messagingSenderId: '35882450225',
    projectId: 'testproject-a44ff',
    authDomain: 'testproject-a44ff.firebaseapp.com',
    storageBucket: 'testproject-a44ff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9Y2H9Q3L2FmwMKu0UYkaN16136ceGooo',
    appId: '1:35882450225:android:7a5f170e6a01b518b44410',
    messagingSenderId: '35882450225',
    projectId: 'testproject-a44ff',
    storageBucket: 'testproject-a44ff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcKYRoK2fiklAGs1_qO-0BaQHaU-0v6N0',
    appId: '1:35882450225:ios:e213e49901de2465b44410',
    messagingSenderId: '35882450225',
    projectId: 'testproject-a44ff',
    storageBucket: 'testproject-a44ff.appspot.com',
    iosClientId: '35882450225-6ak99hnnhfov9g80rckh2nt5ectv5orq.apps.googleusercontent.com',
    iosBundleId: 'com.example.test',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAcKYRoK2fiklAGs1_qO-0BaQHaU-0v6N0',
    appId: '1:35882450225:ios:e213e49901de2465b44410',
    messagingSenderId: '35882450225',
    projectId: 'testproject-a44ff',
    storageBucket: 'testproject-a44ff.appspot.com',
    iosClientId: '35882450225-6ak99hnnhfov9g80rckh2nt5ectv5orq.apps.googleusercontent.com',
    iosBundleId: 'com.example.test',
  );
}

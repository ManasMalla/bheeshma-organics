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
    apiKey: 'AIzaSyAkleuvSpPgbu5OXyoPYQR__ivnN77a924',
    appId: '1:28134828757:web:9ebefe08a9fe334b78905c',
    messagingSenderId: '28134828757',
    projectId: 'bheeshma-naturals',
    authDomain: 'bheeshma-naturals.firebaseapp.com',
    storageBucket: 'bheeshma-naturals.appspot.com',
    measurementId: 'G-NTP13F98YZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVemrJYU7JAXypa2LNHN1SKWy7rG3fkqI',
    appId: '1:28134828757:android:1c75dd1c614e6aeb78905c',
    messagingSenderId: '28134828757',
    projectId: 'bheeshma-naturals',
    storageBucket: 'bheeshma-naturals.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBexWKJ1C7szpUfgzDiezW3vZ1TpYONcFk',
    appId: '1:28134828757:ios:0231c5afe37e057678905c',
    messagingSenderId: '28134828757',
    projectId: 'bheeshma-naturals',
    storageBucket: 'bheeshma-naturals.appspot.com',
    iosBundleId: 'com.manasmalla.bheeshmaorganics',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBexWKJ1C7szpUfgzDiezW3vZ1TpYONcFk',
    appId: '1:28134828757:ios:741532a71091de2c78905c',
    messagingSenderId: '28134828757',
    projectId: 'bheeshma-naturals',
    storageBucket: 'bheeshma-naturals.appspot.com',
    iosBundleId: 'com.manasmalla.bheeshmaorganics.RunnerTests',
  );
}

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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQdR4C_iJ_n365SaV7rSYsoqQ1q5PhBAY',
    appId: '1:1077526061292:android:d2b53a00b0504069bf05c9',
    messagingSenderId: '1077526061292',
    projectId: 'hackerearth-mtn-bj-2022',
    storageBucket: 'hackerearth-mtn-bj-2022.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA13_UU_RDf9_OlhUbHrCl0Dgz6wOAmWKo',
    appId: '1:1077526061292:ios:97f4da2536eee171bf05c9',
    messagingSenderId: '1077526061292',
    projectId: 'hackerearth-mtn-bj-2022',
    storageBucket: 'hackerearth-mtn-bj-2022.appspot.com',
    iosClientId: '1077526061292-ofeb5vc7oc5hi9eiqi40t3gge762t4qi.apps.googleusercontent.com',
    iosBundleId: 'com.corel.hackerearthMtnBj2022',
  );
}

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
    apiKey: 'AIzaSyAoOwaS4MAIW5w1FxDuex4mNT8XuzFB_GA',
    appId: '1:183655944920:web:f2b7f1399ba7b3fffbfdad',
    messagingSenderId: '183655944920',
    projectId: 'fir-firestore-3c1c4',
    authDomain: 'fir-firestore-3c1c4.firebaseapp.com',
    storageBucket: 'fir-firestore-3c1c4.appspot.com',
    measurementId: 'G-8SZFHZE88B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDT5kZ6X-5w7yb9SH4iDgZ-EwwDO9qBlWU',
    appId: '1:183655944920:android:622f8a00c01d277ffbfdad',
    messagingSenderId: '183655944920',
    projectId: 'fir-firestore-3c1c4',
    storageBucket: 'fir-firestore-3c1c4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADYrj3KDgWVfmzyVbbf4PtT-DJsCzqSn8',
    appId: '1:183655944920:ios:71d2f161cbb51f9dfbfdad',
    messagingSenderId: '183655944920',
    projectId: 'fir-firestore-3c1c4',
    storageBucket: 'fir-firestore-3c1c4.appspot.com',
    iosBundleId: 'com.example.firebaseFirestore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADYrj3KDgWVfmzyVbbf4PtT-DJsCzqSn8',
    appId: '1:183655944920:ios:71d2f161cbb51f9dfbfdad',
    messagingSenderId: '183655944920',
    projectId: 'fir-firestore-3c1c4',
    storageBucket: 'fir-firestore-3c1c4.appspot.com',
    iosBundleId: 'com.example.firebaseFirestore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAoOwaS4MAIW5w1FxDuex4mNT8XuzFB_GA',
    appId: '1:183655944920:web:f3328ed6062f4f07fbfdad',
    messagingSenderId: '183655944920',
    projectId: 'fir-firestore-3c1c4',
    authDomain: 'fir-firestore-3c1c4.firebaseapp.com',
    storageBucket: 'fir-firestore-3c1c4.appspot.com',
    measurementId: 'G-V1NJSSLF0Y',
  );
}
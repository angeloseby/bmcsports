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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAn0_n-xVS4Hl4nE9tYu7Go6l3ZI3qFqt0',
    appId: '1:1063072137159:web:4d554cd80b4e31e982a3e2',
    messagingSenderId: '1063072137159',
    projectId: 'bmcsports2025',
    authDomain: 'bmcsports2025.firebaseapp.com',
    storageBucket: 'bmcsports2025.firebasestorage.app',
    measurementId: 'G-RYCP788QYH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCuo0tAm1UwouV5Cgjn55_bpAC72iIKwG4',
    appId: '1:1063072137159:android:927e59ec5df2be0782a3e2',
    messagingSenderId: '1063072137159',
    projectId: 'bmcsports2025',
    storageBucket: 'bmcsports2025.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAixoYrXnU2BoYcADvy2NB3jY_96t8tnvo',
    appId: '1:1063072137159:ios:af5a2bd84101905582a3e2',
    messagingSenderId: '1063072137159',
    projectId: 'bmcsports2025',
    storageBucket: 'bmcsports2025.firebasestorage.app',
    iosBundleId: 'com.example.bmcsports',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAn0_n-xVS4Hl4nE9tYu7Go6l3ZI3qFqt0',
    appId: '1:1063072137159:web:4d554cd80b4e31e982a3e2',
    messagingSenderId: '1063072137159',
    projectId: 'bmcsports2025',
    authDomain: 'bmcsports2025.firebaseapp.com',
    storageBucket: 'bmcsports2025.firebasestorage.app',
    measurementId: 'G-RYCP788QYH',
  );

}
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
    apiKey: 'AIzaSyDfIggc6psLSDnPp8XB75s7f_32AKPmtUc',
    appId: '1:332900438923:web:53ea4453c4b2c00bf9958e',
    messagingSenderId: '332900438923',
    projectId: 'brightmind-1e4fd',
    authDomain: 'brightmind-1e4fd.firebaseapp.com',
    storageBucket: 'brightmind-1e4fd.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvFWWNIR3X5gUWsCT5t9syF1Fd-WYmqoY',
    appId: '1:332900438923:android:ee9e87846922d546f9958e',
    messagingSenderId: '332900438923',
    projectId: 'brightmind-1e4fd',
    storageBucket: 'brightmind-1e4fd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzHT-Krfik1Rl_fmVrhiiz2Y_sxj78jbY',
    appId: '1:332900438923:ios:a93741d1ada8dbf1f9958e',
    messagingSenderId: '332900438923',
    projectId: 'brightmind-1e4fd',
    storageBucket: 'brightmind-1e4fd.firebasestorage.app',
    iosBundleId: 'com.example.brightmind',
  );

}
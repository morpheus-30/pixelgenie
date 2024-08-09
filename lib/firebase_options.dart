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
    apiKey: 'AIzaSyDauBq26CJFmMTYICIuhNBfid6iRZR77tw',
    appId: '1:564764828093:web:c6ef1e15a20fa48c34f2d4',
    messagingSenderId: '564764828093',
    projectId: 'pixelgenie-78323',
    authDomain: 'pixelgenie-78323.firebaseapp.com',
    storageBucket: 'pixelgenie-78323.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbxXQT_i-0URDpi4FY25V9x_0u92C2B0M',
    appId: '1:564764828093:android:82bad9997a3a11e834f2d4',
    messagingSenderId: '564764828093',
    projectId: 'pixelgenie-78323',
    storageBucket: 'pixelgenie-78323.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA16cUrBeMhuoUOyDdJd-54LK1IcwT0rO4',
    appId: '1:564764828093:ios:b37a2a218a412bb834f2d4',
    messagingSenderId: '564764828093',
    projectId: 'pixelgenie-78323',
    storageBucket: 'pixelgenie-78323.appspot.com',
    androidClientId: '564764828093-m24grm7qfckc50qh2pkufs1f8365vfp9.apps.googleusercontent.com',
    iosClientId: '564764828093-97dqpqf9v8a98fev5vhm7es02cs2t04i.apps.googleusercontent.com',
    iosBundleId: 'com.example.pixelgenie',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA16cUrBeMhuoUOyDdJd-54LK1IcwT0rO4',
    appId: '1:564764828093:ios:b37a2a218a412bb834f2d4',
    messagingSenderId: '564764828093',
    projectId: 'pixelgenie-78323',
    storageBucket: 'pixelgenie-78323.appspot.com',
    androidClientId: '564764828093-m24grm7qfckc50qh2pkufs1f8365vfp9.apps.googleusercontent.com',
    iosClientId: '564764828093-97dqpqf9v8a98fev5vhm7es02cs2t04i.apps.googleusercontent.com',
    iosBundleId: 'com.example.pixelgenie',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDauBq26CJFmMTYICIuhNBfid6iRZR77tw',
    appId: '1:564764828093:web:773dc9e2f5c178d134f2d4',
    messagingSenderId: '564764828093',
    projectId: 'pixelgenie-78323',
    authDomain: 'pixelgenie-78323.firebaseapp.com',
    storageBucket: 'pixelgenie-78323.appspot.com',
  );

}
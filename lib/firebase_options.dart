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
    apiKey: 'AIzaSyBZi3G7eqdptSWmuMTjVZdUrkOLzXa4Ji8',
    appId: '1:343667912132:web:8b8c9206a2d595406f0891',
    messagingSenderId: '343667912132',
    projectId: 'instagram-c-b919f',
    authDomain: 'instagram-c-b919f.firebaseapp.com',
    storageBucket: 'instagram-c-b919f.appspot.com',
    measurementId: 'G-00351N86J5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTDUr4J1KqXBDFTARGfor2SlWtBcM_IyA',
    appId: '1:343667912132:android:9d3213e917dadbb46f0891',
    messagingSenderId: '343667912132',
    projectId: 'instagram-c-b919f',
    storageBucket: 'instagram-c-b919f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRgTa9SoAqlKLJYZKArWGNACk1jmtMvVo',
    appId: '1:343667912132:ios:62044a5eb35102306f0891',
    messagingSenderId: '343667912132',
    projectId: 'instagram-c-b919f',
    storageBucket: 'instagram-c-b919f.appspot.com',
    iosClientId: '343667912132-u4qd0kkn8hpfiqqdj6ijl0o7rg8jq3ds.apps.googleusercontent.com',
    iosBundleId: 'com.example.insta.insta',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBRgTa9SoAqlKLJYZKArWGNACk1jmtMvVo',
    appId: '1:343667912132:ios:62044a5eb35102306f0891',
    messagingSenderId: '343667912132',
    projectId: 'instagram-c-b919f',
    storageBucket: 'instagram-c-b919f.appspot.com',
    iosClientId: '343667912132-u4qd0kkn8hpfiqqdj6ijl0o7rg8jq3ds.apps.googleusercontent.com',
    iosBundleId: 'com.example.insta.insta',
  );
}

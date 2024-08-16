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
    apiKey: 'AIzaSyAJIG_z2NT_pmQslMuM0xPiqHKKqr204C0',
    appId: '1:687362316502:web:63c1fd3948cd62ed631177',
    messagingSenderId: '687362316502',
    projectId: 'chat-app-1bdc7',
    authDomain: 'chat-app-1bdc7.firebaseapp.com',
    storageBucket: 'chat-app-1bdc7.appspot.com',
    measurementId: 'G-ZTBGHVLM2N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDl8XlGiYX5Lw1v49htxsYKJ_gh7hrZh_I',
    appId: '1:687362316502:android:2c101c31fabefd8f631177',
    messagingSenderId: '687362316502',
    projectId: 'chat-app-1bdc7',
    storageBucket: 'chat-app-1bdc7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAbAyzEh2bohAPQWNRZpkspdE7mjPwwMfA',
    appId: '1:687362316502:ios:705faa46d28ecd36631177',
    messagingSenderId: '687362316502',
    projectId: 'chat-app-1bdc7',
    storageBucket: 'chat-app-1bdc7.appspot.com',
    iosBundleId: 'com.example.flutterChatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAbAyzEh2bohAPQWNRZpkspdE7mjPwwMfA',
    appId: '1:687362316502:ios:705faa46d28ecd36631177',
    messagingSenderId: '687362316502',
    projectId: 'chat-app-1bdc7',
    storageBucket: 'chat-app-1bdc7.appspot.com',
    iosBundleId: 'com.example.flutterChatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJIG_z2NT_pmQslMuM0xPiqHKKqr204C0',
    appId: '1:687362316502:web:d0f4f3c78580e587631177',
    messagingSenderId: '687362316502',
    projectId: 'chat-app-1bdc7',
    authDomain: 'chat-app-1bdc7.firebaseapp.com',
    storageBucket: 'chat-app-1bdc7.appspot.com',
    measurementId: 'G-WX9549F3D0',
  );
}

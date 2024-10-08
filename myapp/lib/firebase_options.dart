// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDtUfIDDSPJKwFGXN-J7SQrEhy-sM6vbk0',
    appId: '1:861241930730:web:4724f1cf4edfaac75eb893',
    messagingSenderId: '861241930730',
    projectId: 'hoophub-643b1',
    authDomain: 'hoophub-643b1.firebaseapp.com',
    databaseURL: 'https://hoophub-643b1-default-rtdb.firebaseio.com',
    storageBucket: 'hoophub-643b1.appspot.com',
    measurementId: 'G-G00PZZQ0DL',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKrT4PgA49hnGrw0HmLRxFGrN8lzQf5No',
    appId: '1:861241930730:ios:bac19865b66892c35eb893',
    messagingSenderId: '861241930730',
    projectId: 'hoophub-643b1',
    databaseURL: 'https://hoophub-643b1-default-rtdb.firebaseio.com',
    storageBucket: 'hoophub-643b1.appspot.com',
    iosBundleId: 'com.example.myapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKrT4PgA49hnGrw0HmLRxFGrN8lzQf5No',
    appId: '1:861241930730:ios:bac19865b66892c35eb893',
    messagingSenderId: '861241930730',
    projectId: 'hoophub-643b1',
    databaseURL: 'https://hoophub-643b1-default-rtdb.firebaseio.com',
    storageBucket: 'hoophub-643b1.appspot.com',
    iosBundleId: 'com.example.myapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDtUfIDDSPJKwFGXN-J7SQrEhy-sM6vbk0',
    appId: '1:861241930730:web:b160cc275a3b3e2d5eb893',
    messagingSenderId: '861241930730',
    projectId: 'hoophub-643b1',
    authDomain: 'hoophub-643b1.firebaseapp.com',
    databaseURL: 'https://hoophub-643b1-default-rtdb.firebaseio.com',
    storageBucket: 'hoophub-643b1.appspot.com',
    measurementId: 'G-VY5XWRK7SZ',
  );

}
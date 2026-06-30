import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkyCflgg99QpEMm1_7itweuZm7jCgqUaY',
    appId: '1:1030140401902:android:ce91aa2670280daf8e3bff',
    messagingSenderId: '1030140401902',
    projectId: 'quickride-1eb1a',
    storageBucket: 'quickride-1eb1a.appspot.com',
  );

  // Placeholder — update with real iOS config if needed
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCkyCflgg99QpEMm1_7itweuZm7jCgqUaY',
    appId: '1:1030140401902:ios:ce91aa2670280daf8e3bff',
    messagingSenderId: '1030140401902',
    projectId: 'quickride-1eb1a',
    storageBucket: 'quickride-1eb1a.appspot.com',
    iosBundleId: 'com.example.quickFrontend',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCkyCflgg99QpEMm1_7itweuZm7jCgqUaY',
    appId: '1:1030140401902:web:ce91aa2670280daf8e3bff',
    messagingSenderId: '1030140401902',
    projectId: 'quickride-1eb1a',
    storageBucket: 'quickride-1eb1a.appspot.com',
  );
}

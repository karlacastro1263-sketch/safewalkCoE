import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Si luego agregas Web, crea un bloque "web" con sus valores y quita este throw.
      throw UnsupportedError(
        'Web no está configurado en firebase_options.dart',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios; // Puedes usar los mismos valores que para iOS si quieres
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return android; // O lanzar un error amigable si no se soporta
      case TargetPlatform.fuchsia:
        throw UnimplementedError();
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCB-S30mSdaENVq5ZMamJ_0O5cvcKhegYk',
    appId: '1:732792413361:android:11d5ccfeaa6d3b9e2a1690',
    messagingSenderId: '732792413361',
    projectId: 'app-prueba-7495f',
    storageBucket: 'app-prueba-7495f.firebasestorage.app',
  );

  // --- ANDROID ---

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxKHnX1OEZqC5f16SrhEEFU4cPunK3tRs',
    appId: '1:732792413361:ios:6c06e271912865e82a1690',
    messagingSenderId: '732792413361',
    projectId: 'app-prueba-7495f',
    storageBucket: 'app-prueba-7495f.firebasestorage.app',
    iosBundleId: 'com.example.appPrueba',
  );

  // --- iOS ---
}

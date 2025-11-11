import 'package:app_prueba/Pantallas/bienvenido_tutor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Iniciar la aplicación
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloqueo de orientación en vertical
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeWalk App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F4F9),
        primaryColor: const Color(0xFFF6C67A),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF2EB79B),
              width: 2,
            ),
          ),
          labelStyle: TextStyle(color: Color(0xFF69A6A1)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            const BienvenidoTutor(), // Usamos BienvenidoTutor como ruta inicial
      },
      // Fallback si se navega a una ruta no registrada
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const BienvenidoTutor()),
    );
  }
}

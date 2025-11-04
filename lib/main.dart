import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Pantallas
import 'Pantallas/bienvenido.dart'; // Bienvenida
import 'Pantallas/inicio_sesion.dart'; // InicioSesion
import 'Pantallas/registro.dart'; // Registro
import 'Pantallas/recuperar_contrasena.dart'; // RecuperarContrasena
import 'Pantallas/obstaculos.dart'; // Obstaculos
import 'Pantallas/comenzar.dart'; // Comenzar
import 'Pantallas/cuenta.dart'; // Cuenta
import 'Pantallas/bluetooth.dart' hide Configuracion; // BluetoothScreen
import 'Pantallas/configuracion.dart'; // Configuracion
import 'Pantallas/inicio_tutor.dart'; // InicioTutor
import 'Pantallas/conecta_tutor.dart'; // ConectaTutor

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
      initialRoute: '/', // Cambiado para que apunte a la pantalla Bienvenida
      routes: {
        '/': (context) =>
            const Bienvenida(), // Usamos Bienvenida como ruta inicial
        '/inicioSesion': (context) => const InicioSesion(),
        '/registro': (context) => const Registro(),
        '/recuperarContrasena': (context) => const RecuperarContrasena(),
        '/obstaculos': (context) => const Obstaculos(),
        '/comenzar': (context) => const Comenzar(),
        '/cuenta': (context) => const Cuenta(),
        '/bluetooth': (context) => const BluetoothScreen(),
        '/configuracion': (context) => const Configuracion(),
        '/inicioTutor': (context) => const InicioTutor(),
        '/conectaTutor': (context) => const ConectaTutor(),
      },
      // Fallback si se navega a una ruta no registrada
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const Bienvenida()),
    );
  }
}

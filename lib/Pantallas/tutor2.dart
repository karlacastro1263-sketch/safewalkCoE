// archivo: tutor2.dart
import 'package:flutter/material.dart';
import 'bienvenido.dart';               // mismo folder
import 'configuracion_tutor.dart';      // mismo folder

class Tutor2 extends StatefulWidget {
  const Tutor2({super.key});

  @override
  State<Tutor2> createState() => _Tutor2State();
}

class _Tutor2State extends State<Tutor2> {
  @override
  Widget build(BuildContext context) {
    const turquesa = Color(0xFF2EB79B);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Contenido principal
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Ubicación en tiempo real',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Imagen + fondo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/tutor_fondo2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/tutor2.png',
                        width: 350,
                        height: 350,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Descripción
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Como contacto de emergencia, podrás ver en el mapa dónde está la '
                      'persona con discapacidad visual y su último punto conocido.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Inferior: Omitir / Empezar ya
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Omitir
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Bienvenida()),
                      );
                    },
                    child: const Text(
                      'Omitir',
                      style: TextStyle(
                        color: Color(0xFF2EB79B),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Empezar ya → ConfiguracionTutor
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfiguracionTutor(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: turquesa,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text(
                      'Empezar ya',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

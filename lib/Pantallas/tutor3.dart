// archivo: tutor3.dart
import 'package:app_prueba/Pantallas/bienvenido.dart';
import 'package:flutter/material.dart';
import 'package:app_prueba/Pantallas/configuracion_tutor.dart'; // 👈 va a ConfiguracionTutor

class Tutor3 extends StatefulWidget {
  const Tutor3({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Tutor3State createState() => _Tutor3State();
}

class _Tutor3State extends State<Tutor3> {
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
                  // Título arriba
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Gestiona los Contactos de Emergencia.',
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
                        width: 370,
                        height: 370,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/tutor_fondo2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/tutor3.png',
                        width: 400,
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Descripción
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Supervisa y administra fácilmente los contactos de apoyo de la persona a tu cuidado. '
                      'Mantén su información actualizada y asegúrate de que siempre haya alguien disponible para responder ante una emergencia.',
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

            // Parte inferior con Omitir y Siguiente
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
                        color: turquesa,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Siguiente -> ConfiguracionTutor
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfiguracionTutor(), // 👈 aquí
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
                      'Siguiente',
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

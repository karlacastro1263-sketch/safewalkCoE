import 'package:flutter/material.dart';
import 'obstaculos.dart'; // Pantalla siguiente
import 'bienvenido.dart'; // Pantalla anterior

class Conecta extends StatefulWidget {
  const Conecta({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConectaState createState() => _ConectaState();
}

class _ConectaState extends State<Conecta> {
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
                      'Camina con confianza, paso a paso.',
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
                            image: AssetImage('assets/images/fondo_conecta.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/conecta.png',
                        width: 440,
                        height: 440,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40), // Texto más abajo que antes

                  // Descripción
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'SafeWalk se conecta con tu gorro inteligente Navicap para detectar obstáculos y avisarte de forma clara y accesible.',
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

                  // Siguiente
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Obstaculos()),
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

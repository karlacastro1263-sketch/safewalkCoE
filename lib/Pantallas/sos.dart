import 'package:flutter/material.dart';
import 'comenzar.dart';  // Ahora la pantalla siguiente es Comenzar

class SOS extends StatelessWidget {
  const SOS({super.key});

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
                  // Título arriba de la imagen
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    child: Text(
                      'Nunca caminas solo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Imagen fondo + sos
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 380,
                        height: 380,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/fondo_sos.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 440,
                        height: 440,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/sos.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Texto descriptivo
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Configura tus contactos de emergencia en SafeWalk. '
                      'Si tienes una emergencia, la app enviará una alerta para avisarles '
                      'y ayudarte rápidamente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Botón grande "Empezar ya"
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Comenzar()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: turquesa,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Empezar ya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

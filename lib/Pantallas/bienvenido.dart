import 'package:flutter/material.dart';
import 'conecta.dart'; // Pantalla siguiente
import 'registro2.dart'; // Pantalla de registro/login

class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    // Panel donde se coloca el fondo y los elementos
    const double panelWidth = 300;
    const double panelHeight = 500;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: panelWidth,
            height: panelHeight,
            child: Stack(
              children: [
                // ---------- Fondo ----------
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/fondo_inicio.png',
                    width: panelWidth,
                    height: panelHeight,
                    fit: BoxFit.cover,
                  ),
                ),

                // ---------- Título ----------
                const Positioned(
                  top: -14,
                  left: 12,
                  right: 12,
                  child: Text(
                    'SafeWalk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                // ---------- Subtítulo ----------
                const Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Text(
                    'Tu compañero de movilidad: seguro, inteligente y accesible.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // ---------- Imagen central ----------
                Positioned(
                  top: 85,
                  left: 0,
                  right: 0,
                  bottom: 110, // deja más espacio para los botones
                  child: Center(
                    child: Image.asset(
                      'assets/images/imagen_inicio.png',
                      width: panelWidth * 0.95,
                      height: panelHeight * 0.50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // ---------- Botón "Comienza ya" ----------
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 30, // más arriba que el enlace
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Conecta()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EB79B),
                      minimumSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Comienza ya',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // ---------- Enlace "Iniciar sesión" más abajo ----------
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -4, // ahora más separado del botón
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Registro2()),
                        );
                      },
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF2EB79B),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF2EB79B),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

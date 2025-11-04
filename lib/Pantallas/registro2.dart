import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'registro.dart'; // pantalla de registro con correo
import 'inicio_sesion.dart'; // pantalla de inicio de sesión
import 'conecta.dart'; // pantalla a la que se redirige después del inicio de sesión

class Registro2 extends StatelessWidget {
  const Registro2({super.key});

  // Función para iniciar sesión con Google
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Iniciar sesión con Google
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Obtener credenciales de Google
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión con Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Redirigir a la pantalla siguiente
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Conecta()),
      );
    } catch (e) {
      // Mostrar error en caso de fallo
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Google: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Título principal
                  const Text(
                    'Registro',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Imagen con fondo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 350,
                        height: 350,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/fondo_registroyinicio.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/registroyinicio.png',
                        width: 360,
                        height: 360,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // Texto secundario
                  const Text(
                    'Elige con que registrarte:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Texto de términos y política
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Al crear una cuenta, aceptas nuestros Términos y confirmas haber leído nuestra Política de privacidad.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Sección inferior
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Botón Google
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _signInWithGoogle(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            width: 22,
                            height: 22,
                          ),
                          label: const Text(
                            'Google',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Botón continuar con correo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navegar a pantalla de registro con correo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Registro(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.mail, color: Colors.white),
                    label: const Text(
                      'Continuar con Correo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EB79B),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Texto enlace → ir a inicio de sesión
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InicioSesion(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Ya tienes una cuenta? Ingresa aquí',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

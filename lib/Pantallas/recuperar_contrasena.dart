import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecuperarContrasenaState createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
  final TextEditingController _emailController = TextEditingController();

  // Mostrar un mensaje en un SnackBar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Función para enviar correo de restablecimiento de contraseña
  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar(context, 'Por favor, ingresa tu correo electrónico.');
      return;
    }

    try {
      // Enviar correo de restablecimiento de contraseña
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Mostrar mensaje de éxito
      // ignore: use_build_context_synchronously
      _showSnackBar(context, 'Correo enviado. Revisa tu bandeja de entrada.');

      // Redirigir al usuario a la pantalla de inicio de sesión
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/inicioSesion');
    } catch (e) {
      // Mostrar error en caso de fallo
      // ignore: use_build_context_synchronously
      _showSnackBar(context, 'Error al enviar el correo: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4F6), // Fondo de color sólido (puedes ajustarlo)
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Título Restablecer contraseña
                  const Text(
                    'Restablecer contraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Imagen de la contraseña debajo del título
                  Container(
                    height: 200, // Ajusta el tamaño de la imagen
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/recuperar_contrasena.png'), // Ruta de la imagen
                        fit: BoxFit.contain, // Ajuste de la imagen sin distorsión
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Espacio debajo de la imagen

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Por favor verifica tu correo electrónico para ver la nueva contraseña generada.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54, // Color para la descripción
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Campo de correo electrónico
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botón para continuar
                  ElevatedButton(
                    onPressed: _resetPassword, // Llama a la función para restablecer la contraseña
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EB79B), // Color del botón
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Enlace para volver a iniciar sesión
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/inicioSesion');
                    },
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

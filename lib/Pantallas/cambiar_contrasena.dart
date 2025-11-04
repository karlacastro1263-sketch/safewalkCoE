import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cuenta.dart'; // Para volver a la pantalla de cuenta

class CambiarContrasena extends StatefulWidget {
  const CambiarContrasena({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CambiarContrasenaState createState() => _CambiarContrasenaState();
}

class _CambiarContrasenaState extends State<CambiarContrasena> {
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Función para cambiar la contraseña
  Future<void> _cambiarContrasena() async {
    String nuevaContrasena = _passwordController.text.trim();

    if (nuevaContrasena.isEmpty) {
      // Mostrar un mensaje si la contraseña está vacía
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa una nueva contraseña.')),
      );
      return;
    }

    try {
      // Obtener el usuario actual
      User? user = _auth.currentUser;
      if (user != null) {
        // Cambiar la contraseña en Firebase
        await user.updatePassword(nuevaContrasena);

        // Mostrar un mensaje de éxito
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contraseña cambiada exitosamente')),
        );

        // Volver a la pantalla de cuenta
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Cuenta()),
        );
      } else {
        // Si no hay un usuario autenticado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo cambiar la contraseña.')),
        );
      }
    } catch (e) {
      // Mostrar un error si algo falla
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Cuenta()),
            );
          },
        ),
        title: const Text(
          "Cambiar contraseña",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Imagen candado
            Center(
              child: Image.asset(
                "assets/images/cambiar_contraseña.png",
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),

            // Campo contraseña
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Introduzca la nueva contraseña",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Botón Continuar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _cambiarContrasena, // Llama la función para cambiar la contraseña
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EB79B),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Continuar",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

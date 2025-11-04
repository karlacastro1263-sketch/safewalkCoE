import 'package:flutter/material.dart';
import 'comenzar.dart'; // Pantalla anterior
import 'editar_cuenta.dart'; // Pantalla editar cuenta
import 'cambiar_contrasena.dart'; // 👉 Importar pantalla cambiar contraseña

class Cuenta extends StatelessWidget {
  const Cuenta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Comenzar()),
            );
          },
        ),
        title: const Text(
          "Cuenta",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/cuenta.png", // Imagen de cuenta
                width: 190,
                height: 190,
              ),
            ),
            const SizedBox(height: 30),

            // 👉 Navega a editar_cuenta.dart
            ListTile(
              title: const Text(
                "Editar Cuenta",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditarCuenta()),
                );
              },
            ),
            const Divider(height: 1),

            // 👉 Navega a cambiar_contraseña.dart
            ListTile(
              title: const Text(
                "Cambiar Contraseña",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CambiarContrasena()),
                );
              },
            ),
            const Divider(height: 1),

            ListTile(
              title: const Text(
                "Eliminar Cuenta",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                // Aquí puedes poner lógica de eliminar cuenta
              },
            ),
            const Divider(height: 8),

            // Botón de cerrar sesión
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Cerrar Sesión",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// archivo: cuenta_tutor.dart
import 'package:flutter/material.dart';
import 'editar_cuenta.dart';
import 'configuracion_tutor.dart';          // volver con la flecha
import 'cambiar_contrasena_tutor.dart';    // 👈 usar la versión TUTOR

class CuentaTutor extends StatelessWidget {
  const CuentaTutor({super.key});

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
              MaterialPageRoute(builder: (context) => const ConfiguracionTutor()),
            );
          },
        ),
        title: const Text(
          "Cuenta Tutor",
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
                "assets/images/cuenta.png",
                width: 190,
                height: 190,
              ),
            ),
            const SizedBox(height: 30),

            // Editar cuenta
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

            // Cambiar contraseña  -> CambiarContrasenaTutor
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
                    builder: (_) => const CambiarContrasenaTutor(), // 👈 aquí
                  ),
                );
              },
            ),
            const Divider(height: 1),

            // Eliminar cuenta
            ListTile(
              title: const Text(
                "Eliminar Cuenta",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
              },
            ),
            const Divider(height: 8),

            // Cerrar sesión
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

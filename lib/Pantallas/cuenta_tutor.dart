// archivo: cuenta_tutor.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'editar_cuenta.dart';
import 'configuracion_tutor.dart';
import 'cambiar_contrasena_tutor.dart';

class CuentaTutor extends StatelessWidget {
  const CuentaTutor({super.key});

  Future<void> _confirmAndSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Quieres cerrar tu sesión ahora?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Sí, cerrar'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    // Cerrar sesión
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // Ignora errores de signOut para no bloquear la UX
    }

    // Aviso y navegación
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada')),
      );
      // Vuelve al primer route (tu auth guard debería mandar al login)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

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
      body: Center( // ← centra el bloque completo
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420), // centrado “limpio”
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // ← centra textos
                children: [
                  // Imagen centrada
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: const Text(
                      "Editar Cuenta",
                      textAlign: TextAlign.center, // ← centra el texto
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

                  // Cambiar contraseña
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: const Text(
                      "Cambiar Contraseña",
                      textAlign: TextAlign.center, // ← centra el texto
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CambiarContrasenaTutor(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),

                  // Eliminar cuenta (placeholder)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: const Text(
                      "Eliminar Cuenta",
                      textAlign: TextAlign.center, // ← centra el texto
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                    },
                  ),
                  const Divider(height: 24),

                  // Cerrar sesión (centrado y con confirmación)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => _confirmAndSignOut(context),
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        "Cerrar Sesión",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

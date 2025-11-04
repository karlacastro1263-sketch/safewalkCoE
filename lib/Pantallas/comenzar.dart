import 'package:flutter/material.dart';
import 'cuenta.dart'; // Importa la pantalla de Cuenta

class Comenzar extends StatefulWidget {
  const Comenzar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ComenzarState createState() => _ComenzarState();
}

class _ComenzarState extends State<Comenzar> {
  int _selectedIndex = 3; // Configuración seleccionado por defecto

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Si toca "Cuenta", abrimos cuenta.dart
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Cuenta()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // Icono luna arriba a la derecha
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                },
                icon: const Icon(Icons.nightlight_round,
                    color: Colors.black, size: 28),
              ),
            ),
            const SizedBox(height: 10),

            // Título
            const Text(
              "Configuración",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Imagen central
            Center(
              child: Image.asset(
                "assets/images/configuracion.png", // engranaje
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),

            // Opciones de configuración
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text("Cuenta",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Cuenta()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    title: Text("Notificaciones",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    title: Text("Lenguaje",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    title: Text("Ayuda y soporte",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Barra inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF2EB79B),
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // aquí está Cuenta
            label: "Cuenta",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notificaciones",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volume_up),
            label: "Sonido",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Config",
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'cuenta_tutor.dart';              // 👉 Pantalla de Cuenta del tutor
import 'mapa_screen.dart';              // 👉 Pantalla de Mapa
import 'configuracion_avanzada.dart';   // 👉 NUEVO: pantalla Configuración Avanzada

class ConfiguracionTutor extends StatefulWidget {
  const ConfiguracionTutor({super.key});

  @override
  State<ConfiguracionTutor> createState() => _ConfiguracionTutorState();
}

class _ConfiguracionTutorState extends State<ConfiguracionTutor> {
  int _selectedIndex = 0; // índice inicial válido

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Cuenta
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CuentaTutor()),
      );
    }

    // Mapa
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapaScreen()),
      );
    }

    // Config (básica) -> aquí puedes agregar algo si luego lo necesitas
    if (index == 2) {}

    // NUEVO: Configuración Avanzada
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConfiguracionAvanzada()),
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
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  // Lógica para el ícono de luna (opcional)
                },
                icon: const Icon(Icons.nightlight_round,
                    color: Colors.black, size: 28),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Configuración Tutor",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                "assets/images/configuracion.png", // engranaje
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text(
                      "Cuenta",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CuentaTutor()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    title: Text(
                      "Lenguaje",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    title: Text(
                      "Ayuda y soporte",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF2EB79B),
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),   // Cuenta
            label: "Cuenta",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),      // Mapa
            label: "Mapa",
            tooltip: "Abrir mapa (Google Maps)",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Config básica
            label: "Config",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),     // NUEVO: Config Avanzada
            label: "Config Avanzada",
            tooltip: "Abrir Configuración Avanzada",
          ),
        ],
      ),
    );
  }
}

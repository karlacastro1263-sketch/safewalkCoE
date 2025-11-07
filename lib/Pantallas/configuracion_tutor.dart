import 'package:flutter/material.dart';

import 'cuenta_tutor.dart';
import 'bienvenido_tutor.dart';

class ConfiguracionTutor extends StatefulWidget {
  const ConfiguracionTutor({super.key});

  @override
  State<ConfiguracionTutor> createState() => _ConfiguracionTutorState();
}

class _ConfiguracionTutorState extends State<ConfiguracionTutor> {
  int _selectedIndex = 2;

  // Modo oscuro local (luna/sol)
  bool _isDark = false;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return; // Evita navegar si ya está seleccionado
    }
    setState(() => _selectedIndex = index);

    // Home -> BienvenidoTutor
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BienvenidoTutor()),
      );
      return;
    }

    // Config (index == 2) -> ya estamos aquí
  }

  @override
  Widget build(BuildContext context) {
    // Paleta dependiente del modo
    final Color bg = _isDark ? const Color(0xFF121212) : Colors.white;
    final Color text = _isDark ? Colors.white : Colors.black87;
    final Color icon = _isDark ? Colors.white : Colors.black;
    final Color divider = _isDark ? Colors.white24 : Colors.black12;
    const Color primary = Color(0xFF2EB79B);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Botón luna/sol arriba a la derecha
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () => setState(() => _isDark = !_isDark),
                icon: Icon(
                  _isDark ? Icons.light_mode : Icons.nightlight_round,
                  color: icon,
                  size: 28,
                ),
                tooltip: _isDark ? 'Modo claro' : 'Modo oscuro',
              ),
            ),

            // Contenido
            Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "Configuración Tutor",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: text,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset(
                            "assets/images/configuracion.png",
                            width: 180,
                            height: 180,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.settings,
                              size: 120,
                              color: _isDark ? Colors.white24 : Colors.black26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        // Lista de opciones
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              title: Text(
                                "Cuenta",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: text,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: 18, color: text),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const CuentaTutor()),
                                );
                              },
                            ),
                            Divider(height: 1, color: divider),
                            ListTile(
                              title: Text(
                                "Lenguaje",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: text,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: 18, color: text),
                              onTap: () {},
                            ),
                            Divider(height: 1, color: divider),
                            ListTile(
                              title: Text(
                                "Ayuda y soporte",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: text,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: 18, color: text),
                              onTap: () {},
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bg,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primary,
        unselectedItemColor: _isDark ? Colors.white70 : Colors.black54,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined),
            activeIcon: Icon(Icons.house),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Mapa",
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

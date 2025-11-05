import 'package:flutter/material.dart';
import 'cuenta_tutor.dart';
import 'mapa_screen.dart';

class ConfiguracionTutor extends StatefulWidget {
  const ConfiguracionTutor({super.key});

  @override
  State<ConfiguracionTutor> createState() => _ConfiguracionTutorState();
}

class _ConfiguracionTutorState extends State<ConfiguracionTutor> {
  int _selectedIndex = 0;
  bool _isDark = false; // ← modo oscuro local

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

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
    // Config (index == 2) -> sin navegación por ahora
  }

  @override
  Widget build(BuildContext context) {
    // Colores dependientes del modo
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
            // Botón de luna/sol arriba-derecha
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

            // Contenido principal centrado
            Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
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
                            // Evita crash si el asset no existe
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.settings,
                              size: 120,
                              color: _isDark ? Colors.white24 : Colors.black26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        // Lista centrada (sin tarjetas/cuadrados)
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
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: text,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CuentaTutor(),
                                  ),
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
      // Barra inferior con colores adecuados al tema local
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bg,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primary,
        unselectedItemColor: _isDark ? Colors.white70 : Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Cuenta",
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

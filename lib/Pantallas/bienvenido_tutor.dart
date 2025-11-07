import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configuracion_tutor.dart';
import 'ubicacion_ciego.dart'; // ← usamos esta pantalla para "Mapa"

class BienvenidoTutor extends StatefulWidget {
  const BienvenidoTutor({super.key, this.nombre});
  final String? nombre;

  @override
  State<BienvenidoTutor> createState() => _BienvenidoTutorState();
}

class _BienvenidoTutorState extends State<BienvenidoTutor> {
  static const Color _primary = Color(0xFF2EB79B);

  static const String _kDarkMode = 'prefs_dark_mode';
  static const String _kSosCalls = 'prefs_sos_calls_enabled';
  static const String _kSosMsgs = 'prefs_sos_msgs_enabled';

  bool _isDark = false;
  bool _receiveSosCalls = true;
  bool _receiveSosMsgs = true;

  int _selectedIndex = 0; // 0=Home, 1=Mapa, 2=Config

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool(_kDarkMode) ?? false;
      _receiveSosCalls = prefs.getBool(_kSosCalls) ?? true;
      _receiveSosMsgs = prefs.getBool(_kSosMsgs) ?? true;
    });
  }

  Future<void> _saveDark(bool v) async =>
      (await SharedPreferences.getInstance()).setBool(_kDarkMode, v);
  Future<void> _saveCalls(bool v) async =>
      (await SharedPreferences.getInstance()).setBool(_kSosCalls, v);
  Future<void> _saveMsgs(bool v) async =>
      (await SharedPreferences.getInstance()).setBool(_kSosMsgs, v);

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UbicacionCiego()),
      );
      return;
    }
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConfiguracionTutor()),
      );
      return;
    }
    // index == 0 -> Home (esta pantalla)
  }

  @override
  Widget build(BuildContext context) {
    final String saludo =
        'Bienvenido${widget.nombre != null && widget.nombre!.trim().isNotEmpty ? ', ${widget.nombre!.trim()}' : ''}';

    final Color bg = _isDark ? const Color(0xFF121212) : Colors.white;
    final Color text = _isDark ? Colors.white : Colors.black87;
    final Color subtext = _isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),

                        Text(
                          saludo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 86,
                          height: 4,
                          decoration: BoxDecoration(
                            color: _primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Imagen centrada SIN círculo
                        Center(
                          child: Image.asset(
                            'assets/images/sos.png',
                            width: 380,
                            height: 380,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person_pin_circle,
                              size: 160,
                              // ignore: deprecated_member_use
                              color: _primary.withOpacity(.8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Switches
                        SwitchListTile.adaptive(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          title: Text(
                            'Recibir llamadas SOS',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: text),
                          ),
                          subtitle: Text(
                            'Permite llamadas directas al activar una emergencia.',
                            style: TextStyle(fontSize: 13, color: subtext),
                          ),
                          secondary: Icon(Icons.call, color: text),
                          // ignore: deprecated_member_use
                          activeColor: _primary,
                          value: _receiveSosCalls,
                          onChanged: (v) {
                            setState(() => _receiveSosCalls = v);
                            _saveCalls(v);
                          },
                        ),
                        Divider(
                            height: 1,
                            color: _isDark ? Colors.white12 : Colors.black12),
                        SwitchListTile.adaptive(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          title: Text(
                            'Recibir mensajes de SOS',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: text),
                          ),
                          subtitle: Text(
                            'Recibe notificaciones con ubicación y detalles.',
                            style: TextStyle(fontSize: 13, color: subtext),
                          ),
                          secondary: Icon(Icons.sms, color: text),
                          // ignore: deprecated_member_use
                          activeColor: _primary,
                          value: _receiveSosMsgs,
                          onChanged: (v) {
                            setState(() => _receiveSosMsgs = v);
                            _saveMsgs(v);
                          },
                        ),

                        // (Texto final eliminado)
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Botón de modo oscuro (arriba-derecha)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                tooltip: _isDark ? 'Modo claro' : 'Modo oscuro',
                icon: Icon(
                  _isDark ? Icons.light_mode : Icons.nightlight_round,
                  color: _isDark ? Colors.white : Colors.black,
                  size: 26,
                ),
                onPressed: () {
                  setState(() => _isDark = !_isDark);
                  _saveDark(_isDark);
                },
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
        selectedItemColor: _primary,
        unselectedItemColor: _isDark ? Colors.white70 : Colors.black54,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined),
            activeIcon: Icon(Icons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Config',
          ),
        ],
      ),
    );
  }
}

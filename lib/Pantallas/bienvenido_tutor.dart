import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mapa_screen.dart';
import 'configuracion_tutor.dart';

class BienvenidoTutor extends StatefulWidget {
  const BienvenidoTutor({super.key, this.nombre});
  final String? nombre;

  @override
  State<BienvenidoTutor> createState() => _BienvenidoTutorState();
}

class _BienvenidoTutorState extends State<BienvenidoTutor> {
  // ---- Tema y colores
  static const Color _primary = Color(0xFF2EB79B);

  // ---- Claves de persistencia
  static const String _kDarkMode = 'prefs_dark_mode';
  static const String _kSosCalls = 'prefs_sos_calls_enabled';
  static const String _kSosMsgs = 'prefs_sos_msgs_enabled';

  // ---- Estado
  bool _isDark = false;
  bool _receiveSosCalls = true;
  bool _receiveSosMsgs = true;

  // Bottom nav: 0=Home, 1=Mapa, 2=Config
  int _selectedIndex = 0;

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

  // ---- Navegación inferior
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapaScreen()),
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
    // index == 0 -> ya estamos en Home (Bienvenido)
  }

  @override
  Widget build(BuildContext context) {
    final String saludo =
        'Bienvenido${widget.nombre != null && widget.nombre!.trim().isNotEmpty ? ', ${widget.nombre!.trim()}' : ''}';

    final Color bg = _isDark ? const Color(0xFF121212) : Colors.white;
    final Color text = _isDark ? Colors.white : Colors.black87;
    final Color subtext = _isDark ? Colors.white70 : Colors.black54;
    final Color cardBorder = _isDark ? Colors.white10 : Colors.black12;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    const SizedBox(height: 16),

                    // Avatar/ilustración
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // ignore: deprecated_member_use
                        color: _primary.withOpacity(.12),
                        // ignore: deprecated_member_use
                        border: Border.all(color: _primary.withOpacity(.35)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/welcome_tutor.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person_pin_circle,
                          size: 120,
                          // ignore: deprecated_member_use
                          color: _primary.withOpacity(.8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Modo oscuro
                    Card(
                      elevation: 0,
                      color: bg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: cardBorder),
                      ),
                      child: SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        title: Text('Modo oscuro',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: text)),
                        subtitle: Text('Ajusta colores para baja iluminación.',
                            style: TextStyle(fontSize: 13, color: subtext)),
                        secondary: Icon(
                            _isDark ? Icons.dark_mode : Icons.light_mode,
                            color: text),
                        // ignore: deprecated_member_use
                        activeColor: _primary,
                        value: _isDark,
                        onChanged: (v) {
                          setState(() => _isDark = v);
                          _saveDark(v);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Recibir llamadas SOS
                    Card(
                      elevation: 0,
                      color: bg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: cardBorder),
                      ),
                      child: SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        title: Text('Recibir llamadas SOS',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: text)),
                        subtitle: Text(
                            'Permite llamadas directas al activar una emergencia.',
                            style: TextStyle(fontSize: 13, color: subtext)),
                        secondary: Icon(Icons.call, color: text),
                        // ignore: deprecated_member_use
                        activeColor: _primary,
                        value: _receiveSosCalls,
                        onChanged: (v) {
                          setState(() => _receiveSosCalls = v);
                          _saveCalls(v);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Recibir mensajes SOS
                    Card(
                      elevation: 0,
                      color: bg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: cardBorder),
                      ),
                      child: SwitchListTile.adaptive(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        title: Text('Recibir mensajes de SOS',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: text)),
                        subtitle: Text(
                            'Recibe notificaciones con ubicación y detalles.',
                            style: TextStyle(fontSize: 13, color: subtext)),
                        secondary: Icon(Icons.sms, color: text),
                        // ignore: deprecated_member_use
                        activeColor: _primary,
                        value: _receiveSosMsgs,
                        onChanged: (v) {
                          setState(() => _receiveSosMsgs = v);
                          _saveMsgs(v);
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón continuar -> Mapa
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MapaScreen()),
                          );
                        },
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Podrás cambiar estas opciones cuando quieras en Configuración.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.5, color: subtext),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // ---- BottomNavigationBar (como tu imagen)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bg,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // 0 = Home seleccionado
        onTap: _onItemTapped,
        selectedItemColor: _primary, // turquesa
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

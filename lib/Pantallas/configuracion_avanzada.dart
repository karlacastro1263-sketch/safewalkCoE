import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'configuracion_tutor.dart'; // Para volver con la flecha

class ConfiguracionAvanzada extends StatefulWidget {
  const ConfiguracionAvanzada({super.key});

  @override
  State<ConfiguracionAvanzada> createState() => _ConfiguracionAvanzadaState();
}

class _ConfiguracionAvanzadaState extends State<ConfiguracionAvanzada> {
  // ===== Claves de persistencia =====
  static const _kVibracion = 'cfg_vibracion';
  static const _kIntVib = 'cfg_int_vibracion';
  static const _kSonido = 'cfg_sonido';
  static const _kIntVol = 'cfg_int_volumen';

  static const _kAlPers = 'cfg_alerta_personas';
  static const _kAlEsc = 'cfg_alerta_escaleras';
  static const _kAlAut = 'cfg_alerta_autos';
  static const _kAlMot = 'cfg_alerta_motos';
  static const _kAlPer = 'cfg_alerta_perros';
  static const _kAlArb = 'cfg_alerta_arbol';
  static const _kAlSem = 'cfg_alerta_semaforo';
  static const _kAlEscMec = 'cfg_alerta_escaleras_mec';
  static const _kAlEstadoSem = 'cfg_alerta_estado_semaforo';

  // ===== Estados (con defaults iguales a tu mockup) =====
  bool _vibracion = false;
  double _intensidadVibracion = 40; // 0–100

  bool _sonido = true;
  double _intensidadVolumen = 60; // 0–100

  bool _alertaPersonas = true;
  bool _alertaEscaleras = false;
  bool _alertaAutos = true;
  bool _alertaMotos = false;
  bool _alertaPerros = true;
  bool _alertaArbol = false;
  bool _alertaSemaforoPeatonal = true;
  bool _alertaEscalerasMecanicas = false;
  bool _alertaEstadoSemaforoPeatonal = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs(); // Carga lo guardado
  }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();

    setState(() {
      _vibracion = p.getBool(_kVibracion) ?? _vibracion;
      _intensidadVibracion = p.getDouble(_kIntVib) ?? _intensidadVibracion;

      _sonido = p.getBool(_kSonido) ?? _sonido;
      _intensidadVolumen = p.getDouble(_kIntVol) ?? _intensidadVolumen;

      _alertaPersonas = p.getBool(_kAlPers) ?? _alertaPersonas;
      _alertaEscaleras = p.getBool(_kAlEsc) ?? _alertaEscaleras;
      _alertaAutos = p.getBool(_kAlAut) ?? _alertaAutos;
      _alertaMotos = p.getBool(_kAlMot) ?? _alertaMotos;
      _alertaPerros = p.getBool(_kAlPer) ?? _alertaPerros;
      _alertaArbol = p.getBool(_kAlArb) ?? _alertaArbol;
      _alertaSemaforoPeatonal = p.getBool(_kAlSem) ?? _alertaSemaforoPeatonal;
      _alertaEscalerasMecanicas =
          p.getBool(_kAlEscMec) ?? _alertaEscalerasMecanicas;
      _alertaEstadoSemaforoPeatonal =
          p.getBool(_kAlEstadoSem) ?? _alertaEstadoSemaforoPeatonal;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Configuración Avanzada',
            style: TextStyle(color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          tooltip: 'Volver',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ConfiguracionTutor()),
              );
            }
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Título grande (opcional si ya usas AppBar)
            Text(
              "Configuración\nAvanzada",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 16),

            _SectionHeader(
                texto: "Configura qué tipo de alerta quieres recibir:"),
            const SizedBox(height: 4),

            // ===== Vibración =====
            Semantics(
              label: "Vibración",
              toggled: _vibracion,
              child: SwitchListTile.adaptive(
                value: _vibracion,
                onChanged: (v) {
                  setState(() => _vibracion = v);
                  _saveBool(_kVibracion, v);
                },
                title: const Text("Vibración"),
                secondary: const Icon(Icons.vibration),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            _EtiquetaSlider(
              texto: "Intensidad de vibración:",
              valueText: "${_intensidadVibracion.round()}%",
            ),
            _FilaSliderConIconos(
              leading: const Icon(Icons.vibration),
              trailing: const Icon(Icons.vibration),
              enabled: _vibracion,
              value: _intensidadVibracion,
              onChanged: (v) {
                setState(() => _intensidadVibracion = v);
                _saveDouble(_kIntVib, v);
              },
            ),
            const Divider(height: 24),

            // ===== Sonido =====
            Semantics(
              label: "Sonido",
              toggled: _sonido,
              child: SwitchListTile.adaptive(
                value: _sonido,
                onChanged: (v) {
                  setState(() => _sonido = v);
                  _saveBool(_kSonido, v);
                },
                title: const Text("Sonido"),
                secondary: const Icon(Icons.volume_up),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            _EtiquetaSlider(
              texto: "Intensidad de volumen:",
              valueText: "${_intensidadVolumen.round()}%",
            ),
            _FilaSliderConIconos(
              leading: const Icon(Icons.volume_mute),
              trailing: const Icon(Icons.volume_up),
              enabled: _sonido,
              value: _intensidadVolumen,
              onChanged: (v) {
                setState(() => _intensidadVolumen = v);
                _saveDouble(_kIntVol, v);
              },
            ),

            const SizedBox(height: 16),
            const Divider(height: 32),

            // ===== Alertas de obstáculos =====
            Center(
              child: Text(
                "Configura las alertas de\nobstáculos:",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),

            _switch(
              label: "Alertas de Personas",
              value: _alertaPersonas,
              icon: Icons.accessibility_new,
              onChanged: (v) {
                setState(() => _alertaPersonas = v);
                _saveBool(_kAlPers, v);
              },
            ),
            _switch(
              label: "Alertas de Escaleras",
              value: _alertaEscaleras,
              icon: Icons.stairs,
              onChanged: (v) {
                setState(() => _alertaEscaleras = v);
                _saveBool(_kAlEsc, v);
              },
            ),
            _switch(
              label: "Alertas de Autos",
              value: _alertaAutos,
              icon: Icons.directions_car_filled,
              onChanged: (v) {
                setState(() => _alertaAutos = v);
                _saveBool(_kAlAut, v);
              },
            ),
            _switch(
              label: "Alertas de Motos",
              value: _alertaMotos,
              icon: Icons.two_wheeler,
              onChanged: (v) {
                setState(() => _alertaMotos = v);
                _saveBool(_kAlMot, v);
              },
            ),
            _switch(
              label: "Alertas de Perros",
              value: _alertaPerros,
              icon: Icons.pets,
              onChanged: (v) {
                setState(() => _alertaPerros = v);
                _saveBool(_kAlPer, v);
              },
            ),
            _switch(
              label: "Alertas de Árbol",
              value: _alertaArbol,
              icon: Icons.park,
              onChanged: (v) {
                setState(() => _alertaArbol = v);
                _saveBool(_kAlArb, v);
              },
            ),
            _switch(
              label: "Alertas de Semáforo Peatonal",
              value: _alertaSemaforoPeatonal,
              icon: Icons.traffic,
              onChanged: (v) {
                setState(() => _alertaSemaforoPeatonal = v);
                _saveBool(_kAlSem, v);
              },
            ),
            _switch(
              label: "Alertas de Escaleras Mecánicas",
              value: _alertaEscalerasMecanicas,
              icon: Icons.escalator,
              onChanged: (v) {
                setState(() => _alertaEscalerasMecanicas = v);
                _saveBool(_kAlEscMec, v);
              },
            ),
            _switch(
              label: "Alertas de Estado de Semáforo Peatonal",
              value: _alertaEstadoSemaforoPeatonal,
              icon: Icons.directions_walk,
              onChanged: (v) {
                setState(() => _alertaEstadoSemaforoPeatonal = v);
                _saveBool(_kAlEstadoSem, v);
              },
            ),
            const SizedBox(height: 8),

            Text(
              "Consejo: todos los cambios se guardan automáticamente en el dispositivo.",
              style:
                  TextStyle(color: Colors.black54, fontSize: 12, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Helpers accesibles =====
  Widget _switch({
    required String label,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Semantics(
      label: label,
      toggled: value,
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        title: Text(label),
        secondary: Icon(icon),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

// ===== Widgets de apoyo visual =====
class _SectionHeader extends StatelessWidget {
  final String texto;
  const _SectionHeader({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }
}

class _EtiquetaSlider extends StatelessWidget {
  final String texto;
  final String valueText;
  const _EtiquetaSlider({required this.texto, required this.valueText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Text(valueText, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class _FilaSliderConIconos extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final bool enabled;
  final double value;
  final ValueChanged<double>? onChanged;

  const _FilaSliderConIconos({
    required this.leading,
    required this.trailing,
    required this.enabled,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Row(
        children: [
          leading,
          const SizedBox(width: 8),
          Expanded(
            child: Slider.adaptive(
              value: value,
              min: 0,
              max: 100,
              divisions: 20,
              label: "${value.round()}",
              onChanged: enabled ? onChanged : null,
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}

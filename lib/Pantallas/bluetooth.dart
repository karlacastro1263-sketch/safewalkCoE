import 'package:flutter/material.dart';

// Pantalla de configuración
class Configuracion extends StatefulWidget {
  const Configuracion({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConfiguracionState createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  bool alertasSonido = true;
  bool alertasVibracion = false;
  bool alertasObstaculos = true;
  bool alertasSemaforos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Comenzamos a configurar tu gorro!',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comencemos a configurar tu gorro. Ajusta las alertas a tu gusto!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Configura qué tipo de alertas quieres recibir:',
              style: TextStyle(fontSize: 16),
            ),
            SwitchListTile(
              title: const Text('Alertas de sonido'),
              value: alertasSonido,
              onChanged: (bool value) {
                setState(() {
                  alertasSonido = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Alertas de vibraciones'),
              value: alertasVibracion,
              onChanged: (bool value) {
                setState(() {
                  alertasVibracion = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Configura qué alertas quieres recibir:',
              style: TextStyle(fontSize: 16),
            ),
            SwitchListTile(
              title: const Text('Alertas de obstáculos'),
              value: alertasObstaculos,
              onChanged: (bool value) {
                setState(() {
                  alertasObstaculos = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Alertas de estado de semáforos'),
              value: alertasSemaforos,
              onChanged: (bool value) {
                setState(() {
                  alertasSemaforos = value;
                });
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Lógica para omitir la configuración
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Omitir',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla de Bluetooth
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BluetoothScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Siguiente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de Bluetooth
class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen Bluetooth
              Image.asset(
                'assets/images/bluetooth.png', // Asegúrate de poner la imagen en la carpeta assets/images
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'Bienvenido a SafeWalk!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Comencemos por enlazar tu gorro Navicap con la aplicación, activa el Bluetooth de tu teléfono para conectarlo.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Acción al presionar "Siguiente"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NextScreen()),
                  );
                },
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Next Screen")),
      body: Center(child: const Text('Próxima pantalla')),
    );
  }
}

import 'package:flutter/material.dart';

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
                    // Aquí puedes manejar el siguiente paso de la configuración
                    Navigator.pushNamed(context, '/siguientePantalla');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300], // Cambié 'primary' por 'backgroundColor'
                    foregroundColor: Colors.white, // Cambié 'onPrimary' por 'foregroundColor'
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

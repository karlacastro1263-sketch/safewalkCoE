import 'package:flutter/material.dart';
import 'mapa_screen.dart'; // Importa la pantalla del mapa

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Llamamos a la pantalla de Google Maps
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapaScreen()),
            );
          },
          child: Text('Ir al Mapa'),
        ),
      ),
    );
  }
}

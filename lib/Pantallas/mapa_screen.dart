import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

// Ajusta estos imports a tus archivos reales
import 'cuenta_tutor.dart';
import 'configuracion_tutor.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  StreamSubscription<Position>? _positionStream;
  int _selectedIndex = 1; // Mapa seleccionado

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // --- Bottom nav ---
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CuentaTutor()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConfiguracionTutor()),
      );
    }
  }

  // --- Geolocalización y stream ---
  Future<void> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Puedes mostrar un SnackBar si quieres
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Posición inicial
    final current = await Geolocator.getCurrentPosition();
    _updateMarkerAndCamera(current);

    // Seguir movimientos (ajusta distanceFilter a tu gusto)
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((pos) {
      if (!mounted) return;
      _updateMarkerAndCamera(pos);
    });
  }

  void _updateMarkerAndCamera(Position position) {
    final marker = Marker(
      markerId: const MarkerId('userLocation'),
      position: LatLng(position.latitude, position.longitude),
    );

    setState(() {
      _markers
        ..clear()
        ..add(marker);
    });

    // Mover cámara cuando el mapa esté listo
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sin flecha atrás
      appBar: AppBar(
        title: const Text('Mapa'),
        automaticallyImplyLeading: false,
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-33.517666, -70.797081), // Santiago, CL
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
        onMapCreated: (controller) => _mapController = controller,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cuenta'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
    );
    // Fin Scaffold
  }
}

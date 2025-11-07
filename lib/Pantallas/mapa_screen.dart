import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'configuracion_tutor.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // Obtener ubicación inicial + permisos
  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    // Ubicación inicial
    _currentPosition = await Geolocator.getCurrentPosition();
    _updateMarker(_currentPosition!);

    // Stream (actualiza si se mueve >100 m)
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        _currentPosition = position;
        _updateMarker(position);
      }
    });
  }

  // Actualizar marcador y cámara
  void _updateMarker(Position position) {
    final marker = Marker(
      markerId: const MarkerId("userLocation"),
      position: LatLng(position.latitude, position.longitude),
    );

    setState(() {
      _markers
        ..clear()
        ..add(marker);
    });

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

  void _goToConfig() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ConfiguracionTutor()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      // Captura el "atrás" físico de Android
      onWillPop: () async {
        _goToConfig();
        return false; // evitamos el pop por defecto
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mapa en tiempo real"),
          // Flecha atrás personalizada que navega a Configuración
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: _goToConfig,
          ),
          centerTitle: true,
        ),
        body: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(-33.517666, -70.797081), // Santiago (fallback)
            zoom: 14.0,
          ),
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            // Si ya teníamos posición, centra de inmediato
            if (_currentPosition != null) {
              _mapController!.moveCamera(
                CameraUpdate.newLatLng(
                  LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                ),
              );
            }
          },
          myLocationEnabled: true, // punto azul del usuario
          myLocationButtonEnabled: true, // botón para centrar
        ),
      ),
    );
  }
}

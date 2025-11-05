import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  late Position _currentPosition;
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // Método para obtener la ubicación inicial y solicitar permisos
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('El servicio de ubicación está desactivado.');
    }

    // Verificar permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de ubicación denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permisos de ubicación denegados permanentemente');
    }

    // Obtener la ubicación actual
    _currentPosition = await Geolocator.getCurrentPosition();
    _updateMarker(_currentPosition);

    // Comienza a escuchar la ubicación en tiempo real
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,  // Solo actualiza la posición si el dispositivo se mueve más de 100 metros
    );

    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position != null) {
          _updateMarker(position);
        }
      },
    );
  }

  // Actualizar el marcador en el mapa
  void _updateMarker(Position position) {
    // Muestra las coordenadas en consola

    final Marker marker = Marker(
      markerId: MarkerId("userLocation"),
      position: LatLng(position.latitude, position.longitude),
    );

    setState(() {
      _markers.add(marker);
    });

    mapController.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }

  @override
  void dispose() {
    // Detener la escucha cuando el widget se destruya
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapa en tiempo real")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-33.517666, -70.797081),  // Coordenada de Chile (Santiago)
          zoom: 14.0,  // Ajusta el nivel de zoom según lo que desees ver
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        myLocationButtonEnabled: true, // Habilita el botón para centrarse en la ubicación
      ),
    );
  }
}

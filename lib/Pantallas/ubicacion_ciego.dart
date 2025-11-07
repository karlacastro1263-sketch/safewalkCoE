import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

import 'bienvenido_tutor.dart';
import 'configuracion_tutor.dart';

class UbicacionCiego extends StatefulWidget {
  const UbicacionCiego({super.key, this.lat, this.lng});
  final double? lat;
  final double? lng;

  @override
  State<UbicacionCiego> createState() => _UbicacionCiegoState();
}

class _UbicacionCiegoState extends State<UbicacionCiego> {
  static const Color _primary = Color(0xFF2EB79B);

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  StreamSubscription<Position>? _positionSub;

  LatLng? _currentLatLng;
  String _direccion = 'Obteniendo dirección…';

  // Bottom nav: 0=Home, 1=Mapa (esta), 2=Config
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      // Si recibes coordenadas externas, úsalas
      if (widget.lat != null && widget.lng != null) {
        _updateLocation(LatLng(widget.lat!, widget.lng!));
        return;
      }

      // Permisos
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return;
      }
      if (perm == LocationPermission.deniedForever) return;

      // Posición inicial
      final p = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      _updateLocation(LatLng(p.latitude, p.longitude));

      // Stream (cada 50 m)
      const settings =
          LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 50);
      _positionSub =
          Geolocator.getPositionStream(locationSettings: settings).listen(
        (pos) {
          if (!mounted) return;
          _updateLocation(LatLng(pos.latitude, pos.longitude));
        },
      );
    } catch (_) {
      // Silencioso para evitar romper la UI
    }
  }

  Future<void> _updateLocation(LatLng latLng) async {
    _currentLatLng = latLng;

    final marker = Marker(
      markerId: const MarkerId('ciego'),
      position: latLng,
      infoWindow: const InfoWindow(title: 'Ubicación del ciego'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    setState(() {
      _markers
        ..clear()
        ..add(marker);
    });

    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    }

    // Reverse geocoding
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = <String>[];
        if ((p.street ?? '').isNotEmpty) parts.add(p.street!);
        if ((p.subLocality ?? '').isNotEmpty) parts.add(p.subLocality!);
        if ((p.locality ?? '').isNotEmpty) parts.add(p.locality!);
        if ((p.administrativeArea ?? '').isNotEmpty) {
          parts.add(p.administrativeArea!);
        }
        setState(() {
          _direccion =
              parts.isEmpty ? 'Dirección no disponible' : parts.join(', ');
        });
      }
    } catch (_) {
      // Ignorar errores de geocodificación
    }
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  // Navegación inferior
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BienvenidoTutor()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConfiguracionTutor()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sin flecha atrás
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Ubicación de ciego',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          children: [
            // Mapa cuadrado con bordes redondeados
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(-33.447487, -70.673676), // Fallback: Santiago
                        zoom: 14,
                      ),
                      onMapCreated: (c) => _mapController = c,
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                    ),
                    // Botón "centrar"
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Material(
                        color: Colors.white,
                        elevation: 2,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: () {
                            if (_currentLatLng != null && _mapController != null) {
                              _mapController!.animateCamera(
                                CameraUpdate.newLatLng(_currentLatLng!),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Dirección:',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _direccion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: _primary,
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

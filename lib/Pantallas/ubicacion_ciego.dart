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
      if (widget.lat != null && widget.lng != null) {
        _updateLocation(LatLng(widget.lat!, widget.lng!));
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return;
      }
      if (perm == LocationPermission.deniedForever) return;

      final p = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      _updateLocation(LatLng(p.latitude, p.longitude));

      const settings =
          LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 50);
      _positionSub = Geolocator.getPositionStream(locationSettings: settings)
          .listen((pos) {
        if (!mounted || pos == null) return;
        _updateLocation(LatLng(pos.latitude, pos.longitude));
      });
    } catch (_) {}
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
      await _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    }

    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
          latLng.latitude, latLng.longitude);
      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = <String>[];
        if ((p.street ?? '').isNotEmpty) parts.add(p.street!);
        if ((p.subLocality ?? '').isNotEmpty) parts.add(p.subLocality!);
        if ((p.locality ?? '').isNotEmpty) parts.add(p.locality!);
        if ((p.administrativeArea ?? '').isNotEmpty)
          parts.add(p.administrativeArea!);
        setState(() {
          _direccion =
              parts.isEmpty ? 'Dirección no disponible' : parts.join(', ');
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

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
    final media = MediaQuery.of(context).size;
    // Un poco más largo: 0.68 * ancho del teléfono
    final double collapsedHeight = media.width * 0.68;

    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mapa a TODO el ancho, centrado visualmente y más alto
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: collapsedHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(-33.447487, -70.673676), // Santiago
                        zoom: 14,
                      ),
                      onMapCreated: (c) => _mapController = c,
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      // Tap → pantalla completa
                      onTap: (_) async {
                        await Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: true,
                            barrierColor: Colors.black,
                            pageBuilder: (_, __, ___) => _FullscreenMapPage(
                              currentLatLng: _currentLatLng,
                              markers: _markers,
                            ),
                            transitionsBuilder: (_, anim, __, child) =>
                                FadeTransition(opacity: anim, child: child),
                          ),
                        );
                      },
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
                            if (_currentLatLng != null &&
                                _mapController != null) {
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

            // Dirección justo debajo del mapa
            const SizedBox(height: 10),
            const Text(
              'Dirección:',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 6),
            Text(
              _direccion,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 8),
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

/// Página de mapa a pantalla completa
class _FullscreenMapPage extends StatefulWidget {
  const _FullscreenMapPage({
    required this.currentLatLng,
    required this.markers,
  });

  final LatLng? currentLatLng;
  final Set<Marker> markers;

  @override
  State<_FullscreenMapPage> createState() => _FullscreenMapPageState();
}

class _FullscreenMapPageState extends State<_FullscreenMapPage> {
  GoogleMapController? _controller;
  StreamSubscription<Position>? _sub;

  final LatLng _fallback = const LatLng(-33.447487, -70.673676); // Santiago
  LatLng? _liveLatLng;
  late final Set<Marker> _markers = Set<Marker>.from(widget.markers);

  @override
  void initState() {
    super.initState();
    _liveLatLng = widget.currentLatLng;
    _listenLocation();
  }

  void _listenLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return;
      }
      if (perm == LocationPermission.deniedForever) return;

      const settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 25,
      );
      _sub = Geolocator.getPositionStream(locationSettings: settings)
          .listen((pos) {
        if (!mounted || pos == null) return;
        final here = LatLng(pos.latitude, pos.longitude);
        setState(() => _liveLatLng = here);
        _controller?.animateCamera(CameraUpdate.newLatLng(here));
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initial = _liveLatLng ?? widget.currentLatLng ?? _fallback;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: initial, zoom: 16),
            onMapCreated: (c) => _controller = c,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
          ),
          // Cerrar (arriba-izquierda)
          Positioned(
            top: 12,
            left: 12,
            child: SafeArea(
              child: Material(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.35),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Cerrar',
                ),
              ),
            ),
          ),
          // Centrar en mí (abajo-derecha)
          Positioned(
            right: 16,
            bottom: 24,
            child: SafeArea(
              child: Material(
                color: Colors.white,
                elevation: 3,
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: () {
                    final target =
                        _liveLatLng ?? widget.currentLatLng ?? _fallback;
                    _controller?.animateCamera(CameraUpdate.newLatLng(target));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

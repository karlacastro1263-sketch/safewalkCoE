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

  Future<void> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
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

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
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

  void _openFullscreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullscreenMapPage(
          initialPosition: _currentPosition,
          initialMarkers: _markers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        _goToConfig();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ubicación a tiempo real"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: _goToConfig,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: [
              // Centro vertical y horizontal del mapa "mini"
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      // Un poco más largo que 16:9 para que "llene" más
                      aspectRatio: 16 / 9.8,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(
                                  -33.517666, -70.797081), // Santiago fallback
                              zoom: 14.0,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
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
                            markers: _markers,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            onTap: (_) =>
                                _openFullscreen(), // ← ampliar a pantalla completa
                          ),
                          // Pista sutil
                          Positioned(
                            left: 12,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Toca el mapa para pantalla completa',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.5),
                              ),
                            ),
                          ),
                          // Botón centrar
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
                                  final p = _currentPosition;
                                  if (p != null && _mapController != null) {
                                    _mapController!.animateCamera(
                                      CameraUpdate.newLatLng(
                                        LatLng(p.latitude, p.longitude),
                                      ),
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
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Página a PANTALLA COMPLETA con "Ubicación a tiempo real" en la parte superior.
class _FullscreenMapPage extends StatefulWidget {
  const _FullscreenMapPage({
    required this.initialPosition,
    required this.initialMarkers,
  });

  final Position? initialPosition;
  final Set<Marker> initialMarkers;

  @override
  State<_FullscreenMapPage> createState() => _FullscreenMapPageState();
}

class _FullscreenMapPageState extends State<_FullscreenMapPage> {
  GoogleMapController? _controller;
  StreamSubscription<Position>? _sub;
  late Set<Marker> _markers;
  LatLng get _fallback => const LatLng(-33.517666, -70.797081);

  @override
  void initState() {
    super.initState();
    _markers = Set<Marker>.from(widget.initialMarkers);
    _listenLive();
  }

  void _listenLive() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return;
      }
      if (perm == LocationPermission.deniedForever) return;

      const settings =
          LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 50);
      _sub = Geolocator.getPositionStream(locationSettings: settings)
          .listen((pos) {
        if (!mounted) return;
        final here = LatLng(pos.latitude, pos.longitude);

        // Actualiza marcador principal
        final m = Marker(
          markerId: const MarkerId('userLocation'),
          position: here,
        );
        setState(() {
          _markers
            ..removeWhere((mm) => mm.markerId.value == 'userLocation')
            ..add(m);
        });

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
    final start = widget.initialPosition != null
        ? LatLng(
            widget.initialPosition!.latitude, widget.initialPosition!.longitude)
        : _fallback;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación a tiempo real'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: start, zoom: 16),
            onMapCreated: (c) => _controller = c,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
          ),
          // FAB centrar
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
                    final pos = _markers.firstWhere(
                      (m) => m.markerId.value == 'userLocation',
                      orElse: () => Marker(
                          markerId: const MarkerId('none'), position: start),
                    );
                    _controller
                        ?.animateCamera(CameraUpdate.newLatLng(pos.position));
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/connection_service.dart';
import '../services/ip_service.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _connectionStatus = 'Cargando...';
  String _ipAddress = 'Cargando...';
  LatLng? _currentLocation;
  GoogleMapController? _mapController;

  final _connectionService = ConnectionService();
  final _ipService = IpService();
  final _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    // Espera hasta que se renderice la UI antes de cargar los datos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

Future<void> _loadAll() async {
  try {
    // Ejecuta las tareas en paralelo para mejor rendimiento
    final results = await Future.wait([
      _connectionService.getConnectionType(),
      _ipService.getLocalIp(),
      _locationService.getCurrentPosition(),
    ]);

    final conn = results[0] as String;
    final ip = results[1] as String;
    final position = results[2] as Position;
    final location = LatLng(position.latitude, position.longitude);

    setState(() {
      _connectionStatus = conn;
      _ipAddress = ip;
      _currentLocation = location;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
  } catch (e) {
    setState(() {
      _connectionStatus = 'Error al cargar';
      _ipAddress = 'Error al cargar';
    });
    // Imprime más detalles del error
    debugPrint('Error al obtener datos: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al obtener datos: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Red y Mi Ruta'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.wifi),
            title: const Text('Estado de conexión'),
            subtitle: Text(_connectionStatus),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('IP Local'),
            subtitle: Text(_ipAddress),
          ),
          Expanded(
            child: _currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation!,
                      zoom: 16,
                    ),
                    myLocationEnabled: true,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
          ),
          ElevatedButton.icon(
            onPressed: _loadAll,
            icon: const Icon(Icons.refresh),
            label: const Text('Refrescar datos'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

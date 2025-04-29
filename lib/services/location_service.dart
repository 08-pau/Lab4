import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Servicios de ubicación desactivados');
    }

 LocationPermission permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
}

if (permission == LocationPermission.deniedForever) {
  return Future.error('Permiso de ubicación denegado permanentemente');
}


    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best, // Usa la mejor posible
      timeLimit: const Duration(seconds: 10), // Evita que tarde mucho
    );
  }
}

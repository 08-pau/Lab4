import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  Future<String> getConnectionType() async {
    var result = await Connectivity().checkConnectivity();
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Conectado a Wi-Fi';
      case ConnectivityResult.mobile:
        return 'Conectado a datos móviles';
      case ConnectivityResult.none:
        return 'Sin conexión';
      default:
        return 'Desconocido';
    }
  }
}

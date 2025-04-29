import 'package:network_info_plus/network_info_plus.dart';

class IpService {
  Future<String> getLocalIp() async {
    final info = NetworkInfo();
    String? wifiIP = await info.getWifiIP();
    String? mobileIP = await info.getWifiIPv6(); // fallback
    return wifiIP ?? mobileIP ?? 'IP no disponible';
  }
}

import 'dart:io';
import 'package:system_proxy/system_proxy.dart';

class CustomProxy {
   init() async{
    Map<String, String>? proxy = await SystemProxy.getProxySettings();
    if (proxy != null) {
      HttpOverrides.global = ProxiedHttpOverrides(proxy['host']!, proxy['port']!);
    }
  }
}
class ProxiedHttpOverrides extends HttpOverrides {
  final String _port;
  final String _host;

  ProxiedHttpOverrides(this._host, this._port);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
    // set proxy
      ..findProxy = (uri) {
        return "PROXY $_host:$_port;";
      };
  }
}
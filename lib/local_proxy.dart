library local_proxy;

import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

class LocalProxy {
  static HttpServer _server;
  static StreamSubscription<HttpRequest> _streamSubscription;

  static Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server.listen(_listener);
  }

  static Future<void> stop() async {
    await _streamSubscription.cancel();
  }

  static int get port => _server.port;

  static String getUrl(String path) {
    return "http://127.0.0.1:${_server.port}/${Uri.encodeComponent(path)}";
  }

  static void _listener(HttpRequest request) async {
    if (request.requestedUri.pathSegments.length != 1) {
      return;
    }
    String path = request.requestedUri.pathSegments[0];
    File file = File(path);
    bool exist = await file.exists();
    if (!exist) {
      await request.response.close();
      return;
    }
    await file.openRead().pipe(request.response);
  }
}

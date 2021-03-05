import 'dart:convert';
import 'dart:io';

import 'package:local_proxy/local_proxy.dart';

void main() async {
  await LocalProxy.start();
  HttpClientRequest request = await HttpClient().post("127.0.0.1", LocalProxy.port, Uri.encodeComponent("/data/abc/123.rrr"));
  HttpClientResponse res = await request.close();
  await utf8.decoder.bind(res /*5*/).forEach(print);
}

library api;

import 'package:http/http.dart' as http;

abstract class BaseApi {
  http.Client client;

  final Map<String, dynamic> configuration;

  String path;

  BaseApi(this.configuration, this.path) {
    this.client = http.Client();
  }

  String getHost() {
    return this.configuration['host'];
  }

  int getPort() {
    var portStr = this.configuration['port'];
    return int.parse(portStr);
  }
}

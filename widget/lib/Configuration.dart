library widget;

import 'dart:convert';
import 'dart:html' show window;

class Configuration {
  static final Configuration _singleton = Configuration._internal();

  Map<String, dynamic> _config = {};

  factory Configuration() {
    return _singleton;
  }

  Configuration._internal();

  Map<String, dynamic> getConfig() => _config;

  void setConfig(Map<String, dynamic> config) {
    _config = config;
  }

  Map getToken() {
    var token = window.localStorage['token'];
    if (token == null) {
      return {};
    }
    return jsonDecode(token);
  }

  void setToken(Map token) {
    window.localStorage['token'] = jsonEncode(token);
  }
}

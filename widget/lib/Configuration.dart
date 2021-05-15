library widget;

class Configuration {
  static final Configuration _singleton = Configuration._internal();

  Map<String, String> _config = {};

  Map _token = {};

  factory Configuration() {
    return _singleton;
  }

  Configuration._internal();

  Map<String, String> getConfig() => _config;

  void setConfig(Map<String, String> config) {
    _config = config;
  }

  Map getToken() => _token;

  void setToken(Map token) {
    _token = token;
  }
}

library api;

import 'package:http/http.dart' as http;
import './base-api.dart';

class LoginApi extends BaseApi {
  LoginApi(Map<String, dynamic> configuration)
      : super(configuration, getRealmsUri(configuration)) {
    this.client = http.Client();
  }

  Future<Map> login(
      String breadcrumbId, String username, String password) async {
    var kcSetting = this.configuration['kc'];
    var uri =
        Uri(host: kcSetting['host'], port: kcSetting['port'], path: this.path);

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var value = 'grant_type=' +
        Uri.encodeComponent(kcSetting['grant_type']) +
        '&client_id=' +
        Uri.encodeComponent(kcSetting['client_id']) +
        '&client_secret=' +
        Uri.encodeComponent(kcSetting['client_secret']) +
        '&username=' +
        Uri.encodeComponent(username) +
        '&password=' +
        Uri.encodeComponent(password);

    var response = await this.client.post(uri, body: value, headers: headers);

    return {'type': 'SUCCESS', 'message': response.body};
  }

  static String getRealmsUri(Map<String, dynamic> configuration) {
    var realm = configuration["kc"]["realm"];
    return 'auth/realms/${realm}/protocol/openid-connect/token';
  }
}

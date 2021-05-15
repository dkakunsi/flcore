library api;

import 'dart:convert';

import 'package:http/http.dart' as http;
import './base-api.dart';

class LoginApi extends BaseApi {
  LoginApi(Map<String, dynamic> configuration) : super(configuration, 'auth') {
    this.client = http.Client();
  }

  Future<Map> login(
      String breadcrumbId, String username, String password) async {
    var uri = Uri(host: getHost(), port: getPort(), path: this.path);

    Map<String, String> headers = {'breadcrumbId': breadcrumbId};

    var jsonData = {
      'domain': 'credential',
      'username': username,
      'password': password
    };

    var response = await this
        .client
        .post(uri, body: jsonEncode(jsonData), headers: headers);

    return {'type': 'SUCCESS', 'message': response.body};
  }
}

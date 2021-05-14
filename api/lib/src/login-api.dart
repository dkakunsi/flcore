library api;

import 'package:http/http.dart' as http;
import './base-api.dart';
import 'dart:convert';

class LoginApi extends BaseApi {

  LoginApi(Map<String, String> configuration) : super(configuration, 'auth') {
    this.client = http.Client();
  }

  Future<Map> login(Map<String, String> context, String username, String password) async {
    var uri = Uri(host: getHost(), port: getPort(), path: this.path);

    Map<String, String> headers = {
      'breadcrumbId': context['breadcrumbId']
    };

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

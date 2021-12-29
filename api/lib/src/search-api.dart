library api;

import 'package:http/http.dart' as http;
import './base-api.dart';
import 'dart:convert';

class SearchApi extends BaseApi {
  SearchApi(Map<String, dynamic> configuration)
      : super(configuration, 'api/search') {
    this.client = http.Client();
  }

  Future<Map> search(
      Map<String, String> context, String domain, Map criteria) async {
    var query = {'domain': domain};
    var uri = Uri(
        host: getHost(),
        port: getPort(),
        path: this.path,
        queryParameters: query);

    var response = await this
        .client
        .post(uri, body: jsonEncode(criteria), headers: context);

    return {'type': 'SUCCESS', 'message': response.body};
  }
}

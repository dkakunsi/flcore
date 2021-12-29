library api;

import 'package:http/http.dart' as http;
import './base-api.dart';
import 'dart:convert';

class ResourceApi extends BaseApi {
  ResourceApi(Map<String, dynamic> configuration)
      : super(configuration, 'api') {
    this.client = http.Client();
  }

  Future<Map> post(
      Map<String, String> context, String domain, Map jsonData) async {
    var query = {'domain': domain};
    var uri = Uri(
        host: getHost(),
        port: getPort(),
        path: this.path,
        queryParameters: query);

    var response = await this
        .client
        .post(uri, body: jsonEncode(jsonData), headers: context);

    return {'type': 'SUCCESS', 'message': response.body};
  }

  Future<Map> put(Map<String, String> context, String domain, String id,
      Map jsonData) async {
    var query = {'domain': domain};
    var uri = Uri(
        host: getHost(),
        port: getPort(),
        path: this.path + "/" + id,
        queryParameters: query);

    var response = await this
        .client
        .put(uri, body: jsonEncode(jsonData), headers: context);

    return {'type': 'SUCCESS', 'message': response.body};
  }

  Future<Map> get(Map<String, String> context, String domain, String id) async {
    var query = {'domain': domain};
    var uri = Uri(
        host: getHost(),
        port: getPort(),
        path: this.path + "/" + id,
        scheme: "http",
        queryParameters: query);

    var response = await this.client.get(uri, headers: context);

    return {'type': 'SUCCESS', 'message': response.body};
  }

  Future<Map> getByCode(
      Map<String, String> context, String domain, String code) async {
    var query = {'domain': domain};
    var uri = Uri(
        host: getHost(),
        port: getPort(),
        path: this.path + "/code/" + code,
        queryParameters: query);

    var response = await this.client.get(uri, headers: context);

    return {'type': 'SUCCESS', 'message': response.body};
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

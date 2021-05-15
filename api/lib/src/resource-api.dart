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

    Map<String, String> headers = {
      'Authorization': context['token'],
      'breadcrumbId': context['breadcrumbId']
    };

    var response = await this
        .client
        .post(uri, body: jsonEncode(jsonData), headers: headers);

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

    Map<String, String> headers = {
      'Authorization': context['token'],
      'breadcrumbId': context['breadcrumbId']
    };

    var response = await this
        .client
        .put(uri, body: jsonEncode(jsonData), headers: headers);

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

    Map<String, String> headers = {
      'Authorization': context['token'],
      'breadcrumbId': context['breadcrumbId']
    };

    var response = await this.client.get(uri, headers: headers);

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

    Map<String, String> headers = {
      'Authorization': context['token'],
      'breadcrumbId': context['breadcrumbId']
    };

    var response = await this.client.get(uri, headers: headers);

    return {'type': 'SUCCESS', 'message': response.body};
  }
}

library api;

import 'package:http/http.dart' as http;
import 'base-api.dart';
import 'dart:convert';

class WorkflowApi extends BaseApi {

  WorkflowApi(Map<String, String> configuration) : super(configuration, 'workflow') {
    this.client = http.Client();
  }

  Future<Map> createInstance(Map<String, String> context, Map jsonData) async {
    var uri = Uri(
        host: getHost(),
        port: getPort(),
        path: this.path);

    Map<String, String> headers = {
      'Authorization': context['token'],
      'breadcrumbId': context['breadcrumbId']
    };

    var response = await this
        .client
        .post(uri, body: jsonEncode(jsonData), headers: headers);

    return {'type': 'SUCCESS', 'message': response.body};
  }

  Future<Map> approveTask(Map<String, String> context, String taskId) async {
    var uri = Uri(
        host: getHost(),
        port: getPort(),
        path: this.path + "/" + taskId);

    Map<String, String> headers = {
      'Authorization': context['token'],
      'breadcrumbId': context['breadcrumbId']
    };

    var jsonData = {
      'domain': 'workflowtask',
      'variable': {
        'approved': 'true'
      }
    };

    var response = await this
        .client
        .put(uri, body: jsonEncode(jsonData), headers: headers);

    return {'type': 'SUCCESS', 'message': response.body};
  }

  Future<Map> rejectTask(Map<String, String> context, String taskId, String reason) async {
    var uri = Uri(
        host: getHost(),
        port: getPort(),
        path: this.path + "/" + taskId);

    Map<String, String> headers = {
      'Authorization': context['token'],
      'breadcrumbId': context['breadcrumbId']
    };

    var jsonData = {
      'domain': 'workflowtask',
      'variable': {
        'approved': 'false',
        'closeReason': reason
      }
    };

    var response = await this
        .client
        .put(uri, body: jsonEncode(jsonData), headers: headers);

    return {'type': 'SUCCESS', 'message': response.body};
  }
}

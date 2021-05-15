library api;

import './src/resource-api.dart';
import './src/login-api.dart';
import './src/schema-api.dart';
import './src/search-api.dart';
import './src/workflow-api.dart';

class Api {
  Map<String, dynamic> _configuration;

  ResourceApi _resourceApi;

  LoginApi _loginApi;

  SchemaApi _schemaApi;

  SearchApi _searchApi;

  WorkflowApi _workflowApi;

  Api(this._configuration) {
    this._resourceApi = ResourceApi(this._configuration);
    this._loginApi = LoginApi(this._configuration);
    this._schemaApi = SchemaApi(this._configuration);
    this._searchApi = SearchApi(this._configuration);
    this._workflowApi = WorkflowApi(this._configuration);
  }

  Future<Map> postResource(
      Map<String, String> context, String domain, Map jsonData) async {
    return await _resourceApi.post(context, domain, jsonData);
  }

  Future<Map> putResource(Map<String, String> context, String domain, String id,
      Map jsonData) async {
    return await _resourceApi.put(context, domain, id, jsonData);
  }

  Future<Map> getResource(
      Map<String, String> context, String domain, String id) async {
    return await _resourceApi.get(context, domain, id);
  }

  Future<Map> getResourceByCode(
      Map<String, String> context, String domain, String code) async {
    return _resourceApi.getByCode(context, domain, code);
  }

  Future<Map> login(
      String breadcrumbId, String username, String password) async {
    return this._loginApi.login(breadcrumbId, username, password);
  }

  Future<Map> getSchema(Map<String, String> context, String domain) async {
    return this._schemaApi.get(context, domain);
  }

  Future<Map> search(
      Map<String, String> context, String domain, Map criteria) async {
    return this._searchApi.search(context, domain, criteria);
  }

  Future<Map> createInstance(Map<String, String> context, Map jsonData) async {
    return this._workflowApi.createInstance(context, jsonData);
  }

  Future<Map> approveTask(Map<String, String> context, String taskId) async {
    return this._workflowApi.approveTask(context, taskId);
  }

  Future<Map> rejectTask(
      Map<String, String> context, String taskId, String reason) async {
    return this._workflowApi.rejectTask(context, taskId, reason);
  }
}

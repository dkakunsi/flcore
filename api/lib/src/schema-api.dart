library api;

import 'package:http/http.dart' as http;
import 'base-api.dart';

class SchemaApi extends BaseApi {

  SchemaApi(Map<String, String> configuration) : super(configuration, 'schema') {
    this.client = http.Client();
  }

  Future<Map> get(Map<String, String> context, String domain) async {
    var uri =
        Uri(host: getHost(), port: getPort(), path: this.path + "/" + domain);

    Map<String, String> headers = {
      'Authorization': context['token'],
      'breadcrumbId': context['breadcrumbId']
    };

    var response = await this.client.get(uri, headers: headers);

    return {'type': 'SUCCESS', 'message': response.body};
  }
}

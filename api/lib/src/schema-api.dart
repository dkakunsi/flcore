library api;

import 'package:http/http.dart' as http;
import 'base-api.dart';

class SchemaApi extends BaseApi {
  SchemaApi(Map<String, dynamic> configuration)
      : super(configuration, 'schema') {
    this.client = http.Client();
  }

  Future<Map> get(Map<String, String> context, String domain) async {
    var uri =
        Uri(host: getHost(), port: getPort(), path: this.path + "/" + domain);

    var response = await this.client.get(uri, headers: context);

    return {'type': 'SUCCESS', 'message': response.body};
  }
}

import 'package:api/data/model/model.dart';
import 'package:api/data/model/resource_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResourceResponseModel', () {
    test('Create from json object string', () {
      // When
      final jsonObject = '{"domain": "domain", "id": "id"}';
      var resourceResponseModel = ResourceResponseModel(
        type: ResponseType.Success,
        responseMessage: jsonObject,
      );

      // Then
      expect(resourceResponseModel.isObject, true);
    });

    test('Create from json array string', () {
      // When
      final jsonArray = '[{"domain": "domain", "id": "id"}]';
      var resourceResponseModel = ResourceResponseModel(
        type: ResponseType.Success,
        responseMessage: jsonArray,
      );

      // Then
      expect(resourceResponseModel.isArray, true);
    });
  });
}

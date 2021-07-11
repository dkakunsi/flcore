import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:api/api.dart';

void main() {
  var configuration = {'host': 'localhost', 'port': '2104'};
  var api = Api(configuration);

  test('adds one to input values', () {
    var context = {
      "Authorization": "c867de1a-6470-483c-b676-44d2100061c3",
      "breadcrumbId": "BreadcrumbId004"
    };

    print("Test started");
    var result =
        api.getResource(context, "advertorial", "608ab05430d44959c0de6a2b");

    result
        .then((value) => print("Success"))
        .whenComplete(() => print("when complete"))
        .onError((error, stackTrace) => print("error"));

    sleep(new Duration(seconds: 10));
    print("Test ended");
  });
}

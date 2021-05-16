library widget;

import 'package:flutter/material.dart';

bool isWebScreen(BuildContext context) =>
    MediaQuery.of(context).size.width > 500;

double getMobileScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width * 0.8;

int gridCount(BuildContext context) {
  var crossAxisCount = 1;
  if (isWebScreen(context)) {
    crossAxisCount = 3;
  }
  return crossAxisCount;
}

String getJSONValue(Map json, String attribute) {
  if (attribute.contains('_')) {
    var elements = attribute.split('_');
    dynamic value = json;
    elements.forEach((element) {
      value = value[element];
    });
    return value.toString();
  }
  return json[attribute] ?? '';
}

void setJSONValue(Map json, String attribute, String value) {
  if (attribute.contains('_')) {
    var elements = attribute.split('_');
    var length = elements.length;

    var currentJson = json;
    var i = 1;
    elements.forEach((element) {
      if (i < length) {
        if (currentJson[element] == null) {
          var nextJson = {};
          currentJson[element] = nextJson;
          currentJson = nextJson;
        } else {
          currentJson = currentJson[element];
        }
      } else {
        currentJson[element] = value;
      }

      i++;
    });
  } else {
    json[attribute] = value;
  }
}

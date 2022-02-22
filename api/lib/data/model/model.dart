import 'package:flutter/material.dart';

abstract class ResponseModel {
  final ResponseType type;
  final String responseMessage;
  Map<String, dynamic> object;
  List<dynamic> array;
  ResponseModel({
    @required this.type,
    @required this.responseMessage,
  });
}

enum ResponseType {
  Success,
  Error,
}

extension ResponseTypeExtension on ResponseType {
  String get value {
    switch (this) {
      case ResponseType.Success:
        return 'Success';
      default:
        return 'Error';
    }
  }
}

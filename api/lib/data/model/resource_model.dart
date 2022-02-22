import 'dart:convert';

import 'package:api/domain/entity/resource_entity.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class ResourceRequestModel extends ResourceEntity {
  Map<String, dynamic> data;

  ResourceRequestModel({
    @required this.data,
  }) : super();

  static ResourceRequestModel of(ResourceEntity entity) {
    return ResourceRequestModel(data: entity.data);
  }
}

class ResourceResponseModel extends ResponseModel {
  ResourceResponseModel({
    @required ResponseType type,
    @required String responseMessage,
  }) : super(
          type: type,
          responseMessage: responseMessage,
        ) {
    if (_containsArraySymbols(responseMessage)) {
      array = jsonDecode(responseMessage);
    } else {
      object = jsonDecode(responseMessage);
      array = [object];
    }
  }

  static bool _containsArraySymbols(String message) {
    return message.contains('[') && message.contains(']');
  }

  bool get isObject => object != null;

  bool get isArray => !isObject;

  ResourceEntity toEntity() {
    return ResourceEntity(data: object);
  }

  List<ResourceEntity> toEntities() {
    var entities = <ResourceEntity>[];
    array.forEach((obj) {
      final entity = ResourceEntity(data: obj);
      entities.add(entity);
    });
    return entities;
  }
}

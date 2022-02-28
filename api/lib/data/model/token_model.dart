import 'dart:convert';

import 'package:api/data/model/model.dart';
import 'package:api/domain/entity/token_entity.dart';
import 'package:flutter/material.dart';

class TokenResponseModel extends ResponseModel {
  Map<String, dynamic> data;
  TokenResponseModel({
    @required String responseMessage,
    @required ResponseType type,
  }) : super(
          type: type,
          responseMessage: responseMessage,
        ) {
    data = jsonDecode(responseMessage);
  }

  String get accessToken => data['access_token'];

  String get refreshToken => data['refresh_token'];
}

class TokenLocalModel extends TokenEntity {
  TokenLocalModel({
    @required String accessToken,
    @required DateTime expiredAt,
    @required String name,
    String email,
    String refreshToken,
    String roles,
  }) : super(
          accessToken: accessToken,
          expiredAt: expiredAt,
          name: name,
          email: email,
          refreshToken: refreshToken,
          roles: roles,
        );

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiredAt': expiredAt,
      'name': name,
      'email': email,
      'refreshToken': refreshToken,
      'roles': roles,
    };
  }
}

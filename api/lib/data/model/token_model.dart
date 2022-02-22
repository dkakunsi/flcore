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

  TokenEntity toEntity() {
    return TokenEntity(
      accessToken: data['access_token'],
      expiredAt: data['expired_at'],
      name: data['name'],
    );
  }
}

class TokenLocalModel extends TokenEntity {
  TokenLocalModel({
    @required String accessToken,
    @required DateTime expiredAt,
    @required String name,
    String email,
    String refreshToken,
  }) : super(
          accessToken: accessToken,
          expiredAt: expiredAt,
          name: name,
          email: email,
          refreshToken: refreshToken,
        );

  bool get isExpired => DateTime.now().isAfter(expiredAt);

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiredAt': expiredAt,
      'name': name,
      'email': email,
      'refreshToken': refreshToken,
    };
  }

  static TokenLocalModel of(TokenResponseModel tokenResponse) {
    return TokenLocalModel(
      accessToken: tokenResponse.data['access_token'],
      expiredAt: tokenResponse.data['expired_at'],
      name: tokenResponse.data['name'],
    );
  }
}

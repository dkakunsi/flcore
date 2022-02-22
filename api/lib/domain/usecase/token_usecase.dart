import 'package:api/data/model/token_model.dart';
import 'package:api/data/repository/token_repository.dart';
import 'package:api/domain/entity/token_entity.dart';
import 'package:api/domain/context.dart';
import 'package:flutter/material.dart';

class TokenUseCase {
  final TokenRepository tokenRepository;

  TokenUseCase({
    @required this.tokenRepository,
  });

  Future<TokenEntity> authenticate({
    @required String username,
    @required String password,
    Context context,
  }) async {
    final activeToken = await tokenRepository.getActiveToken(context: context);
    if (activeToken != null && !activeToken.isExpired) {
      return activeToken;
    }

    final tokenResponse = await tokenRepository.getToken(
        username: username, password: password, context: context);

    saveToLocal(context: context, token: tokenResponse);

    return tokenResponse.toEntity();
  }

  void saveToLocal({
    Context context,
    @required TokenResponseModel token,
  }) {
    final tokenModel = TokenLocalModel.of(token);
    tokenRepository.saveToken(context: context, tokenModel: tokenModel);
  }
}

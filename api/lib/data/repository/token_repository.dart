import 'package:api/data/datasource/local/token_local_datasource.dart';
import 'package:api/data/datasource/remote/token_remote_datasource.dart';
import 'package:api/data/model/model.dart';
import 'package:api/data/model/token_model.dart';
import 'package:api/data/repository/repository.dart';
import 'package:api/domain/context.dart';
import 'package:flutter/material.dart';

class TokenRepository extends Repository {
  final TokenRemoteDataSource tokenRemoteDataSource;
  final TokenLocalDataSource tokenLocalDataStore;

  TokenRepository({
    @required this.tokenRemoteDataSource,
    @required this.tokenLocalDataStore,
  }) : super(name: 'TokenRepository');

  Future<TokenResponseModel> getToken({
    Context context,
    @required String username,
    @required String password,
  }) async {
    final breadcrumbId = context.breadcrumbId;
    log.fine("BreadcrumbId: $breadcrumbId. Requesting token.");

    try {
      var responseMessage = await tokenRemoteDataSource.getToken(
        username: username,
        password: password,
        headers: context.toHeader(),
      );

      log.fine('BreadcrumbId: $breadcrumbId. Requesting token is success');
      return TokenResponseModel(
        type: ResponseType.Success,
        responseMessage: responseMessage,
      );
    } catch (error, stack) {
      log.shout('BreadcrumbId: $breadcrumbId. Requesting token is failed.',
          error, stack);

      throw RepositoryException(message: error);
    }
  }

  void saveToken({
    @required Context context,
    @required TokenLocalModel tokenModel,
  }) {
    final breadcrumbId = context.breadcrumbId;
    log.fine('BreadcrumbId: $breadcrumbId. Saving active token');
    tokenLocalDataStore.setToken(tokenModel);
  }

  Future<TokenLocalModel> getActiveToken({
    @required Context context,
  }) {
    final breadcrumbId = context.breadcrumbId;
    log.fine('BreadcrumbId: $breadcrumbId. Retrieving active token');
    return tokenLocalDataStore.getToken();
  }

  void removeToken({
    @required Context context,
  }) {
    final breadcrumbId = context.breadcrumbId;
    log.fine('BreadcrumbId: $breadcrumbId. Removing active token');
    tokenLocalDataStore.removeToken();
  }
}

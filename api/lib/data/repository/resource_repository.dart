import 'package:api/data/datasource/remote/resource_remote_datasource.dart';
import 'package:api/data/model/model.dart';
import 'package:api/data/model/resource_model.dart';
import 'package:api/data/repository/repository.dart';
import 'package:api/domain/context.dart';
import 'package:flutter/material.dart';

class ResourceRepository extends Repository {
  final ResourceRemoteDataSource resourceDataSource;

  ResourceRepository({
    @required this.resourceDataSource,
  }) : super(name: 'ResourceRepository');

  Future<ResourceResponseModel> createResource({
    @required Context context,
    @required ResourceRequestModel requestModel,
  }) async {
    final breadcrumbId = context.breadcrumbId;
    final domain = requestModel.domain;
    log.fine('BreadcrumbId: $breadcrumbId. Creating resource for $domain');

    try {
      final responseMessage = await resourceDataSource.createResource(
        domain: domain,
        data: requestModel.data,
        headers: context.toHeader(),
      );

      log.fine('BreadcrumbId: $breadcrumbId. Resource is created');
      return ResourceResponseModel(
        type: ResponseType.Success,
        responseMessage: responseMessage,
      );
    } catch (error, stack) {
      log.shout('BreadcrumbId: $breadcrumbId. Creating resource is failed.',
          error, stack);

      throw RepositoryException(message: error);
    }
  }

  Future<ResourceResponseModel> updateResource({
    @required Context context,
    @required ResourceRequestModel requestModel,
  }) async {
    final breadcrumbId = context.breadcrumbId;
    final resourceId = requestModel.id;
    final domain = requestModel.domain;
    log.fine(
        'BreadcrumbId: $breadcrumbId. Updating resource $resourceId for domain $domain');

    try {
      final responseMessage = await resourceDataSource.updateResource(
        domain: domain,
        id: resourceId,
        data: requestModel.data,
        headers: context.toHeader(),
      );

      log.fine('BreadcrumbId: $breadcrumbId. Resource $resourceId is updated');
      return ResourceResponseModel(
        type: ResponseType.Success,
        responseMessage: responseMessage,
      );
    } catch (error, stack) {
      log.shout('BreadcrumbId: $breadcrumbId. Updating resource is failed.',
          error, stack);

      throw RepositoryException(message: error);
    }
  }

  Future<ResourceResponseModel> getResourceById({
    @required Context context,
    @required String domain,
    @required String id,
  }) async {
    final breadcrumbId = context.breadcrumbId;
    log.fine(
        'BreadcrumbId: $breadcrumbId. Retrieving resource $id of domain $domain');

    try {
      var responseMessage = await resourceDataSource.getResourceById(
        domain: domain,
        id: id,
        headers: context.toHeader(),
      );

      log.fine('BreadcrumbId: $breadcrumbId. Retrieving resource is success');
      return ResourceResponseModel(
        type: ResponseType.Success,
        responseMessage: responseMessage,
      );
    } catch (error, stack) {
      log.shout('BreadcrumbId: $breadcrumbId. Retrieving resource is failed.',
          error, stack);

      throw RepositoryException(message: error);
    }
  }

  Future<ResourceResponseModel> getResourceByCode({
    @required Context context,
    @required String domain,
    @required String code,
  }) async {
    final breadcrumbId = context.breadcrumbId;
    log.fine(
        'BreadcrumbId: $breadcrumbId. Retrieving resource $code, of domain $domain');

    try {
      final responseMessage = await resourceDataSource.getResourceByCode(
        domain: domain,
        code: code,
        headers: context.toHeader(),
      );

      log.fine('BreadcrumbId: $breadcrumbId. Retrieving resource is success');
      return ResourceResponseModel(
        type: ResponseType.Success,
        responseMessage: responseMessage,
      );
    } catch (error, stack) {
      log.shout('BreadcrumbId: $breadcrumbId. Retrieving resource is failed.',
          error, stack);

      throw RepositoryException(message: error);
    }
  }

  Future<ResourceResponseModel> searchResources({
    @required Context context,
    @required String domain,
    @required Map<String, dynamic> criteria,
  }) async {
    final breadcrumbId = context.breadcrumbId;
    log.fine(
        'BreadcrumbId: $breadcrumbId. Searching resource of domain $domain');

    try {
      final responseMessage = await resourceDataSource.searchResources(
        domain: domain,
        criteria: criteria,
        headers: context.toHeader(),
      );

      log.fine('BreadcrumbId: $breadcrumbId. Searching is success');
      return ResourceResponseModel(
        type: ResponseType.Success,
        responseMessage: responseMessage,
      );
    } catch (error, stack) {
      log.shout('BreadcrumbId: $breadcrumbId. Searching resource is failed.',
          error, stack);

      throw RepositoryException(message: error);
    }
  }
}

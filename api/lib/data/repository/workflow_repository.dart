import 'package:api/data/datasource/remote/workflow_remote_datasource.dart';
import 'package:api/data/model/model.dart';
import 'package:api/data/model/workflow_model.dart';
import 'package:api/data/repository/repository.dart';
import 'package:api/domain/context.dart';
import 'package:flutter/material.dart';

class WorkflowRepository extends Repository {
  final WorkflowRemoteDataSource workflowDataSource;

  WorkflowRepository({
    @required this.workflowDataSource,
  }) : super(name: 'WorkflowRepository');

  Future<WorkflowResponseModel> approveTask({
    @required Context context,
    @required String taskId,
  }) async {
    final breadcrumbId = context.breadcrumbId;
    log.fine('BreadcrumbId: $breadcrumbId. Approving task $taskId');

    try {
      workflowDataSource.approveTask(
          taskId: taskId, headers: context.toHeader());

      log.fine('BreadcrumbId: $breadcrumbId. Approving task succedded');
      return WorkflowResponseModel(type: ResponseType.Success);
    } catch (error, stack) {
      log.shout(
          'BreadcrumbId: $breadcrumbId. Approving task failed', error, stack);

      throw RepositoryException(message: error);
    }
  }

  Future<WorkflowResponseModel> rejectTask({
    @required Context context,
    @required String taskId,
    String reason,
  }) async {
    final breadcrumbId = context.breadcrumbId;
    log.fine('BreadcrumbId: $breadcrumbId. Rejecting task $taskId');

    try {
      workflowDataSource.rejectTask(
        taskId: taskId,
        reason: reason,
        headers: context.toHeader(),
      );

      log.fine('BreadcrumbId: $breadcrumbId. Rejecting task succedded');
      return WorkflowResponseModel(type: ResponseType.Success);
    } catch (error, stack) {
      log.shout(
          'BreadcrumbId: $breadcrumbId. Rejecting task failed', error, stack);

      throw RepositoryException(message: error);
    }
  }
}

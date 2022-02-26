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
  });

  Future<WorkflowResponseModel> approveTask({
    @required Context context,
    @required String taskId,
  }) async {
    workflowDataSource.approveTask(taskId: taskId, headers: context.toHeader());

    return WorkflowResponseModel(type: ResponseType.Success);
  }

  Future<WorkflowResponseModel> rejectTask({
    @required Context context,
    @required String taskId,
    String reason,
  }) async {
    workflowDataSource.rejectTask(
      taskId: taskId,
      reason: reason,
      headers: context.toHeader(),
    );

    return WorkflowResponseModel(type: ResponseType.Success);
  }
}

import 'package:api/data/model/model.dart';
import 'package:flutter/material.dart';

class WorkflowResponseModel extends ResponseModel {
  WorkflowResponseModel({
    @required ResponseType type,
  }) : super(
          type: type,
          responseMessage: type.value,
        );
}

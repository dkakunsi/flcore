import 'package:api/domain/usecase/workflow_usecase.dart';
import 'package:api/presentation/bloc/workflow/workflow_event.dart';
import 'package:api/presentation/bloc/workflow/workflow_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkflowBloc extends Bloc<WorkflowEvent, WorkflowState> {
  WorkflowUseCase workflowUseCase;

  WorkflowBloc(this.workflowUseCase) : super(InitialWorkflowState());
}

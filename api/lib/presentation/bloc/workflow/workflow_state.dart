abstract class WorkflowState {}

class InitialWorkflowState extends WorkflowState {}

class TaskApprovedWorkflowState extends WorkflowState {}

class TaskRejectedWorkflowState extends WorkflowState {}

class ErrorWorkflowState extends WorkflowState {}

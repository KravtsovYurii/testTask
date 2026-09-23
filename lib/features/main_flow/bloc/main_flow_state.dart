import 'package:test_task/features/main_flow/data/models/models.dart';

abstract class MainFlowState {
  const MainFlowState();
}

class MainFlowInitial extends MainFlowState {
  const MainFlowInitial();
}

class MainFlowLoading extends MainFlowState {
  const MainFlowLoading();
}

class MainFlowCalculating extends MainFlowState {
  const MainFlowCalculating({required this.progress, required this.percentage});

  final double progress;
  final int percentage;
}

class MainFlowCalculationCompleted extends MainFlowState {
  const MainFlowCalculationCompleted({
    required this.tasks,
    required this.results,
    required this.url,
  });

  final List<Item> tasks;
  final List<Result> results;
  final String url;
}

class MainFlowSending extends MainFlowState {
  const MainFlowSending({
    required this.tasks,
    required this.results,
    required this.url,
  });

  final List<Item> tasks;
  final List<Result> results;
  final String url;
}

class MainFlowSendSuccess extends MainFlowState {
  const MainFlowSendSuccess({required this.tasks, required this.results});

  final List<Item> tasks;
  final List<Result> results;
}

class MainFlowError extends MainFlowState {
  const MainFlowError({
    required this.message,
    this.tasks,
    this.results,
    this.url,
  });

  final String message;
  final List<Item>? tasks;
  final List<Result>? results;
  final String? url;

  bool get canRetrySend => tasks != null && results != null && url != null;
}

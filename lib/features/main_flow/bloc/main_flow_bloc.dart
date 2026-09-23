import 'main_flow_event.dart';
import 'main_flow_state.dart';
import 'package:test_task/core/api/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/core/services/services.dart';
import 'package:test_task/features/main_flow/data/models/models.dart';
import 'package:test_task/features/main_flow/data/services/services.dart';

class MainFlowBloc extends Bloc<MainFlowEvent, MainFlowState> {
  MainFlowBloc({ApiService? tasksApiService, PathCalculator? calculator})
    : _apiService = tasksApiService ?? ApiServiceImpl(),
      _calculator = calculator ?? PathCalculator(),
      super(const MainFlowInitial()) {
    on<StartProcessEvent>(_onStartProcess);
    on<SendResultsEvent>(_onSendResults);
    on<ResetTasksEvent>(_onReset);
  }

  final ApiService _apiService;
  final PathCalculator _calculator;

  Future<void> _onStartProcess(
    StartProcessEvent event,
    Emitter<MainFlowState> emit,
  ) async {
    emit(const MainFlowLoading());

    try {
      await StorageService.saveUrl(event.url);
      final rawTasks = await _apiService.fetchTasks(event.url);

      if (rawTasks.isEmpty) {
        emit(const MainFlowError(message: 'Server returned empty tasks list'));
        return;
      }

      emit(const MainFlowCalculating(progress: 0.0, percentage: 0));

      final solvedTasks = <Item>[];
      final results = <Result>[];
      final total = rawTasks.length;

      for (var i = 0; i < total; i++) {
        final task = rawTasks[i];
        final path = _calculator.findPath(
          field: task.field,
          start: task.start,
          end: task.end,
        );

        final solvedTask = task.copyWith(path: path);
        solvedTasks.add(solvedTask);

        results.add(
          Result(id: task.id, steps: path, path: solvedTask.pathString),
        );

        final percent = (((i + 1) / total) * 100).toInt();
        emit(
          MainFlowCalculating(progress: (i + 1) / total, percentage: percent),
        );

        await Future<void>.delayed(const Duration(milliseconds: 30));
      }

      emit(
        MainFlowCalculationCompleted(
          tasks: solvedTasks,
          results: results,
          url: event.url,
        ),
      );
    } on ApiException catch (e) {
      emit(MainFlowError(message: e.message));
    } catch (e) {
      emit(MainFlowError(message: 'Unexpected error: $e'));
    }
  }

  Future<void> _onSendResults(
    SendResultsEvent event,
    Emitter<MainFlowState> emit,
  ) async {
    final currentState = state;
    List<Item>? tasks;
    List<Result>? results;
    String? url;

    if (currentState is MainFlowCalculationCompleted) {
      tasks = currentState.tasks;
      results = currentState.results;
      url = currentState.url;
    } else if (currentState is MainFlowError && currentState.canRetrySend) {
      tasks = currentState.tasks;
      results = currentState.results;
      url = currentState.url;
    }

    if (tasks == null || results == null || url == null) {
      return;
    }

    emit(MainFlowSending(tasks: tasks, results: results, url: url));

    try {
      await _apiService.sendResults(url, results);
      emit(MainFlowSendSuccess(tasks: tasks, results: results));
    } on ApiException catch (e) {
      emit(
        MainFlowError(
          message: e.message,
          tasks: tasks,
          results: results,
          url: url,
        ),
      );
    } catch (e) {
      emit(
        MainFlowError(
          message: 'Message error: $e',
          tasks: tasks,
          results: results,
          url: url,
        ),
      );
    }
  }

  void _onReset(ResetTasksEvent event, Emitter<MainFlowState> emit) {
    emit(const MainFlowInitial());
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracking/features/tasks/repositories/task_Reop.dart';
import 'package:task_tracking/features/tasks/tracking_bloc/tracking_event.dart';
import 'package:task_tracking/features/tasks/tracking_bloc/tracking_state.dart';

import '../model_task/task_model.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  Timer? _timer;
  late StreamSubscription<List<TaskModel>> getTasksStream;
  TrackingBloc()
    : super(TrackingState(tasks: [], commitGraph: {}, lineGraph: {})) {
    on<AddTask>(_onAddTask);
    on<ToggleTimer>(_onToggleTimer);
    on<StartTimer>(_onStartTimer);
    on<StopTimer>(_onStopTimer);
    on<Tap>(_onTap);
    on<ListenTask>(_onListenTask);
    on<UpdateTask>(_onUpdateTask);
    on<LoadingGraphData>(_onLoadingGraphData);
  }
  FutureOr<void> _onAddTask(AddTask event, Emitter<TrackingState> emit) {
    TaskReop().addData(event.name.toString(), event.description.toString());
  }

  FutureOr<void> _onToggleTimer(
    ToggleTimer event,
    Emitter<TrackingState> emit,
  ) {
    if (state.isRunning && state.currentIndex == event.index) {
      add(StopTimer());
    } else {
      add(StartTimer());
    }
    emit(
      state.copyWith(isRunning: !state.isRunning, currentIndex: event.index),
    );
  }

  FutureOr<void> _onStartTimer(
    StartTimer event,
    Emitter<TrackingState> emit,
  ) async {
    _timer?.cancel();
    // if (state.isRunning) return;
    final taskId = state.tasks![state.currentIndex].id;
    String sessionId = await TaskReop().startSession(taskId);
    emit(
      state.copyWith(
        isRunning: true,
        seconds: state.tasks![state.currentIndex].second,
        currentSession: sessionId,
      ),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(Tap());
    });

    emit(state.copyWith(isRunning: true));
  }
  // state.copyWith(seconds: state.tasks![state.currentIndex].second)

  FutureOr<void> _onStopTimer(
    StopTimer event,
    Emitter<TrackingState> emit,
  ) async {
    final taskId = state.tasks![state.currentIndex].id;
    final sessionId = state.currentSession;
    state.seconds;
    _timer?.cancel();
    await TaskReop().updateTaskSecond(
      state.tasks![state.currentIndex].id,
      state.seconds,
    );
    await TaskReop().stopSession(taskId, sessionId, state.seconds);
    emit(
      state.copyWith(
        isRunning: false,
        currentIndex: -1,
        seconds: 0,
        currentSession: null,
      ),
    );
  }

  FutureOr<void> _onTap(Tap event, Emitter<TrackingState> emit) {
    emit(state.copyWith(seconds: state.seconds + 1));
    // log("New time == ${state.seconds}");
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  FutureOr<void> _onListenTask(ListenTask event, Emitter<TrackingState> emit) {
    final listenValue = TaskReop().getTasksStream();
    listenValue.listen((List<TaskModel> tasks) {
      add(UpdateTask(tasks: tasks));
    });
  }

  FutureOr<void> _onUpdateTask(UpdateTask event, Emitter<TrackingState> emit) {
    emit(state.copyWith(tasks: event.tasks));
  }

  FutureOr<void> _onLoadingGraphData(
    LoadingGraphData event,
    Emitter<TrackingState> emit,
  ) async {
    final lineGraph = await TaskReop().getDailySeconds(event.id);
    final commitGraph = await TaskReop().getYearlyHours(event.id);
    emit(state.copyWith(commitGraph: commitGraph, lineGraph: lineGraph));
  }
}

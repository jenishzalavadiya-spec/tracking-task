import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:task_tracking/firebase_fanction.dart';
import 'package:task_tracking/task_model.dart';
import 'package:task_tracking/tracking_event.dart';
import 'package:task_tracking/tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  Timer? _timer;
  late StreamSubscription<List<TaskModel>> getTasksStream;
  TrackingBloc() : super(TrackingState(tasks: [])) {
    on<AddTask>(_onAddTask);
    on<ToggleTimer>(_onToggleTimer);
    on<StartTimer>(_onStartTimer);
    on<StopTimer>(_onStopTimer);
    on<Tap>(_onTap);
    on<ListenTask>(_onListenTask);
    on<UpdateTask>(_onUpdateTask);
  }

  FutureOr<void> _onAddTask(AddTask event, Emitter<TrackingState> emit) {
    AddData().addData(event.name.toString(), event.description.toString());
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
    // if (state.isRunning) return;
    emit(state.copyWith(seconds: state.tasks![state.currentIndex].second));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(Tap());
    });

    emit(state.copyWith(isRunning: true));
  }

  FutureOr<void> _onStopTimer(
    StopTimer event,
    Emitter<TrackingState> emit,
  ) async {
    _timer?.cancel();
    // log("task to update == ${state.tasks?[state.currentIndex].id}");
    // log("current index  == ${state.currentIndex}");
    // log("task  == ${state.tasks}");
    await AddData().updateTaskSecond(
      state.tasks![state.currentIndex].id,
      state.seconds,
    );
    emit(state.copyWith(isRunning: false, currentIndex: -1, seconds: 0));
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
    final listenvalue = AddData().getTasksStream();
    listenvalue.listen((List<TaskModel> tasks) {
      add(UpdateTask(tasks: tasks));
    });
  }

  FutureOr<void> _onUpdateTask(UpdateTask event, Emitter<TrackingState> emit) {
    emit(state.copyWith(tasks: event.tasks));
  }
}

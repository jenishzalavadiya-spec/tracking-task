import 'package:task_tracking/task_model.dart';

class TrackingState {
  // final List<Map<String, dynamic>> task;
  // final bool isToggle;
  final bool isRunning;
  final int seconds;
  final int currentIndex;
  final List<TaskModel>? tasks;
  const TrackingState({
    this.currentIndex = 0,
    this.seconds = 0,
    // this.isToggle = false,
    this.isRunning = false,
    this.tasks,
    // this.task = const [],
  });
  TrackingState copyWith({
    bool? isToggle,
    task,
    bool? isRunning,
    int? seconds,
    int? currentIndex,
    List<TaskModel>? tasks,
  }) {
    return TrackingState(
      // isToggle: isToggle ?? this.isToggle,
      // task: task ?? this.task,
      isRunning: isRunning ?? this.isRunning,
      seconds: seconds ?? this.seconds,
      currentIndex: currentIndex ?? this.currentIndex,
      tasks: tasks ?? this.tasks,
    );
  }
}

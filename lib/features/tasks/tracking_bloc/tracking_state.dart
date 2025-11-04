import '../model_task/task_model.dart';

class TrackingState {
  final bool isRunning;
  final int seconds;
  final int currentIndex;
  final String currentSession;
  final List<TaskModel>? tasks;
  const TrackingState({
    this.currentIndex = 0,
    this.seconds = 0,
    this.isRunning = false,
    this.tasks,
    this.currentSession = "",

    // this.isToggle = false,
    // this.task = const [],
    // final List<Map<String, dynamic>> task;
    // final bool isToggle;
  });
  TrackingState copyWith({
    bool? isToggle,
    task,
    bool? isRunning,
    int? seconds,
    int? currentIndex,
    String? currentSession,
    List<TaskModel>? tasks,
  }) {
    return TrackingState(
      // isToggle: isToggle ?? this.isToggle,
      // task: task ?? this.task,
      isRunning: isRunning ?? this.isRunning,
      seconds: seconds ?? this.seconds,
      currentIndex: currentIndex ?? this.currentIndex,
      tasks: tasks ?? this.tasks,
      currentSession: currentSession ?? this.currentSession,
    );
  }
}

import '../model_task/task_model.dart';

class TrackingState {
  final bool isRunning;
  final int seconds;
  final int currentIndex;
  final String currentSession;
  final List<TaskModel>? tasks;
  final Map<DateTime, double>? commitGraph;
  final Map<String, int>? lineGraph;
  const TrackingState({
    this.commitGraph,
    this.lineGraph,
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
    Map<String, int>? lineGraph,
    Map<DateTime, double>? commitGraph,
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
      lineGraph: lineGraph ?? this.lineGraph,
      commitGraph: commitGraph ?? this.commitGraph,
    );
  }
}

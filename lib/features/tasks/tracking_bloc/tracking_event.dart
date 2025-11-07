import '../model_task/task_model.dart';

abstract class TrackingEvent {}

class AddTask extends TrackingEvent {
  final String name;
  final String description;

  AddTask({required this.name, required this.description});
}

class ToggleTimer extends TrackingEvent {
  final int index;
  ToggleTimer(this.index);
}

class StartTimer extends TrackingEvent {}

class StopTimer extends TrackingEvent {}

class Tap extends TrackingEvent {}

class ListenTask extends TrackingEvent {}

class UpdateTask extends TrackingEvent {
  final List<TaskModel> tasks;

  UpdateTask({required this.tasks});
}

class LoadingGraphData extends TrackingEvent {
  final String id;
  LoadingGraphData({required this.id});
}

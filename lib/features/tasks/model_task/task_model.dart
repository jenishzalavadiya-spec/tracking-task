class TaskModel {
  final String taskName;
  final String description;
  final dynamic id;
  final int second;
  final int session;
  final String currentSession;

  TaskModel({
    required this.description,
    required this.taskName,
    required this.second,
    required this.id,
    required this.session,
    required this.currentSession,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      //firebase document
      session: map["session"] ?? 0,
      id: map["id"] ?? "",
      second: map["second"] ?? 0,
      taskName: map["taskName"] ?? "",
      description: map["description"] ?? "",
      currentSession: map["currentSession"]?.toString() ?? "",
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "taskName": taskName,
      "description": description,
      "second": second,
      "session": session,
    };
  }
}

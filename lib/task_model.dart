class TaskModel {
  final String taskName;
  final String description;
  final dynamic id;
  final int second;

  TaskModel({
    required this.description,
    required this.taskName,
    required this.second,
    required this.id,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      //firebase document
      id: map["id"] ?? "",
      second: map["second"] ?? 0,
      taskName: map["taskName"] ?? "",
      description: map["description"] ?? "",
    );
  }
  Map<String, dynamic> toMap() {
    return {"taskName": taskName, "description": description, "second": second};
  }
}

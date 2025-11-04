import 'package:flutter/material.dart';
import 'package:task_tracking/features/tasks/repositories/task_Reop.dart';
import 'package:task_tracking/features/tasks/widgets/graph_widget.dart';

class TaskDataScreen extends StatefulWidget {
  final String taskId;
  const TaskDataScreen({super.key, required this.taskId});

  @override
  State<TaskDataScreen> createState() => _TaskDataScreenState();
}

class _TaskDataScreenState extends State<TaskDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Task Graph"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: FutureBuilder<Map<String, int>>(
        future: TaskReop().getDailySeconds(widget.taskId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: EdgeInsets.all(17),
            child: WeeklyChart(data: snapshot.data!),
          );
        },
      ),
    );
  }
}

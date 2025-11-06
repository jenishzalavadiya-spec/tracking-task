import 'package:flutter/material.dart';
import 'package:task_tracking/features/tasks/model_task/task_model.dart';
import 'package:task_tracking/features/tasks/repositories/task_Reop.dart';
import 'package:task_tracking/features/tasks/widgets/yearly_graph_widget.dart';

import '../widgets/graph_widget.dart';

class TaskDataScreen extends StatefulWidget {
  final TaskModel task;
  const TaskDataScreen({super.key, required this.task});

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Map<String, int>>(
              future: TaskReop().getDailySeconds(widget.task.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: EdgeInsets.all(17),
                  child: GraphWidget(data: snapshot.data!, task: widget.task),
                );
              },
            ),
            FutureBuilder<Map<DateTime, double>>(
              future: TaskReop().getYearlyHours(widget.task.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 3),
                        ),
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(15),
                          child: YearlyGraphWidget(data: snapshot.data!),
                        ),
                      ),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

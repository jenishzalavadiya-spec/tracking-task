import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracking/features/tasks/model_task/task_model.dart';
import 'package:task_tracking/features/tasks/tracking_bloc/tracking_bloc.dart';
import 'package:task_tracking/features/tasks/tracking_bloc/tracking_event.dart';
import 'package:task_tracking/features/tasks/tracking_bloc/tracking_state.dart';
import 'package:task_tracking/features/tasks/widgets/graph_widget.dart';
import 'package:task_tracking/features/tasks/widgets/yearly_graph_widget.dart';

class TaskDataScreen extends StatefulWidget {
  final TaskModel task;
  const TaskDataScreen({super.key, required this.task});

  @override
  State<TaskDataScreen> createState() => _TaskDataScreenState();
}

class _TaskDataScreenState extends State<TaskDataScreen> {
  @override
  void initState() {
    context.read<TrackingBloc>().add(LoadingGraphData(id: widget.task.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Task Graph"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<TrackingBloc, TrackingState>(
                builder: (context, state) {
                  context.read<TrackingBloc>().add(
                    LoadingGraphData(id: widget.task.id),
                  );

                  return (state.lineGraph.isEmpty && state.commitGraph.isEmpty)
                      ? Center(child: Text("Data Not Found"))
                      : Column(
                          children: [
                            GraphWidget(
                              data: state.lineGraph,
                              task: widget.task,
                            ),
                            SizedBox(height: 30),
                            YearlyGraphWidget(data: state.commitGraph),
                          ],
                        );
                },
              ),

              // FutureBuilder<Map<String, int>>(
              //   future: TaskReop().getDailySeconds(widget.task.id),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return Center(child: CircularProgressIndicator());
              //     }
              //     return Padding(
              //       padding: EdgeInsets.all(17),
              //       child: GraphWidget(data: snapshot.data!, task: widget.task),
              //     );
              //   },
              // ),
              // FutureBuilder<Map<DateTime, double>>(
              //   future: TaskReop().getYearlyHours(widget.task.id),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(child: CircularProgressIndicator());
              //     }
              //     if (snapshot.hasData) {
              //       return Column(
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //               border: Border.all(color: Colors.black12, width: 3),
              //             ),
              //             child: Padding(
              //               padding: EdgeInsetsGeometry.all(15),
              //               child: YearlyGraphWidget(data: snapshot.data!),
              //             ),
              //           ),
              //         ],
              //       );
              //     }
              //     if (snapshot.hasError) {
              //       return Text("${snapshot.error}");
              //     }
              //     return Container();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

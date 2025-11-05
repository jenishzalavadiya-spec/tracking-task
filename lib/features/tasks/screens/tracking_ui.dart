import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracking/core/utils.dart';
import 'package:task_tracking/features/tasks/screens/task_data_screen.dart';
import 'package:task_tracking/features/tasks/tracking_bloc/tracking_bloc.dart';
import 'package:task_tracking/features/tasks/widgets/alert_dialog_widget.dart';

import '../tracking_bloc/tracking_event.dart';
import '../tracking_bloc/tracking_state.dart';

class TrackingUi extends StatefulWidget {
  const TrackingUi({super.key});

  @override
  State<TrackingUi> createState() => _TrackingUiState();
}

class _TrackingUiState extends State<TrackingUi> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  @override
  void initState() {
    context.read<TrackingBloc>().add(ListenTask());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        final tasks = state.tasks!;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Your Task'),
            backgroundColor: Colors.deepPurple.shade100,
          ),
          body: ListView.builder(
            itemCount: tasks.length,
            // state.task.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TaskDataScreen(task: state.tasks![index]),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Clicked${tasks[index].taskName}")),
                  );
                },
                child: Card(
                  color: Colors.purple.shade50,
                  child: ListTile(
                    title: Text(
                      tasks[index].taskName,
                      // state.task[index]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      tasks[index].description,
                      // snapshot.data!.docs[index]['description'],
                      // state.task[index]['Description']
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.currentIndex == index && state.isRunning)
                          Text(
                            Utils().trackerTime(state.seconds),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        IconButton(
                          iconSize: 30,
                          onPressed: () {
                            context.read<TrackingBloc>().add(
                              ToggleTimer(index),
                            );
                          },
                          icon: state.isRunning && state.currentIndex == index
                              ? Icon(Icons.pause_circle_filled_sharp)
                              : Icon(Icons.play_circle_fill_sharp),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialogBox();
                },
              );
            },

            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

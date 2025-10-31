import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracking/tracking_bloc.dart';
import 'package:task_tracking/tracking_event.dart';
import 'package:task_tracking/tracking_state.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({super.key});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrackingBloc, TrackingState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskNameController,
                decoration: const InputDecoration(hintText: "task Name"),
              ),
              TextField(
                controller: taskDescriptionController,
                decoration: const InputDecoration(hintText: "Description"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final name = taskNameController.text.trim();
                final description = taskDescriptionController.text.trim();

                if (name.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                context.read<TrackingBloc>().add(
                  AddTask(name: name, description: description),
                );

                taskNameController.clear();
                taskDescriptionController.clear();
                Navigator.pop(context);
              },

              child: const Text('Ok'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

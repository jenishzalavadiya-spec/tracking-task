import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracking/features/tasks/screens/tracking_ui.dart';
import 'package:task_tracking/features/tasks/tracking_bloc/tracking_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    // DevicePreview(enabled: true, builder: (context) =>
    MyApp(),
  );
  // );
  // runApp(DevicePreview(enabled: true, tools: [const MyApp()]));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => TrackingBloc())],
      child: const MaterialApp(home: TrackingUi()),
    );
  }
}

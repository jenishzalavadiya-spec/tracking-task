import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model_task/task_model.dart';

class TaskReop {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  addData(String taskName, String taskDescription) async {
    if (taskName == "" && taskDescription == "") {
      log('Enter required data');
    } else {
      DocumentReference docRef = firestore.collection("task").doc();
      await docRef
          .set({
            'id': docRef.id,
            "taskName": taskName,
            "description": taskDescription,
          })
          .then((value) {
            log('data Inserted');
          });
    }
  }

  startSession(String taskId) async {
    DocumentReference docRef = firestore
        .collection('task')
        .doc(taskId)
        .collection('session')
        .doc();
    await docRef.set({
      "second": 0,
      "startTime": FieldValue.serverTimestamp(),
      "status": "active",
    });
    return docRef.id;
  }

  stopSession(String taskId, String sessionId, int second) async {
    await firestore
        .collection("task")
        .doc(taskId)
        .collection("session")
        .doc(sessionId)
        .update({
          "endTime": FieldValue.serverTimestamp(),
          "second": 0,
          "status": "completed",
        });
  }

  // not sort
  // Future<Map<String, int>> getDailySeconds(String taskId) async {
  //   final session = await firestore
  //       .collection("task")
  //       .doc(taskId)
  //       .collection("session")
  //       .get();
  //
  //   Map<String, int> dailyData = {};
  //
  //   for (var doc in session.docs) {
  //     final data = doc.data();
  //
  //     final Timestamp? startStamp = data["startTime"];
  //     final Timestamp? endStamp = data["endTime"];
  //
  //     if (startStamp == null) continue;
  //
  //     DateTime start = startStamp.toDate();
  //     DateTime end =
  //         endStamp?.toDate() ?? DateTime.now(); // If running session ✅
  //
  //     int sec = end.difference(start).inSeconds;
  //
  //     // ✅ Format key: 2025-11-01
  //     final key = "${start.year}-${start.month}-${start.day}";
  //
  //     // ✅ Add seconds for that day
  //     dailyData[key] = (dailyData[key] ?? 0) + sec;
  //   }
  //
  //   return dailyData;
  // }

  updateTaskSecond(String docId, int second) async {
    await FirebaseFirestore.instance.collection('task').doc(docId).update(({
      "second": second,
    }));
  }

  Stream<List<TaskModel>> getTasksStream() {
    return FirebaseFirestore.instance
        .collection("task")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<Map<String, int>> getDailySeconds(String taskId) async {
    final session = await firestore
        .collection("task")
        .doc(taskId)
        .collection("session")
        .get();

    Map<String, int> dailyData = {};

    for (var doc in session.docs) {
      final data = doc.data();

      final Timestamp? startStamp = data["startTime"];
      final Timestamp? endStamp = data["endTime"];

      if (startStamp == null) continue;

      DateTime start = startStamp.toDate();
      DateTime end = endStamp?.toDate() ?? DateTime.now();

      int sec = end.difference(start).inSeconds;

      final key =
          "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";

      dailyData[key] = (dailyData[key] ?? 0) + sec;
    }

    final sortedEntries = dailyData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Map.fromEntries(sortedEntries);
  }

  Future<Map<DateTime, double>> getYearlyHours(String taskId) async {
    final now = DateTime.now();
    final yearStart = DateTime(now.year, 1, 1);
    final yearEnd = DateTime(now.year + 1, 1, 0);

    final query = await FirebaseFirestore.instance
        .collection("task")
        .doc(taskId)
        .collection("session")
        .where("startTime", isGreaterThanOrEqualTo: yearStart)
        .where("endTime", isLessThanOrEqualTo: yearEnd)
        .get();

    Map<DateTime, double> yearlyData = {};

    for (var doc in query.docs) {
      final data = doc.data();
      final start = (data["startTime"] as Timestamp).toDate();
      final end = (data["endTime"] as Timestamp).toDate();

      final hours = end.difference(start).inSeconds / 3600;

      final dayKey = DateTime(start.year, start.month, start.day);
      yearlyData[dayKey] = (yearlyData[dayKey] ?? 0) + hours;
    }

    return yearlyData;
  }
}

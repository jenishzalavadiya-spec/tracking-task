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
}

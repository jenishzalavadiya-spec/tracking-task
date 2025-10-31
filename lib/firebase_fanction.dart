import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_tracking/task_model.dart';

class AddData {
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

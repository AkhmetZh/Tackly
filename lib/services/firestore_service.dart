import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class FirestoreService {
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> saveTask(TaskModel task) async {
    await tasksCollection.doc(task.id).set(task.toFirestore());
  }

  Future<void> updateTask(TaskModel task) async {
    await tasksCollection.doc(task.id).update(task.toFirestore());
  }

  Future<void> deleteTask(String id) async {
    await tasksCollection.doc(id).delete();
  }

  Future<List<TaskModel>> getTasksFromFirestore() async {
    final snapshot = await tasksCollection.get();

    return snapshot.docs.map((doc) {
      return TaskModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }
}
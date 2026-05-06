import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/api_service.dart';
import '../services/firestore_service.dart';

class TaskProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService = FirestoreService();

  List<TaskModel> tasks = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadTasks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final firestoreTasks = await _firestoreService.getTasksFromFirestore();

      if (firestoreTasks.isNotEmpty) {
        tasks = firestoreTasks;
      } else {
        tasks = await _apiService.fetchTasks();

        for (final task in tasks) {
          await _firestoreService.saveTask(task);
        }
      }
    } catch (e) {
      errorMessage = 'No internet connection or failed to load data.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, TaskPriority priority) async {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      completed: false,
      priority: priority,
    );

    tasks.insert(0, newTask);
    notifyListeners();

    await _firestoreService.saveTask(newTask);
  }

  Future<void> toggleTask(TaskModel task) async {
    task.completed = !task.completed;
    notifyListeners();

    await _firestoreService.updateTask(task);
  }

  Future<void> deleteTask(TaskModel task) async {
    tasks.remove(task);
    notifyListeners();

    await _firestoreService.deleteTask(task.id);
  }
}
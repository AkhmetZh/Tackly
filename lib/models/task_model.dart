import 'dart:math';

enum TaskPriority {
  low,
  medium,
  high,
}

class TaskModel {
  final String id;
  final String title;
  bool completed;
  final TaskPriority priority;

  TaskModel({
    required this.id,
    required this.title,
    required this.completed,
    required this.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      title: json['title'] ?? 'No title',
      completed: json['completed'] ?? false,
      priority: _randomPriority(),
    );
  }

  factory TaskModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TaskModel(
      id: id,
      title: data['title'] ?? '',
      completed: data['completed'] ?? false,
      priority: _priorityFromString(data['priority'] ?? 'low'),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'completed': completed,
      'priority': priority.name,
    };
  }

  static TaskPriority _randomPriority() {
    final random = Random().nextInt(3);

    if (random == 0) return TaskPriority.low;
    if (random == 1) return TaskPriority.medium;
    return TaskPriority.high;
  }

  static TaskPriority _priorityFromString(String value) {
    switch (value) {
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      default:
        return TaskPriority.low;
    }
  }
}
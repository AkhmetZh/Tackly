import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/task_model.dart';

class ApiService {
  static const String url = 'https://jsonplaceholder.typicode.com/todos';

  Future<List<TaskModel>> fetchTasks() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load tasks');
    }

    final List data = jsonDecode(response.body);

    return data
        .take(20)
        .map((item) => TaskModel.fromJson(item))
        .toList();
  }
}
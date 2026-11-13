import 'dart:convert';
import 'dart:io';

import 'package:no_task_required/data/task.dart';
import 'package:http/http.dart';

class TaskModel {

  Future<void> createTask(String description) async {
    final uri = Uri.http('localhost:3000','/tasks');
    
    final response = await post(uri,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        "description": description,
      }),
    );

    if (response.statusCode != 201) {
      String message = _getMessageFromResponse(response.body);
      throw HttpException(message);
    }

  }

  Future<List<Task>> getTaskList(DateTime date) async {
    String dateISO = date.toIso8601String().split("T")[0];

    final uri = Uri.http('localhost:3000','/tasks/$dateISO');

    final response = await get(uri);

    if (response.statusCode != 200) {
      String message = _getMessageFromResponse(response.body);
      throw HttpException(message);
    }

    List<dynamic> responseBody = jsonDecode(response.body);
    Iterable<Task> tasks = responseBody.map((task) {
      Task newTask = Task.fromJSON(task);
      return newTask;
    });

    return tasks.toList();
  }

  Future<Task> updateTaskStatus(int id, bool iniciated, bool completed) async {

    final uri = Uri.http('localhost:3000','/tasks/$id');

    final response = await patch(uri,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, bool> {
        "iniciated": iniciated,
        "completed": completed,
      }),
    );

    if (response.statusCode != 200) {
      String message = _getMessageFromResponse(response.body);
      throw HttpException(message);
    }

    Task task = Task.fromJSON(jsonDecode(response.body));
    return task;
  }

  String _getMessageFromResponse(String body) {
    Map<String, Object?> responseBody = jsonDecode(body) as Map<String, Object?>;

    String message = "";
    if (responseBody['message'] is String) {
      message = responseBody['message'] as String;
    } else {
      List<dynamic> listMessages = responseBody['message'] as List<dynamic>;
      message = listMessages[0] as String;
    }

    return message;
  }

}
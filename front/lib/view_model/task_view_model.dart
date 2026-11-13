import 'package:flutter/material.dart';
import 'package:no_task_required/data/task.dart';
import 'package:no_task_required/model/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskModel model;
  List<Task> listsOfTasks = [];
  bool isLoading = false;
  String message = "";

  TaskViewModel(this.model);

  Future<void> createTask(String description) async {
    isLoading = true;
    message = "";
    notifyListeners();

    try {
      await model.createTask(description);
      //await Future.delayed(Duration(seconds: 2));
      message = "Task Saved";
    } catch (e) {
      message = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getTaskList(DateTime date) async {
    isLoading = true;
    message = "";
    notifyListeners();

    try {
      //await Future.delayed(Duration(seconds: 2));
      listsOfTasks = await model.getTaskList(date);
      if (listsOfTasks.isEmpty) {
        message = "No tasks for the day";
      }
    } catch (e) {
      message = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateTaskStatus(int id, bool iniciated, bool completed) async {
    isLoading = true;
    message = "";
    notifyListeners();

    try {
      //await Future.delayed(Duration(seconds: 2));
      Task updatedTask = await model.updateTaskStatus(id, iniciated, completed);

      int index = listsOfTasks.indexWhere((elem) => elem.id == id);
      if (!index.isNegative) {
        listsOfTasks[index] = updatedTask;
      }
    } catch (e) {
      message = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
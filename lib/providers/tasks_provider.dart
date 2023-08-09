import 'package:flutter/material.dart';

import '../entities/course/course.dart';
import '../entities/task/task.dart';
import '../managers/storage_manager.dart';

class TasksProvider extends ChangeNotifier {
  final Course course;

  List<Task>? _tasks;
  List<Task>? get tasks => _tasks;

  TasksProvider({required this.course}) {
    loadDataFromStorage();
  }

  String get pageTitle => course.name;

  Future<void> loadDataFromStorage() async {
    List<Task> allTasks = await StorageManager.readFromStorage(
      StorageBoxNames.tasks,
      adapter: TaskAdapter(),
    );
    _tasks = allTasks.where((task) {
      return task.courseKey == course.key;
    }).toList();
    _tasks?.sort((a, b) {
      return a.created.compareTo(b.created);
    });
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    task.courseKey = course.key;
    _tasks?.add(task);
    notifyListeners();
    await StorageManager.writeToStorage(
      StorageBoxNames.tasks,
      adapter: TaskAdapter(),
      key: task.key,
      value: task,
    );
  }

  Future<void> updateTask(Task oldTask, Task newTask) async {
    var task = _tasks?[_tasks!.indexOf(oldTask)];
    task?.name = newTask.name;
    task?.deadline = newTask.deadline;
    task?.note = newTask.note;
    notifyListeners();
    await StorageManager.writeToStorage(
      StorageBoxNames.tasks,
      adapter: TaskAdapter(),
      key: task!.key,
      value: task,
    );
  }

  Future<void> removeTask(Task task) async {
    _tasks?.remove(task);
    notifyListeners();
    await StorageManager.removeFromStorage(
      StorageBoxNames.tasks,
      adapter: TaskAdapter(),
      key: task.key,
    );
  }

  Future<void> changeTaskStatus(Task task) async {
    task.isDone = !task.isDone;
    notifyListeners();
    await StorageManager.writeToStorage(
      StorageBoxNames.tasks,
      adapter: TaskAdapter(),
      key: task.key,
      value: task,
    );
  }
}

import 'package:flutter/material.dart';

import '../entities/course/course.dart';
import '../entities/task/task.dart';
import '../managers/storage_manager.dart';

class CoursesProvider extends ChangeNotifier {
  final _assignedTasks = <int, List<int>>{};
  final _completedTasks = <int, List<int>>{};

  List<Course>? _courses;
  List<Course>? get courses => _courses;

  CoursesProvider() {
    loadDataFromStorage();
    loadMetaData();
  }

  Future<void> loadDataFromStorage() async {
    _courses = await StorageManager.readFromStorage(
      StorageBoxNames.courses,
      adapter: CourseAdapter(),
    );
    _courses?.sort((a, b) {
      return a.created.compareTo(b.created);
    });
    notifyListeners();
  }

  Future<void> loadMetaData() async {
    _assignedTasks.clear();
    _completedTasks.clear();
    List<Task> allTasks = await StorageManager.readFromStorage(
      StorageBoxNames.tasks,
      adapter: TaskAdapter(),
    );
    for (var task in allTasks) {
      (_assignedTasks[task.courseKey] ??= []).add(task.key);
      if (task.isDone) {
        (_completedTasks[task.courseKey] ??= []).add(task.key);
      }
    }
    notifyListeners();
  }

  int getTaskCount(int courseKey) {
    return _assignedTasks[courseKey]?.length ?? 0;
  }

  double getCompletionPercent(int courseKey) {
    return (_assignedTasks[courseKey]?.length ?? 0) != 0
        ? (_completedTasks[courseKey]?.length ?? 0) /
            (_assignedTasks[courseKey]?.length ?? 0)
        : 0;
  }

  Future<void> addCourse(Course course) async {
    _courses?.add(course);
    notifyListeners();
    await StorageManager.writeToStorage(
      StorageBoxNames.courses,
      adapter: CourseAdapter(),
      key: course.key,
      value: course,
    );
  }

  Future<void> updateCourse(Course oldCourse, Course newCourse) async {
    var course = _courses?[_courses!.indexOf(oldCourse)];
    course?.name = newCourse.name;
    course?.professor = newCourse.professor;
    course?.note = newCourse.note;
    notifyListeners();
    await StorageManager.writeToStorage(
      StorageBoxNames.courses,
      adapter: CourseAdapter(),
      key: course!.key,
      value: course,
    );
  }

  Future<void> removeCourse(Course course) async {
    _courses?.remove(course);
    notifyListeners();
    await StorageManager.removeAllFromStorage(
      StorageBoxNames.tasks,
      adapter: TaskAdapter(),
      keys: _assignedTasks[course.key],
    );
    _assignedTasks.remove(course.key);
    await StorageManager.removeFromStorage(
      StorageBoxNames.courses,
      adapter: CourseAdapter(),
      key: course.key,
    );
  }
}

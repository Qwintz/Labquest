import 'package:flutter/material.dart';

import '../entities/task/task.dart';

class TaskFormProvider extends ChangeNotifier {
  final Task? task;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  final _inputController = TextEditingController();
  TextEditingController get inputController => _inputController;

  String taskName = "";
  String taskNote = "";
  DateTime? _taskDeadline;
  DateTime? get taskDeadline => _taskDeadline;
  set taskDeadline(DateTime? deadline) {
    if (deadline != null) {
      _taskDeadline = deadline;
      _inputController.text = deadline.toLocal().toString().split(" ")[0];
      notifyListeners();
    }
  }

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  TaskFormProvider({this.task}) {
    if (task != null) {
      taskName = task!.name;
      taskNote = task!.note ?? "";
      taskDeadline = task!.deadline;
      _inputController.text = taskName;
    }
  }

  void toStep(int index) {
    switch (index) {
      case 0:
        _inputController.text = taskName;
        break;
      case 1:
        _inputController.text =
            taskDeadline?.toLocal().toString().split(" ")[0] ?? "";
        break;
      case 2:
        _inputController.text = taskNote;
        break;
    }
    _currentStep = index;
    notifyListeners();
  }

  bool nameValidate() {
    if (taskName.trim().isEmpty) {
      _isNameValid = false;
    } else {
      _isNameValid = true;
    }
    notifyListeners();
    return _isNameValid;
  }

  void clearNameValidate() {
    _isNameValid = true;
    notifyListeners();
  }

  Task save() {
    return Task(
      key: UniqueKey().hashCode,
      name: taskName.trim(),
      note: taskNote.trim(),
      deadline: _taskDeadline,
      courseKey: 0,
    );
  }
}

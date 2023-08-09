import 'package:flutter/material.dart';

import '../entities/course/course.dart';

class CourseFormProvider extends ChangeNotifier {
  final Course? course;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  final _inputController = TextEditingController();
  TextEditingController get inputController => _inputController;

  String courseName = "";
  String courseProfessor = "";
  String courseNote = "";

  bool _isNameValid = true;
  bool get isNameValid => _isNameValid;

  CourseFormProvider({this.course}) {
    if (course != null) {
      courseName = course!.name;
      courseProfessor = course!.professor ?? "";
      courseNote = course!.note ?? "";
      _inputController.text = courseName;
    }
  }

  void toStep(int index) {
    switch (index) {
      case 0:
        _inputController.text = courseName;
        break;
      case 1:
        _inputController.text = courseProfessor;
        break;
      case 2:
        _inputController.text = courseNote;
        break;
    }
    _currentStep = index;
    notifyListeners();
  }

  bool nameValidate() {
    if (courseName.trim().isEmpty) {
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

  Course save() {
    return Course(
      key: UniqueKey().hashCode,
      name: courseName.trim(),
      professor: courseProfessor.trim(),
      note: courseNote.trim(),
    );
  }
}

import 'package:hive_flutter/hive_flutter.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  int key;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? note;

  @HiveField(3)
  DateTime? deadline;

  @HiveField(4)
  bool isDone;

  @HiveField(5)
  int courseKey;

  @HiveField(6)
  DateTime created = DateTime.now();

  Task({
    this.key = 0,
    required this.name,
    this.note,
    this.deadline,
    this.isDone = false,
    required this.courseKey,
  });
}

import 'package:hive_flutter/hive_flutter.dart';
part 'course.g.dart';

@HiveType(typeId: 0)
class Course {
  @HiveField(0)
  int key;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? note;

  @HiveField(3)
  String? professor;

  @HiveField(4)
  DateTime created = DateTime.now();

  Course({
    this.key = 0,
    required this.name,
    this.note,
    this.professor,
  });
}

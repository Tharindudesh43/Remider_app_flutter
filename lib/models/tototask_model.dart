import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoTask {
  String? id;
  String? title;
  Timestamp? date;
  String? description;
  String? priority;
  String? tasktype;
  ToDoTask({
    this.id,
    this.title,
    this.date,
    this.description,
    this.priority,
    this.tasktype,
  });
}

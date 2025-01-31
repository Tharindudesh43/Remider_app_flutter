import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoTask {
  String? id;
  String? title;
  Timestamp? date;
  String? description;
  String? priority;
  ToDoTask({
    this.id,
    this.title,
    this.date,
    this.description,
    this.priority,
  });
}

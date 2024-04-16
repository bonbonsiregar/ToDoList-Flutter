import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  final String id;
  final String title;
  final bool completed;
  final Timestamp? createdAt;

  TodoItem(
      {required this.id,
      required this.title,
      this.completed = false,
      this.createdAt});

  TodoItem copyWith(
      {String? id, String? title, bool? completed, Timestamp? createdAt}) {
    return TodoItem(
        id: id ?? this.id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'createdAt': createdAt
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      completed: map['completed'],
      createdAt: map['createdAt'] as Timestamp?,
    );
  }
}

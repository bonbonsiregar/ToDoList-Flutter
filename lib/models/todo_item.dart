class TodoItem {
  final String id;
  final String title;
  final bool completed;

  TodoItem({
    required this.id,
    required this.title,
    this.completed = false,
  });

  TodoItem copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      completed: map['completed'],
    );
  }
}

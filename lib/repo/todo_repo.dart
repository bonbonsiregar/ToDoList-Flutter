import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/todo_item.dart';

class TodoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'todo_items';

  Future<void> createTodo(TodoItem todoItem) async {
    await _firestore
        .collection(_collectionName)
        .doc(todoItem.id)
        .set(todoItem.toMap());
  }

  Future<void> updateTodo(TodoItem todoItem) async {
    await _firestore
        .collection(_collectionName)
        .doc(todoItem.id)
        .update(todoItem.toMap());
  }

  Future<void> deleteTodo(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }

  Stream<List<TodoItem>> getTodos() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TodoItem.fromMap(doc.data())).toList();
    });
  }
}

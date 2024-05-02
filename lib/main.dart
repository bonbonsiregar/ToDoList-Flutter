import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/todo_item.dart';
import 'repo/todo_repo.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TodoListApp());
}

class TodoListApp extends StatefulWidget {
  const TodoListApp({Key? key}) : super(key: key);

  @override
  TodoListAppState createState() => TodoListAppState();
}

class TodoListAppState extends State<TodoListApp> {
  final _todoRepository = TodoRepository();
  final _todoItems = <TodoItem>[];
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    _todoRepository.getTodos().listen((todos) {
      setState(() {
        _todoItems.clear();
        _todoItems.addAll(todos);
      });
    });
  }

  Future<void> _addTodo(String title) async {
    final createdAt = Timestamp.now();
    final newTodo = TodoItem(
        id: UniqueKey().toString(), title: title, createdAt: createdAt);
    await _todoRepository.createTodo(newTodo);
    }

  Future<void> _toggleTodo(TodoItem todo) async {
    final updatedTodo = todo.copyWith(completed: !todo.completed);
    await _todoRepository.updateTodo(updatedTodo);
  }

  Future<void> _deleteTodo(TodoItem todo) async {
    await _todoRepository.deleteTodo(todo.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      title: 'To-Do List',
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(199, 86, 86, 187),
            centerTitle: true,
            title: const Text('To-Do List'),
          ),
          body: Column(
            children: [
              TextField(
                controller: _textEditingController,
                onSubmitted: (title) async {
                  await _addTodo(title);
                  _textEditingController.clear();
                },
                decoration: const InputDecoration(
                  hintText: 'Enter a new todo item',
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _todoItems.length,
                  itemBuilder: (context, index) {
                    final todo = _todoItems[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(todo.title),
                          const SizedBox(height: 4.0),
                          Text(
                            _formatTimestamp(todo.createdAt),
                            style: const TextStyle(
                                fontSize: 12.0, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: todo.completed,
                            onChanged: (value) => _toggleTodo(todo),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _deleteTodo(todo),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatTimestamp(Timestamp? timestamp) {
  if (timestamp != null) {
    final dateTime = timestamp.toDate();
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } else {
    return "error";
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(TodoListApp());
}

class TodoListApp extends StatefulWidget {
  @override
  _TodoListAppState createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  final _todoItems = <String>[];
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple To-Do List App',
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text('To-Do List'),
          ),
          body: Column(
            children: [
              TextField(
                controller: _textEditingController,
                onSubmitted: _addTodoItem,
                decoration: InputDecoration(
                  hintText: 'Enter a new todo item',
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _todoItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_todoItems[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeTodoItem(index),
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

  void _addTodoItem(String title) {
    setState(() {
      _todoItems.add(title);
      _textEditingController.clear();
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }
}

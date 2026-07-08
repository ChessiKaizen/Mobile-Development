import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dto/todo_dto.dart';
import '../../models/todo.dart';
import 'repository_exception.dart';

class TodoRepository {
  static final global = TodoRepository(); // unique instance

  
  static const bool _useFakeData = false;

  static const String _firebaseUrl =
      'https://g1-week1todolist-default-rtdb.asia-southeast1.firebasedatabase.app/todos.json';

  final List<Todo> fakeTodos = [
    Todo(id: '1', title: 'Buy groceries', completed: false),
    Todo(id: '2', title: 'Finish Flutter homework', completed: true),
    Todo(id: '3', title: 'Call the dentist', completed: false),
    Todo(id: '4', title: 'Read 20 pages of a book', completed: true),
    Todo(id: '5', title: 'Go for a 30-minute walk', completed: false),
  ];


  Future<List<Todo>> getTodos() async {
    if (_useFakeData) {
    
      return Future.delayed(Duration(seconds: 1), () {
        return fakeTodos;
  
      });
    } else {

      final response = await http.get(Uri.parse(_firebaseUrl));

      if (response.statusCode != 200) {
        throw RepositoryException('Server error: ${response.statusCode}');
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded == null) {
        return [];
      }

      final List<dynamic> jsonList = decoded as List<dynamic>;

      final List<Todo> todos = [];
      for (int i = 0; i < jsonList.length; i++) {
        final item = jsonList[i];
        if (item == null) continue; 
        todos.add(TodoDto.fromJson(i.toString(), item as Map<String, dynamic>));
      }
      return todos;
    }
  }

  Future<void> updateCompleted(String todoId, bool completed) async {
    if (_useFakeData) {

      int index = fakeTodos.indexWhere((e) => e.id == todoId);
      fakeTodos[index] = fakeTodos[index].copyWith(completed);
      return Future.delayed(Duration(milliseconds: 1), () => null);
    } else {

      final url =
          'https://g1-week1todolist-default-rtdb.asia-southeast1.firebasedatabase.app/todos/$todoId.json';
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'completed': completed}),
      );

      if (response.statusCode != 200) {
        throw RepositoryException('Update failed: ${response.statusCode}');
      }
    }
  }
}

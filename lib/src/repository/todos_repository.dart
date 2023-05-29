import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment/src/models/todo_model.dart';

/// [TodosRepository] for managing Todo
class TodosRepository {
  static const String _todosCollection = 'todos';
  static const String _userEmail = 'userEmail';
  static final CollectionReference<TodoModel?> _todos = FirebaseFirestore
      .instance
      .collection(_todosCollection)
      .withConverter<TodoModel?>(
        fromFirestore: (snapshot, _) => snapshot.data() == null
            ? null
            : TodoModel.fromMap(snapshot.data()!),
        toFirestore: (todo, _) => todo?.toMap() ?? {},
      );

  /// [getTodos] for getting todos from firestore
  static Stream<List<TodoModel?>> getTodos(String? userEmail) {
    if (userEmail == null) {
      return const Stream.empty();
    }
    return _todos
        .where(_userEmail, isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// [getTodo] for getting single todo from firestore
  static Stream<TodoModel> getTodo({
    required String id,
  }) {
    return _todos.doc(id).snapshots().map((snapshot) {
      return snapshot.data()!;
    });
  }

  /// [createTodo] for creating todo in firestore
  static Future<void> createTodo({
    required TodoModel todoModel,
  }) async {
    await _todos.add(todoModel).then(
          (value) => updateTodo(
            todoModel: todoModel.copyWith(id: value.id),
          ),
        );
  }

  /// [updateTodo] for updating todo in firestore
  static Future<void> updateTodo({
    required TodoModel todoModel,
  }) async {
    await _todos.doc(todoModel.id).update(todoModel.toMap());
  }

  /// [deleteTodo] for deleting todo in firestore
  static Future<void> deleteTodo({
    required String id,
  }) async {
    await _todos.doc(id).delete();
  }
}

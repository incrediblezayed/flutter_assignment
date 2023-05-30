import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/models/todo_model.dart';
import 'package:flutter_assignment/src/providers/auth_provider.dart';
import 'package:flutter_assignment/src/repository/calendar_repository.dart';
import 'package:flutter_assignment/src/repository/todos_repository.dart';
import 'package:flutter_assignment/src/utils/snackbar.dart';
import 'package:intl/intl.dart';

/// [TodoProvider] for managing Todo
class TodoProvider extends ChangeNotifier {
  /// [titleController] for Title of Todo
  TextEditingController titleController = TextEditingController();

  /// [descriptionController] for Description of Todo
  TextEditingController descriptionController = TextEditingController();

  /// [dateController] for Date of Todo
  TextEditingController dateController = TextEditingController();

  /// [timeController] for Time of Todo
  TextEditingController timeController = TextEditingController();

  /// [selectedDate] for Date of Todo
  DateTime selectedDate = DateTime.now();

  /// [selectedTime] for Time of Todo
  TimeOfDay selectedTime = TimeOfDay.now().replacing(
    minute: TimeOfDay.now().minute < 58 ? TimeOfDay.now().minute + 2 : 0,
    hour: TimeOfDay.now().minute < 58
        ? TimeOfDay.now().hour
        : TimeOfDay.now().hour + 1,
  );

  /// [priority] for Priority of Todo
  Priority priority = Priority.low;

  /// [subTaskControllers] for SubTasks of Todo
  List<TextEditingController> subTaskControllers = [];

  bool _addEventToGoogleCalendar = false;

  /// [addEventToGoogleCalendar] for adding event to google calendar
  bool get addEventToGoogleCalendar => _addEventToGoogleCalendar;
  set addEventToGoogleCalendar(bool value) {
    _addEventToGoogleCalendar = value;
    notifyListeners();
  }

  /// [setPriority] for setting priority of Todo
  void setPriority(Priority priority) {
    this.priority = priority;
    notifyListeners();
  }

  /// [setDate] for setting date of Todo
  void setDate(DateTime date) {
    selectedDate = date;
    dateController.text = DateFormat('dd/MM/yyyy').format(date);
    log('date: $date dateController: ${dateController.text}');
    notifyListeners();
  }

  /// [setTime] for setting time of Todo
  void setTime(TimeOfDay time, BuildContext context) {
    selectedTime = time;
    timeController.text = time.format(context);
    notifyListeners();
  }

  /// [addSubTask] for adding subtask to Todo
  void addSubTask() {
    subTaskControllers.add(TextEditingController());
    notifyListeners();
  }

  /// [removeSubTask] for removing subtask from Todo
  void removeSubTask(int index) {
    subTaskControllers.removeAt(index);
    notifyListeners();
  }

  /// [createTodo] for creating Todo
  Future<void> createTodo(BuildContext context) async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      SnackbarUtils.show(
        message: 'Please enter title and description',
        type: SnackbarType.error,
      );
      return;
    }
    final userEmail = AuthService.currentUser!.email!;
    var todoModel = TodoModel(
      createdAt: DateTime.now(),
      description: descriptionController.text,
      dueDate: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
      id: '',
      isAddedInCalendar: addEventToGoogleCalendar,
      userEmail: userEmail,
      isCompleted: false,
      priority: priority,
      subTasks: subTaskControllers
          .where((element) => element.text.isNotEmpty)
          .map((e) => SubTask(title: e.text, isCompleted: false))
          .toList(),
      title: titleController.text,
    );
    if (addEventToGoogleCalendar) {
      final eventId = await addToCalendar(todoModel, context);
      todoModel = todoModel.copyWith(eventId: eventId);
      await TodosRepository.createTodo(todoModel: todoModel);
    } else {
      await TodosRepository.createTodo(
        todoModel: todoModel,
      );
    }
    clear();
  }

  /// [clear] for clearing all the fields after creating Todo
  void clear() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    timeController.clear();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now().replacing(
      minute: TimeOfDay.now().minute < 58 ? TimeOfDay.now().minute + 2 : 0,
      hour: TimeOfDay.now().minute < 58
          ? TimeOfDay.now().hour
          : TimeOfDay.now().hour + 1,
    );
    priority = Priority.low;
    addEventToGoogleCalendar = false;
    subTaskControllers.clear();
    notifyListeners();
  }

  /// [deleteTodo] for deleting Todo
  Future<void> deleteTodo(TodoModel todoModel, BuildContext context) async {
    if (todoModel.isAddedInCalendar) {
      await deleteFromCalendar(todoModel, context);
    }
    await TodosRepository.deleteTodo(
      id: todoModel.id,
    );
  }

  /// [markTodoAsCompleted] for marking Todo as completed
  Future<void> markTodoAsCompleted(
    TodoModel todoModel,
    BuildContext context,
  ) async {
    if (todoModel.isAddedInCalendar) {
      await deleteFromCalendar(todoModel, context);
    }
    await TodosRepository.updateTodo(
      todoModel: todoModel.copyWith(isCompleted: true),
    );
  }

  /// [markTodoAsInCompleted] for marking Todo as incompleted
  Future<void> markTodoAsInCompleted(
    TodoModel todoModel,
    BuildContext context,
  ) async {
    if (todoModel.isAddedInCalendar) {
      await addToCalendar(todoModel, context);
    }
    await TodosRepository.updateTodo(
      todoModel: todoModel.copyWith(isCompleted: false),
    );
  }

  /// [addToCalendar] for adding Todo to google calendar
  Future<String> addToCalendar(
    TodoModel todoModel,
    BuildContext context,
  ) async {
    final calendarRepository = CalendarRepository.of(context);
    final event = await calendarRepository.createEvent(todoModel);
    return event!;
  }

  /// [deleteFromCalendar] for deleting Todo from google calendar
  Future<void> deleteFromCalendar(
    TodoModel todoModel,
    BuildContext context,
  ) async {
    final calendarRepository = CalendarRepository.of(context);
    await calendarRepository.deleteEvent(todoModel.eventId);
  }

  /// [updateTodo] for updating Todo
  Future<void> updateTodo(TodoModel todoModel) async {
    await TodosRepository.updateTodo(
      todoModel: todoModel,
    );
  }
}

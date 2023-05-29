// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Priority {
  low(color: Colors.blue, icon: Icons.info_sharp, text: 'Low'),
  medium(
    color: Colors.amber,
    icon: Icons.warning,
    text: 'Medium',
  ),
  high(color: Colors.red, icon: Icons.error_outlined, text: 'High');

  const Priority({required this.color, required this.icon, required this.text});
  final String text;
  final Color color;
  final IconData icon;
}

@immutable
class TodoModel {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final DateTime dueDate;
  final List<SubTask> subTasks;
  final bool isCompleted;
  final DateTime createdAt;
  final String userEmail;
  final bool isAddedInCalendar;
  final String eventId;
  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.subTasks,
    required this.isCompleted,
    required this.createdAt,
    required this.userEmail,
    this.isAddedInCalendar = false,
    this.eventId = '',
  });

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    Priority? priority,
    DateTime? dueDate,
    List<SubTask>? subTasks,
    bool? isCompleted,
    DateTime? createdAt,
    String? userEmail,
    bool? isAddedInCalendar,
    String? eventId,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      subTasks: subTasks ?? this.subTasks,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      userEmail: userEmail ?? this.userEmail,
      isAddedInCalendar: isAddedInCalendar ?? this.isAddedInCalendar,
      eventId: eventId ?? this.eventId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'dueDate': Timestamp.fromDate(dueDate),
      'subTasks': subTasks.map((x) => x.toMap()).toList(),
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'userEmail': userEmail,
      'isAddedInCalendar': isAddedInCalendar,
      'eventId': eventId,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: Priority.values.firstWhere(
        (e) => e.name == map['priority'] as String?,
        orElse: () => Priority.low,
      ),
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      subTasks: List<SubTask>.from(
        (map['subTasks'] as List).map<SubTask>(
          (e) => SubTask.fromMap(e as Map<String, dynamic>),
        ),
      ),
      isCompleted: map['isCompleted'] as bool,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      userEmail: map['userEmail'] as String,
      isAddedInCalendar: map['isAddedInCalendar'] as bool? ?? false,
      eventId: map['eventId'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, description: $description, priority: $priority, dueDate: $dueDate, subTasks: $subTasks, isCompleted: $isCompleted, createdAt: $createdAt, userEmail: $userEmail, isAddedInCalendar: $isAddedInCalendar, eventId: $eventId)';
  }

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.priority == priority &&
        other.dueDate == dueDate &&
        listEquals(other.subTasks, subTasks) &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt &&
        other.userEmail == userEmail &&
        other.isAddedInCalendar == isAddedInCalendar &&
        other.eventId == eventId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        priority.hashCode ^
        dueDate.hashCode ^
        subTasks.hashCode ^
        isCompleted.hashCode ^
        createdAt.hashCode ^
        userEmail.hashCode ^
        isAddedInCalendar.hashCode ^
        eventId.hashCode;
  }
}

@immutable
class SubTask {
  const SubTask({
    required this.title,
    required this.isCompleted,
  });
  final String title;
  final bool isCompleted;

  SubTask copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return SubTask(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory SubTask.fromMap(Map<String, dynamic> map) {
    return SubTask(
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubTask.fromJson(String source) =>
      SubTask.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SubTask(title: $title, isCompleted: $isCompleted)';

  @override
  bool operator ==(covariant SubTask other) {
    if (identical(this, other)) return true;

    return other.title == title && other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => title.hashCode ^ isCompleted.hashCode;
}

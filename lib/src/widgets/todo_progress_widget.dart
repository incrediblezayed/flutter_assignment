import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/models/todo_model.dart';

/// [TodoProgressWidget] for showing progress of Todo
class TodoProgressWidget extends StatelessWidget {
  /// Constructor for [TodoProgressWidget]
  const TodoProgressWidget({required this.todoModel, super.key, this.size});

  /// [TodoModel] to display
  final TodoModel todoModel;

  /// Size of the widget
  final double? size;

  @override
  Widget build(BuildContext context) {
    final oldValue = todoModel.isCompleted
        ? 1
        : todoModel.subTasks.isEmpty
            ? 0
            : (todoModel.subTasks
                    .where(
                      (element) => element.isCompleted,
                    )
                    .length /
                todoModel.subTasks.length);
    final theme = Theme.of(context);
    return Hero(
      tag: '${todoModel.id}progress',
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox.square(
          dimension: size ?? 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.square(
                dimension: size ?? 60,
                child: FittedBox(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: oldValue.toDouble(),
                      end: todoModel.isCompleted
                          ? 1
                          : todoModel.subTasks.isEmpty
                              ? 0
                              : (todoModel.subTasks
                                      .where(
                                        (element) => element.isCompleted,
                                      )
                                      .length /
                                  todoModel.subTasks.length),
                    ),
                    duration: const Duration(seconds: 1),
                    builder: (ontext, value, _) {
                      return CircularProgressIndicator(
                        color: todoModel.priority.color,
                        strokeWidth: 1,
                        backgroundColor:
                            todoModel.priority.color.withOpacity(0.2),
                        value: value,
                      );
                    },
                  ),
                ),
              ),
              Text(
                todoModel.isCompleted
                    ? '100%'
                    : todoModel.subTasks.isEmpty
                        ? '0%'
                        : '${(todoModel.subTasks.where((element) => element.isCompleted).length / todoModel.subTasks.length * 100).toInt()}%',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: todoModel.priority.color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

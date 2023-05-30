import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/models/todo_model.dart';
import 'package:flutter_assignment/src/providers/todo_provider.dart';
import 'package:flutter_assignment/src/widgets/added_to_calendar.dart';
import 'package:flutter_assignment/src/widgets/cutom_list_tile.dart';
import 'package:flutter_assignment/src/widgets/remaining_timer.dart';
import 'package:flutter_assignment/src/widgets/todo_progress_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// A [StatefulWidget] to display the details of a [TodoModel]
class TodoDetailsPage extends StatefulWidget {
  /// Creates a [TodoDetailsPage] to display the details of a [TodoModel]
  const TodoDetailsPage({required this.todoModel, super.key});

  /// The [TodoModel] to display
  final TodoModel todoModel;

  @override
  State<TodoDetailsPage> createState() => _TodoDetailsPageState();
}

class _TodoDetailsPageState extends State<TodoDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var todo = widget.todoModel;
    final dbTodoModel = Provider.of<TodoModel?>(context);
    final todoProvider = Provider.of<TodoProvider>(context);

    final theme = Theme.of(context);
    if (dbTodoModel != null) {
      todo = dbTodoModel;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TodoProgressWidget(
                todoModel: todo,
                size: 150,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          todo.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  if (todo.isCompleted) ...[
                    Text(
                      'Completed',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 20,
                    )
                  ] else ...[
                    if (todo.dueDate.isBefore(DateTime.now()))
                      Text(
                        'Overdue: ',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.red,
                        ),
                      )
                    else
                      Text(
                        'Remaining: ',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    RemainingTimerWidget(
                      dueDate: todo.dueDate,
                    )
                  ],
                ],
              ),
              ...[
                Divider(
                  color: theme.dividerColor,
                ),
                SwitchListTile(
                  onChanged: (v) async {
                    if (v) {
                      await todoProvider.addToCalendar(todo, context);
                    } else {
                      await todoProvider.deleteFromCalendar(todo, context);
                    }
                    await todoProvider.updateTodo(
                      todo.copyWith(
                        isAddedInCalendar: v,
                      ),
                    );
                  },
                  value: todo.isAddedInCalendar,
                  contentPadding: EdgeInsets.zero,
                  title: AddedToCalendar(
                    isAdded: todo.isAddedInCalendar,
                  ),
                )
              ],
              Divider(
                color: theme.dividerColor,
              ),
              Row(
                children: [
                  ...[
                    Text(
                      'Priority: ',
                      style: theme.textTheme.bodyLarge,
                    ),
                    Text(
                      todo.priority.text,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: todo.priority.color,
                      ),
                    ),
                  ],
                  const Spacer(),
                  ...[
                    Text(
                      'Due Date: ',
                      style: theme.textTheme.bodyLarge,
                    ),
                    Text(
                      DateFormat.yMMMMd()
                          .addPattern('hh:mm a')
                          .format(todo.dueDate),
                      style: theme.textTheme.bodyLarge,
                    ),
                    if (todo.dueDate.isBefore(DateTime.now()) &&
                        !todo.isCompleted)
                      Text(
                        ' (Overdue)',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                  ],
                ],
              ),
              if (todo.subTasks.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: theme.dividerColor,
                    ),
                    Text(
                      'Sub Tasks',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    ListView(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: todo.subTasks
                          .mapIndexed(
                            (i, e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: CustomListTile(
                                borderColor: e.isCompleted
                                    ? theme.colorScheme.primary
                                    : Colors.grey,
                                iconColor: e.isCompleted
                                    ? theme.primaryColor
                                    : theme.colorScheme.onSurface,
                                text: e.title,
                                icon: Icons.check_circle_outline_sharp,
                                children: [
                                  IgnorePointer(
                                    child: SwitchListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        e.isCompleted
                                            ? 'Completed'
                                            : 'Mark as completed',
                                      ),
                                      value: e.isCompleted,
                                      onChanged: (v) {},
                                    ),
                                  ),
                                ],
                                futureTask: () async {
                                  final subTasks = todo.subTasks;
                                  subTasks[i] =
                                      e.copyWith(isCompleted: !e.isCompleted);
                                  if (!subTasks.any(
                                    (element) => element.isCompleted == false,
                                  )) {
                                    await todoProvider.markTodoAsCompleted(
                                      todo,
                                      context,
                                    );
                                  } else {
                                    await todoProvider.markTodoAsInCompleted(
                                      todo,
                                      context,
                                    );
                                  }

                                  setState(() {});
                                },
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              Divider(
                color: theme.dividerColor,
              ),
              CustomListTile(
                borderColor:
                    todo.isCompleted ? theme.colorScheme.primary : Colors.grey,
                trailing: Switch(
                  value: todo.isCompleted,
                  onChanged: (value) {},
                ),
                text: todo.isCompleted ? 'Completed' : 'Mark as completed',
                futureTask: () async {
                  if (todo.subTasks.isEmpty) {
                    if (todo.isCompleted) {
                      await todoProvider.markTodoAsInCompleted(todo, context);
                    } else {
                      await todoProvider.markTodoAsCompleted(todo, context);
                    }
                    setState(() {});
                  }
                },
                children: [
                  if (!todo.isCompleted && todo.subTasks.isNotEmpty)
                    Text(
                      'Complete all subtasks to mark this task as completed',
                      style: theme.textTheme.bodyLarge,
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

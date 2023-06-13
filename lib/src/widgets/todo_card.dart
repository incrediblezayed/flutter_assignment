import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/models/todo_model.dart';
import 'package:flutter_assignment/src/providers/todo_provider.dart';
import 'package:flutter_assignment/src/repository/todos_repository.dart';
import 'package:flutter_assignment/src/ui/todo_details.dart';
import 'package:flutter_assignment/src/utils/dialog.dart';
import 'package:flutter_assignment/src/utils/routes.dart';
import 'package:flutter_assignment/src/widgets/added_to_calendar.dart';
import 'package:flutter_assignment/src/widgets/cutom_list_tile.dart';
import 'package:flutter_assignment/src/widgets/todo_progress_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// [TodoCard] for displaying Todo
class TodoCard extends StatelessWidget {
  /// Constructor for [TodoCard]
  const TodoCard({required this.todoModel, super.key});

  /// [TodoModel] to display
  final TodoModel todoModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todoProvider = Provider.of<TodoProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            AppRoutes.push(
              StreamProvider(
                create: (_) => TodosRepository.getTodo(id: todoModel.id),
                initialData: null,
                child: TodoDetailsPage(todoModel: todoModel),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: todoModel.priority.color.withOpacity(0.2),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        todoModel.priority.icon,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Priority: ${todoModel.priority.text}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          AppDialog.showBottomSheet<void>(
                            child: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (todoModel.subTasks.isEmpty &&
                                        !todoModel.isCompleted)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: CustomListTile(
                                          onTap: () {
                                            todoProvider
                                                .markTodoAsCompleted(
                                              todoModel,
                                              context,
                                            )
                                                .then((value) {
                                              AppRoutes.pop();
                                            });
                                          },
                                          text: 'Mark as Completed',
                                          textColor: Colors.green,
                                          trailing: const Icon(
                                            Icons.check_box,
                                            color: Colors.green,
                                          ),
                                          borderColor: Colors.green,
                                        ),
                                      ),
                                    CustomListTile(
                                      onTap: () {
                                        todoProvider
                                            .deleteTodo(
                                          todoModel,
                                          context,
                                        )
                                            .then((value) {
                                          AppRoutes.pop();
                                        });
                                      },
                                      borderColor: Colors.red,
                                      trailing: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      textColor: Colors.red,
                                      text: 'Delete',
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const SizedBox.square(
                          dimension: 30,
                          child: Icon(Icons.more_horiz),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      TodoProgressWidget(todoModel: todoModel),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todoModel.title,
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            todoModel.description,
                            style: theme.textTheme.bodyLarge,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  color: theme.dividerColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: todoModel.priority.color,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        DateFormat.yMMMMd().format(todoModel.dueDate),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: todoModel.priority.color,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Icon(
                        Icons.alarm,
                        color: todoModel.priority.color,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        DateFormat.jm().format(todoModel.dueDate),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: todoModel.priority.color,
                        ),
                      ),
                      const Spacer(),
                      if (todoModel.subTasks.isNotEmpty) ...[
                        const Icon(
                          Icons.task_alt_outlined,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${todoModel.subTasks.where((element) => element.isCompleted).length}/${todoModel.subTasks.length}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: todoModel.priority.color,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                if (todoModel.isAddedInCalendar) ...[
                  Divider(
                    color: theme.dividerColor,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: AddedToCalendar(),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

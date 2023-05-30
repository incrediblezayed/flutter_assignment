import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/models/todo_model.dart';
import 'package:flutter_assignment/src/providers/todo_provider.dart';
import 'package:flutter_assignment/src/utils/dialog.dart';
import 'package:flutter_assignment/src/utils/routes.dart';
import 'package:flutter_assignment/src/utils/snackbar.dart';
import 'package:flutter_assignment/src/widgets/added_to_calendar.dart';
import 'package:flutter_assignment/src/widgets/app_button.dart';
import 'package:flutter_assignment/src/widgets/app_textfield.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// [CreateTodo] for creating Todo
class CreateTodo extends StatelessWidget {
  /// Constructor for [CreateTodo]
  const CreateTodo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Consumer<TodoProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.primaryColor,
            title: const Text('Create Todo'),
          ),
          bottomNavigationBar: AppButton(
            heroTag: 'create_todo',
            onPressed: () async {
              unawaited(AppDialog.showLoading<void>());
              await value.createTodo(
                context,
              );
              AppRoutes.pop();
              SnackbarUtils.show(
                message: 'Todo created successfully',
                type: SnackbarType.success,
              );
              AppRoutes.pop();
            },
            child: const Text('Create Todo'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: value.titleController,
                        hintText: 'Title',
                        labelText: 'Title',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      AppTextField(
                        labelText: 'Description',
                        hintText: 'Description',
                        controller: value.descriptionController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              labelText: 'Date',
                              readOnly: true,
                              hintText: DateFormat('dd/MM/yyyy')
                                  .format(DateTime.now()),
                              controller: value.dateController,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                ).then((date) {
                                  if (date != null) {
                                    value.setDate(date);
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: AppTextField(
                              labelText: 'Time',
                              hintText: DateFormat('hh:mm a').format(
                                DateTime.now().add(const Duration(minutes: 2)),
                              ),
                              controller: value.timeController,
                              readOnly: true,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: value.selectedTime,
                                  builder: (context, child) {
                                    return Theme(
                                      data: theme.copyWith(useMaterial3: false),
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: false,
                                        ),
                                        child: child!,
                                      ),
                                    );
                                  },
                                ).then((time) {
                                  if (time != null) {
                                    value.setTime(time, context);
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Select Priority',
                        style: theme.textTheme.titleLarge,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          child: Row(
                            children: [
                              ...Priority.values.map(
                                (e) => Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.horizontal(
                                      left: e == Priority.low
                                          ? const Radius.circular(16)
                                          : Radius.zero,
                                      right: e == Priority.high
                                          ? const Radius.circular(16)
                                          : Radius.zero,
                                    ),
                                    onTap: () {
                                      value.setPriority(e);
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                          left: e == Priority.low
                                              ? const Radius.circular(16)
                                              : Radius.zero,
                                          right: e == Priority.high
                                              ? const Radius.circular(16)
                                              : Radius.zero,
                                        ),
                                        border: Border.all(
                                          color: value.priority == e
                                              ? e.color
                                              : theme.cardColor,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            e.icon,
                                            color: e.color,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            e.text,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: e.color,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Sub Tasks',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ...value.subTaskControllers.mapIndexed(
                        (i, e) => Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: e,
                                hintText: 'Sub Task',
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                value.removeSubTask(i);
                              },
                              icon: const Icon(Icons.delete),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      AppButton(
                        color: Colors.transparent,
                        borderColor: theme.primaryColor,
                        width: size.width,
                        onPressed: () {
                          if (value.subTaskControllers.isEmpty) {
                            value.addSubTask();
                            return;
                          }
                          if (value.subTaskControllers.last.text.isNotEmpty) {
                            value.addSubTask();
                          } else {
                            SnackbarUtils.show(
                              message: 'Please enter sub task',
                              type: SnackbarType.warning,
                            );
                          }
                        },
                        child: Text(
                          'Add Sub Task',
                          style: TextStyle(
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SwitchListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        value: value.addEventToGoogleCalendar,
                        onChanged: (switchVal) {
                          value.addEventToGoogleCalendar = switchVal;
                        },
                        title: const AddedToCalendar(
                          isAdded: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

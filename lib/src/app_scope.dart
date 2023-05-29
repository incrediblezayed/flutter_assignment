import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/models/todo_model.dart';
import 'package:flutter_assignment/src/providers/auth_provider.dart';
import 'package:flutter_assignment/src/providers/storage_provider.dart';
import 'package:flutter_assignment/src/providers/todo_provider.dart';
import 'package:flutter_assignment/src/repository/calendar_repository.dart';
import 'package:flutter_assignment/src/repository/todos_repository.dart';
import 'package:flutter_assignment/src/utils/theme.dart';
import 'package:provider/provider.dart';

/// The initial widget of the application.
/// This widget is the root of the widget tree.
/// and it is responsible for initializing provider
/// and other services.
class AppScope extends StatelessWidget {
  /// Constructor for the [AppScope] widget.
  const AppScope({required this.child, super.key});

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (_) => AuthService.authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => StorageProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: Builder(
        builder: (context) {
          return StorageProvider.of(context).isInitialized
              ? MultiProvider(
                  providers: [
                    StreamProvider<List<TodoModel?>>(
                      create: (_) => TodosRepository.getTodos(
                        Provider.of<User?>(context)?.email,
                      ),
                      initialData: const [],
                    ),
                    ChangeNotifierProvider<AppTheme>(
                      create: AppTheme.new,
                    ),
                    Provider(
                      create: (context) => CalendarRepository(),
                    )
                  ],
                  child: ConnectivityAppWrapper(
                    app: child,
                  ),
                )
              : const MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

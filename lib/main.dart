import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/firebase_options.dart';
import 'package:flutter_assignment/src/app.dart';
import 'package:flutter_assignment/src/app_scope.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AppScope(child: TodoApp()));
}

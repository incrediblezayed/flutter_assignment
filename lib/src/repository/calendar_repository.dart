import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/models/todo_model.dart';
import 'package:provider/provider.dart';

/// [CalendarRepository] for managing Calendar
class CalendarRepository {
  final String _baseUrl = 'https://www.googleapis.com/calendar/v3';
  late Dio _dio;

  /// [init] for initializing [CalendarRepository]
  Future<void> init(String accessToken) async {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
  }

  /// [createEvent] for creating event in google calendar
  Future<String?> createEvent(TodoModel todoModel) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final response = await _dio.post<Map<String, dynamic>>(
        '/calendars/${user!.email}/events',
        data: {
          'summary': todoModel.title,
          'description': todoModel.description,
          'start': {
            'dateTime': todoModel.dueDate.toIso8601String(),
            'timeZone': 'Asia/Kolkata'
          },
          'end': {
            'dateTime': todoModel.dueDate
                .add(const Duration(minutes: 30))
                .toIso8601String(),
            'timeZone': 'Asia/Kolkata'
          },
        },
      );
      if (response.statusCode == 200) {
        return response.data!['id']!.toString();
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  /// [deleteEvent] for deleting event in google calendar
  Future<void> deleteEvent(String eventId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final response = await _dio.delete<Map<String, dynamic>>(
        '/calendars/${user!.email}/events/$eventId',
      );
      if (response.statusCode == 204) {
        log('Event deleted');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// for getting [CalendarRepository] instance from provider
  static CalendarRepository of(BuildContext context) =>
      Provider.of<CalendarRepository>(context, listen: false);
}

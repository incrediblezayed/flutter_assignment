import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/providers/storage_provider.dart';
import 'package:flutter_assignment/src/repository/calendar_repository.dart';
import 'package:flutter_assignment/src/ui/home.dart';
import 'package:flutter_assignment/src/ui/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

///This widget identifies if the user is logged in or not
///and redirects to the appropriate screen.
class RootWidget extends StatelessWidget {
  ///Constructor for [RootWidget]
  const RootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user != null) {
      final accessToken =
          StorageProvider.of(context, listen: false).getAccessToken();
      if (accessToken.isNotEmpty) {
        CalendarRepository.of(context).init(accessToken);
      }
      return const HomePage();
    } else {
      return const OnbaordingScreen();
    }
  }
}

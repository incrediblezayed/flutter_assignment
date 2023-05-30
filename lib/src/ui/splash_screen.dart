import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/providers/auth_provider.dart';
import 'package:flutter_assignment/src/providers/storage_provider.dart';
import 'package:flutter_assignment/src/repository/calendar_repository.dart';
import 'package:flutter_assignment/src/ui/home.dart';
import 'package:flutter_assignment/src/ui/onboarding/onboarding.dart';

///This widget identifies if the user is logged in or not
///and redirects to the appropriate screen.
class SplashScreen extends StatelessWidget {
  ///Constructor for [SplashScreen]
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (ConnectionState.active == snapshot.connectionState) {
          if (snapshot.data != null) {
            AuthService.login().then((value) {
              StorageProvider.of(context, listen: false).setAccessToken(value!);
              final accessToken =
                  StorageProvider.of(context, listen: false).getAccessToken();
              if (accessToken.isNotEmpty) {
                CalendarRepository.of(context).init(accessToken);
              }
            });
            return const HomePage();
          } else {
            return const OnbaordingScreen();
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

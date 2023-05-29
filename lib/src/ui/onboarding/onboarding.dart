import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/providers/auth_provider.dart';
import 'package:flutter_assignment/src/providers/storage_provider.dart';
import 'package:flutter_assignment/src/repository/calendar_repository.dart';
import 'package:flutter_assignment/src/ui/onboarding/onboarding_page.dart';
import 'package:flutter_assignment/src/utils/assets.dart';
import 'package:flutter_assignment/src/widgets/app_button.dart';

/// [OnbaordingScreen] for Onboarding Screen
class OnbaordingScreen extends StatefulWidget {
  /// Constructor for [OnbaordingScreen]
  const OnbaordingScreen({super.key});

  @override
  State<OnbaordingScreen> createState() => _OnbaordingScreenState();
}

class _OnbaordingScreenState extends State<OnbaordingScreen> {
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  late final PageController _pageController =
      PageController(initialPage: _currentPage);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                OnboardingPage(
                  image: Assets.onboarding1(theme.brightness),
                  title: 'Your convenience in making a todo list',
                  description:
                      "Here's a mobile platform that helps you create task or to list so that it can help you in every job easier and faster.",
                ),
                OnboardingPage(
                  image: Assets.onboarding2(theme.brightness),
                  title: 'Find the practicality in making your todo list',
                  description:
                      'Easy-to-understand user interface that makes you more comfortable when you want to create a task or to do list, Todyapp can also improve productivity',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    2,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 10,
                      width: index == _currentPage ? 26 : 10,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: AppButton(
                    onPressed: () {
                      if (_currentPage == 0) {
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      } else {
                        AuthService.login().then((value) {
                          if (value != null) {
                            log(value);

                            StorageProvider.of(context, listen: false)
                                .setAccessToken(value);
                            CalendarRepository.of(context).init(value);
                          }
                        });
                      }
                    },
                    key: ValueKey(_currentPage),
                    color: _currentPage == 1
                        ? theme.colorScheme.onSecondary.withOpacity(0.4)
                        : theme.colorScheme.primary,
                    child: _currentPage == 0
                        ? Text(
                            'Continue',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Assets.google,
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Continue with Google',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

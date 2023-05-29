import 'package:flutter/material.dart';

/// [OnboardingPage] for displaying onboarding page
class OnboardingPage extends StatelessWidget {
  /// [OnboardingPage] constructor
  const OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    super.key,
  });

  /// The image to be displayed on the onboarding page.
  final String image;

  /// The title to be displayed on the onboarding page.
  final String title;

  /// The description to be displayed on the onboarding page.
  final String description;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/providers/auth_provider.dart';
import 'package:flutter_assignment/src/utils/routes.dart';
import 'package:flutter_assignment/src/utils/theme.dart';
import 'package:flutter_assignment/src/widgets/cutom_list_tile.dart';

/// A widget for settings bottom sheeet
///
class SettingsBottomSheet extends StatelessWidget {
  /// Constructor for [SettingsBottomSheet]
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Theme',
            style: theme.textTheme.headlineMedium,
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
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(16),
                      ),
                      onTap: () {
                        appTheme.setThemeMode(
                          ThemeMode.system,
                          context,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(16),
                          ),
                          border: Border.all(
                            color: appTheme.themeMode == ThemeMode.system
                                ? theme.primaryColor
                                : theme.cardColor,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.brightness_auto_outlined,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        appTheme.setThemeMode(
                          ThemeMode.light,
                          context,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: appTheme.themeMode == ThemeMode.light
                                ? theme.primaryColor
                                : theme.cardColor,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.brightness_5_outlined,
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(16),
                      ),
                      onTap: () {
                        appTheme.setThemeMode(
                          ThemeMode.dark,
                          context,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(16),
                          ),
                          border: Border.all(
                            color: appTheme.themeMode == ThemeMode.dark
                                ? theme.primaryColor
                                : theme.cardColor,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.brightness_3_outlined,
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
          CustomListTile(
            onTap: () async {
              await AuthService.logout();
              AppRoutes.pop();
            },
            icon: Icons.power_settings_new_outlined,
            borderColor: Colors.red,
            iconColor: Colors.red,
            textColor: Colors.red,
            text: 'Logout',
          )
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/models/todo_model.dart';
import 'package:flutter_assignment/src/ui/create_todo.dart';
import 'package:flutter_assignment/src/utils/assets.dart';
import 'package:flutter_assignment/src/utils/dialog.dart';
import 'package:flutter_assignment/src/utils/routes.dart';
import 'package:flutter_assignment/src/widgets/setting_bottomsheet.dart';
import 'package:flutter_assignment/src/widgets/todo_card.dart';
import 'package:provider/provider.dart';

/// Homepage [StatelessWidget]
class HomePage extends StatelessWidget {
  /// Creates a [HomePage] widget.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<List<TodoModel?>>(context);
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final user = Provider.of<User?>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.onPrimary,
                theme.colorScheme.onPrimary.withOpacity(0.9),
                theme.colorScheme.onPrimary.withOpacity(0.8),
                theme.colorScheme.onPrimary.withOpacity(0.7),
                theme.colorScheme.onPrimary.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: mediaQuery.viewPadding.top,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user?.photoURL ?? '',
                    height: kToolbarHeight,
                    width: kToolbarHeight,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox.shrink(),
                    errorWidget: (context, url, error) =>
                        const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? '',
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(
                      user?.email ?? '',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        AppDialog.showBottomSheet<void>(
                          child: (context) {
                            return const SettingsBottomSheet();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.settings,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.secondary,
        onPressed: () {
          AppRoutes.push(const CreateTodo());
        },
        child: Icon(
          Icons.add,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      body: todos.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: todos
                    .map(
                      (e) => e == null
                          ? const SizedBox.shrink()
                          : TodoCard(todoModel: e),
                    )
                    .toList(),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.noTodos,
                    height: mediaQuery.size.height * 0.3,
                  ),
                  Text(
                    'No todos yet',
                    style: theme.textTheme.headlineLarge
                        ?.copyWith(color: theme.colorScheme.secondary),
                  ),
                ],
              ),
            ),
    );
  }
}

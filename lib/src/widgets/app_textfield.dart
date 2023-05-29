import 'package:flutter/material.dart';

/// A custom text field used in the app.
class AppTextField extends StatelessWidget {
  /// Constructor for [AppTextField].
  const AppTextField({
    required this.controller,
    super.key,
    this.hintText,
    this.labelText,
    this.onTap,
    this.focusNode,
    this.readOnly = false,
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The hint text for the text field.
  final String? hintText;

  /// The label text for the text field.
  final String? labelText;

  /// Whether the text field is read only.
  final bool readOnly;

  /// The function to be called when the text field is tapped.
  final void Function()? onTap;

  /// The focus node for the text field.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Text(
            labelText ?? '',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        Card(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: theme.colorScheme.onSurface,
          child: TextField(
            readOnly: readOnly,
            keyboardType: TextInputType.name,
            focusNode: focusNode,
            onTap: onTap,
            controller: controller,
            style: theme.textTheme.bodySmall,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}

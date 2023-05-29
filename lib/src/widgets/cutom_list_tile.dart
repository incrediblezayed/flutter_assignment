import 'package:flutter/material.dart';

/// A custom list tile widget.
class CustomListTile extends StatefulWidget {
  /// Constructor for [CustomListTile].
  const CustomListTile({
    required this.text,
    this.icon,
    this.trailing,
    this.onTap,
    super.key,
    this.futureTask,
    this.textColor,
    this.iconColor,
    this.borderColor,
    this.children,
  });

  /// The function to be called when the list tile is tapped.
  final void Function()? onTap;

  /// The function to be called when the list tile is tapped.
  final Future<void> Function()? futureTask;

  /// The icon to be displayed in the list tile.
  final IconData? icon;

  /// The widget to be displayed at the end of the list tile.
  final Widget? trailing;

  /// The text to be displayed in the list tile.
  final String text;

  /// The color of the text in the list tile.
  final Color? textColor;

  /// The color of the icon in the list tile.
  final Color? iconColor;

  /// The color of the border of the list tile.
  final Color? borderColor;

  /// The children to be displayed below the list tile.
  final List<Widget>? children;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      //  height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: (widget.borderColor ?? theme.colorScheme.onSurface)
              .withOpacity(0.6),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        onTap: widget.onTap ??
            () async {
              setState(() {
                loading = true;
              });
              await widget.futureTask?.call();
              setState(() {
                loading = false;
              });
            },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.textColor ?? theme.colorScheme.onSurface,
                    ),
                  ),
                  widget.trailing ??
                      Icon(
                        widget.icon,
                        color: widget.iconColor ?? theme.colorScheme.onSurface,
                      ),
                ],
              ),
              if (widget.children != null) ...widget.children!,
              if (widget.futureTask != null)
                LinearProgressIndicator(
                  value: loading ? null : 0,
                  color: theme.primaryColor,
                  backgroundColor: Colors.transparent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

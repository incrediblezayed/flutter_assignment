import 'package:flutter/material.dart';

/// A custom list tile widget.
class CustomListTile extends StatefulWidget {
  /// Constructor for [CustomListTile].
  const CustomListTile({
    required this.text,
    this.isCompleted = false,
    this.trailing,
    this.onTap,
    super.key,
    this.futureTask,
    this.textColor,
    this.borderColor,
    this.children,
  });

  /// The function to be called when the list tile is tapped.
  final void Function()? onTap;

  /// The function to be called when the list tile is tapped.
  final Future<void> Function()? futureTask;

  /// The widget to be displayed at the end of the list tile.
  final Widget? trailing;

  /// The text to be displayed in the list tile.
  final String text;

  /// The color of the text in the list tile.
  final Color? textColor;

  /// The color of the border of the list tile.
  final Color? borderColor;

  /// The children to be displayed below the list tile.
  final List<Widget>? children;

  /// To identify the subtask is completed
  final bool isCompleted;

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
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
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
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            Icons.check_circle_outline_outlined,
                            key: ValueKey(widget.isCompleted),
                            color: widget.isCompleted
                                ? theme.primaryColor
                                : Colors.grey,
                          ),
                        ),
                  ],
                ),
                if (widget.children != null) ...widget.children!,
                if (loading)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        color: theme.primaryColor,
                        minHeight: 5,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

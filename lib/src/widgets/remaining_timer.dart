import 'dart:async';

import 'package:flutter/material.dart';

/// A widget that displays the remaining time for the due date.
class RemainingTimerWidget extends StatefulWidget {
  /// Constructor for [RemainingTimerWidget].
  const RemainingTimerWidget({required this.dueDate, super.key});

  /// The due date.
  final DateTime dueDate;

  @override
  State<RemainingTimerWidget> createState() => _RemainingTimerWidgetState();
}

class _RemainingTimerWidgetState extends State<RemainingTimerWidget> {
  Timer? timer;

  String _printDuration(Duration duration) {
    String twoDigits(int n) =>
        (n.isNegative ? n * -1 : n).toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      this.timer = timer;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      _printDuration(widget.dueDate.difference(DateTime.now())),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.red,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_assignment/src/utils/assets.dart';

/// This widget is used to show the added to calendar message.
class AddedToCalendar extends StatelessWidget {
  /// Constructor for [AddedToCalendar]
  const AddedToCalendar({super.key, this.isAdded = true});

  /// If the event is added to the calendar or not.
  final bool isAdded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Image.asset(
          Assets.calendar,
          width: 30,
          height: 30,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          '${isAdded ? 'Added' : 'Add'} to Google Calendar',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(
          width: 4,
        ),
        if (isAdded)
          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 16,
          ),
      ],
    );
  }
}

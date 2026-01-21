import 'package:flutter/material.dart';

class LikertChoice extends StatefulWidget{

  const LikertChoice({super.key})

  @override
  State<LikertChoice> createState() => _LikertChoiceState();
}

class _LikertChoiceState extends State<LikertChoice> {

  int score = 1;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: const <ButtonSegment<int>>[
        ButtonSegment<int>(
          value: 1,
          label: Text('Day'),
          icon: Icon(Icons.calendar_view_day),
        ),
        ButtonSegment<int>(
          value: 2,
          label: Text('Week'),
          icon: Icon(Icons.calendar_view_week),
        ),
        ButtonSegment<int>(
          value: 3,
          label: Text('Month'),
          icon: Icon(Icons.calendar_view_month),
        ),
        ButtonSegment<int>(
          value: 4,
          label: Text('Year'),
          icon: Icon(Icons.calendar_today),
        ),
        ButtonSegment<int>(
          value: 5,
          label: Text('Year'),
          icon: Icon(Icons.calendar_today),
        ),
      ],
      selected: <int>{score},
      onSelectionChanged: (Set<int> newSelection) {
        setState(() {
          score = newSelection.first;
        });
      },
    );
  }
}

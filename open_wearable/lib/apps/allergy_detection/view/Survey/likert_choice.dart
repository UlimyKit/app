import 'package:flutter/material.dart';

class LikertChoice extends StatefulWidget{

  LikertChoice({super.key});

  @override
  State<LikertChoice> createState() {
    return _LikertChoiceState();
  }
}

class _LikertChoiceState extends State<LikertChoice> {

  int score = 1;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: <ButtonSegment<int>>[
        ButtonSegment<int>(
          value: 1,
          label: Text("Strongly Disagree"),
          icon: const Icon(Icons.calendar_view_day),
        ),
        ButtonSegment<int>(
          value: 2,
          label: Text("Disagree"),
          icon: Icon(Icons.calendar_view_week),
        ),
        ButtonSegment<int>(
          value: 3,
          label: Text("Neutral"),
          icon: Icon(Icons.calendar_view_month),
        ),
        ButtonSegment<int>(
          value: 4,
          label: Text("Agree"),
          icon: Icon(Icons.calendar_today),
        ),
        ButtonSegment<int>(
          value: 5,
          label: Text("Strongly Agree"),
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

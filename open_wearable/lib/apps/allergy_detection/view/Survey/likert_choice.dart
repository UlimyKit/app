import 'package:flutter/material.dart';

class LikertChoice extends StatefulWidget{
  final Function(int) onScoreChanged;
  LikertChoice({super.key, required this.onScoreChanged});

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
        ),
        ButtonSegment<int>(
          value: 2,
          label: Text("Disagree"),
        ),
        ButtonSegment<int>(
          value: 3,
          label: Text("Neutral"),
        ),
        ButtonSegment<int>(
          value: 4,
          label: Text("Agree"),
        ),
        ButtonSegment<int>(
          value: 5,
          label: Text("Strongly Agree"),
        ),
      ],
      selected: <int>{score},
      onSelectionChanged: (Set<int> newSelection) {
        setState(() {
          score = newSelection.first;
        });
        widget.onScoreChanged(newSelection.first);
      },
      showSelectedIcon: false,
    );
  }
}

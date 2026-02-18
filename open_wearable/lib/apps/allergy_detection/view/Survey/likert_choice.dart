import 'package:flutter/material.dart';

class LikertChoice extends StatefulWidget{
  final Function(int) onScoreChanged;
  final int initialScore;
  LikertChoice({super.key, required this.onScoreChanged, required this.initialScore});

  @override
  State<LikertChoice> createState() {
    return _LikertChoiceState();
  }
}

class _LikertChoiceState extends State<LikertChoice> {

  int score = 0;

  @override
  void initState() {
    super.initState();
    score = widget.initialScore;
  }

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

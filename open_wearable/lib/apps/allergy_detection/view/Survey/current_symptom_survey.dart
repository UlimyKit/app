import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CurrentSymptomsSurvey extends StatefulWidget {

  const CurrentSymptomsSurvey({super.key});

  @override
  State<CurrentSymptomsSurvey> createState() => _CurrentSymptomsSurveyState();
}

class _CurrentSymptomsSurveyState extends State<CurrentSymptomsSurvey> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("Current symptoms"),),
      body: Center(child: PlatformText("data"),),
    );
  }
}
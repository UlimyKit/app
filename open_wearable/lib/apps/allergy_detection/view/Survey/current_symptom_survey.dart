import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/likert_choice.dart';

class CurrentSymptomsSurvey extends StatefulWidget {

  const CurrentSymptomsSurvey({super.key});

  @override
  State<CurrentSymptomsSurvey> createState() => _CurrentSymptomsSurveyState();
}

class _CurrentSymptomsSurveyState extends State<CurrentSymptomsSurvey> {
  Map<String, Widget> likertWidgets = {};

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("Current symptoms"),),
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(2, 0, 2, 0),
        child: Column(
        children: [

          _buildCurrentSymptomsList(),
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(5, 20, 5, 5),
            child: ElevatedButton(onPressed: _submit_survey, child: const Text('Submit')),
          )
        ],
      ),
      )
,
    );
  }

  Widget _buildCurrentSymptomsList(){
    List<Widget> survey = [];
    //@TODO cahnge max 
    for (int i = 0; i < 5; i++){
      survey.add(Text("Symptom${i}(Description fo symptom ${i})"));
      LikertChoice symptomWidget = LikertChoice();
      survey.add(symptomWidget);
      likertWidgets["${i}"] = symptomWidget;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: survey,
    );
  }

  void _submit_survey() {
    Navigator.pushReplacementNamed(context, '/mainpage');
  }
}
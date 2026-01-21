import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/likert_choice.dart';

class SymptomFrequencySurvey extends StatefulWidget {

  const SymptomFrequencySurvey({super.key});

  @override
  State<SymptomFrequencySurvey> createState() => _SymptomFrequencySurveyState();
}

class _SymptomFrequencySurveyState extends State<SymptomFrequencySurvey> {
  
  Map<String, Widget> likertWidgets = {};

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("You experience this symptom frequently"),),
      body: Column(
        children: [
          _build_frequence_Symptoms(),
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(50, 20, 0, 5),
            child: ElevatedButton(onPressed: _submit_survey, child: const Text('Submit')),
          )
        ],
      ),

    );
  }

  Widget _build_frequence_Symptoms(){

    List<Widget> survey = [];

    for (int i = 0; i < SYMPTOM_SET.length; i++){
      survey.add(Text("${SYMPTOM_SET.elementAt(i).name}(${SYMPTOM_SET.elementAt(i).description})"));
      LikertChoice symptomWidget = LikertChoice();
      survey.add(symptomWidget);
      likertWidgets[SYMPTOM_SET.elementAt(i).name] = symptomWidget;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: survey,
    );
  }

  void _submit_survey() {

  }

}
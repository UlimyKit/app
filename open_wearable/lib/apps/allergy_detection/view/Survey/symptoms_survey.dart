import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/likert_choice.dart';


class SymptomsSurveyView extends StatefulWidget {

  const SymptomsSurveyView({super.key});

  @override
  State<SymptomsSurveyView> createState() => _SymptomsSurveyViewState();
}

class _SymptomsSurveyViewState extends State<SymptomsSurveyView> {
  

  Map<String, Widget> likertWidgets = {};

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("Symptoms Survey"),),
      body: Column(
        children: [
          _build_known_Symptoms(),
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(50, 20, 0, 5),
            child: ElevatedButton(onPressed: _submit_survey, child: const Text('Submit')),
          )
        ],
      ),

    );
  }

  Widget _build_known_Symptoms(){

    List<Widget> survey = [];

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

  }

}
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
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
      appBar: PlatformAppBar(title: PlatformText("Symptom Frequency"),),
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(2, 0, 2, 0),
        child: Column(
        children: [

          _build_frequence_Symptoms(),
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(5, 20, 5, 5),
            child: ElevatedButton(onPressed: _submit_survey, child: const Text('Submit')),
          )
        ],
      ),
      )

    );
  }

  Widget _build_frequence_Symptoms(){

    List<Widget> survey = [];
    //@TODO cahnge max 
    for (int i = 0; i < Symptoms.symptomList.length; i++){
      survey.add(Align(alignment: Alignment.centerLeft,child:Text("${Symptoms.symptomList[i].name} \n(${Symptoms.symptomList[i].description})",textAlign: TextAlign.left,)));
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
    Navigator.pushNamed(context, '/currentSymptomSurvey');
  }

}
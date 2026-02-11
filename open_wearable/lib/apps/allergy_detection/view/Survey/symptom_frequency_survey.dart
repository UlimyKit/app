import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/model/likert_scale.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/likert_choice.dart';
import 'package:provider/provider.dart';

class SymptomFrequencySurvey extends StatefulWidget {

  const SymptomFrequencySurvey({super.key});

  @override
  State<SymptomFrequencySurvey> createState() => _SymptomFrequencySurveyState();
}

class _SymptomFrequencySurveyState extends State<SymptomFrequencySurvey> {
  
  Map<Symptom, LikertScale> likertScore = {};

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
            child: ElevatedButton(onPressed: _submitSurvey, child: const Text('Submit')),
          )
        ],
      ),
      )

    );
  }

  Widget _build_frequence_Symptoms(){

    List<Widget> survey = [];
    for (Symptom symptom in Symptoms.symptomList) {
      likertScore[symptom] = LikertScale(1);
    }

    for (int i = 0; i < Symptoms.symptomList.length; i++){
      survey.add(Align(
        alignment: Alignment.centerLeft,
        child:Text("You experience ${Symptoms.symptomList[i].name} frequently\n(${Symptoms.symptomList[i].description})",
        textAlign: TextAlign.left,)));
      LikertChoice symptomWidget = LikertChoice(onScoreChanged: (score) {
        likertScore[Symptoms.symptomList[i]] = LikertScale(score); 
      },);
      survey.add(symptomWidget);
  
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: survey,
    );
  }

  void _submitSurvey() {
    Provider.of<SurveyData>(context, listen: false).setFrequenceSymptoms(likertScore);
    Navigator.pushNamed(context, '/currentSymptomSurvey');
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/model/likert_scale.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/likert_choice.dart';
import 'package:provider/provider.dart';


class SymptomsSurveyView extends StatefulWidget {

  const SymptomsSurveyView({super.key});

  @override
  State<SymptomsSurveyView> createState() => _SymptomsSurveyViewState();
}

class _SymptomsSurveyViewState extends State<SymptomsSurveyView> {
  

  Map<Symptom, LikertScale> likertScore = {};

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("Symptoms Knowledge"),),
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(2, 0, 2, 0),
        child:Column(
          children: [
            _build_known_Symptoms(),
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(5, 20, 5, 5),
              child: Center(
              child: ElevatedButton(onPressed: _submitSurvey, child: const Text('Submit')),
              ),
            ),
          ],
      ),
      )
    );

  }

  Widget _build_known_Symptoms(){
    SurveyData surveyData = Provider.of<SurveyData>(context, listen: false);
    List<Widget> survey = [];

    for (Symptom symptom in Symptoms.symptomList) {
      likertScore[symptom] = LikertScale(1);
    }

    for (int i = 0; i < Symptoms.symptomList.length; i++){
      survey.add(
        Align(alignment: Alignment.centerLeft,
        child:Text("You know the symptom ${Symptoms.symptomList[i].name} well\n(${Symptoms.symptomList[i].description})",
        textAlign: TextAlign.left,)));
      LikertChoice symptomWidget = LikertChoice(onScoreChanged: (score) {
        likertScore[Symptoms.symptomList[i]] = LikertScale(score); 
      },initialScore: surveyData.knownSymptoms[Symptoms.symptomList[i]]!.value,);
      survey.add(symptomWidget);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: survey,
    );
  }

  void _submitSurvey() {
    Provider.of<SurveyData>(context, listen: false).setKnownSymptoms(likertScore);
    Navigator.pushNamed(context, '/symptomFrequencySurvey');
  }
}

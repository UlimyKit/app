import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/model/likert_scale.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/likert_choice.dart';
import 'package:provider/provider.dart';

class CurrentSymptomsSurvey extends StatefulWidget {

  const CurrentSymptomsSurvey({super.key});

  @override
  State<CurrentSymptomsSurvey> createState() => _CurrentSymptomsSurveyState();
}

class _CurrentSymptomsSurveyState extends State<CurrentSymptomsSurvey> {
  Map<Symptom, LikertScale> likertScore = {};

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

    for (int i = 0; i < Symptoms.symptomList.length; i++){
      survey.add(
        Align(alignment: Alignment.centerLeft,
        child:Text("You recently experienced ${Symptoms.symptomList[i].name} \n(${Symptoms.symptomList[i].description})",
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

  void _submit_survey() {
    Provider.of<SurveyData>(context, listen: false).setCurrentSymptoms(likertScore);
    Provider.of<SurveyData>(context, listen: false).saveData();
    Navigator.pushNamedAndRemoveUntil(context, '/mainpage', (route) => false);
  }
}
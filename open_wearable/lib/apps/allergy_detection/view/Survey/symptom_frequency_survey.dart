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
      appBar: PlatformAppBar(
        title: PlatformText("Current symptoms"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          children: [
            Expanded(child: _buildCurrentSymptomsList()),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Center(
                child: ElevatedButton(
                  onPressed: _submitSurvey,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6, 
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    foregroundColor: Colors.white, 
                    backgroundColor: Colors.blueAccent, 
                  ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white, // font color
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildCurrentSymptomsList() {
    List<Widget> survey = [];

    final surveyData = Provider.of<SurveyData>(context, listen: false);

    for (Symptom symptom in Symptoms.symptomList) {
      likertScore[symptom] ??= LikertScale(1);

      survey.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Text(
            "You recently experienced ${symptom.name}\n(${symptom.description})",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );

      survey.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: LikertChoice(
            initialScore: surveyData.frequenceSymptoms[symptom]?.value ?? 1,
            onScoreChanged: (score) {
              likertScore[symptom] = LikertScale(score);
            },
          ),
        ),
      );
    }

    return ListView(
      children: survey,
    );
  }

  void _submitSurvey() {
    Provider.of<SurveyData>(context, listen: false).addFrequenceSymptoms(likertScore);
    Navigator.pushNamed(context, '/currentSymptomSurvey');
  }

}

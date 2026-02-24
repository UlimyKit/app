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
      appBar: PlatformAppBar(
        title: PlatformText("Known symptoms"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          children: [
            Text(
              "Please complete the following survey to help us understand your current symptomes.",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5), 
            const Divider(
              color: Colors.grey,      
              thickness: 1,            
              height: 1,               
            ),
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
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(
                  text: "You know of the symptom ",
                ),
                TextSpan(
                  text: "${symptom.name}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ".\n(${symptom.description})",
                ),
              ],
            ),
          ),
        ),
      );

      survey.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: LikertChoice(
            initialScore: surveyData.knownSymptoms[symptom]?.value ?? 1,
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
    Provider.of<SurveyData>(context, listen: false).addKnownSymptoms(likertScore);
    Navigator.pushNamed(context, '/symptomFrequencySurvey');
  }
}

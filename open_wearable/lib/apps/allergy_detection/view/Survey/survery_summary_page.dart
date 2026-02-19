import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:provider/provider.dart';

class SurveySummaryPage extends StatefulWidget {

  const SurveySummaryPage({super.key});

  @override
  State<SurveySummaryPage> createState() => _SurveySummaryPageState();
}

class _SurveySummaryPageState extends State<SurveySummaryPage> {

  @override
  Widget build(BuildContext context) {
    final survey = context.watch<SurveyData>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Please review your answers below:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Divider(),

            // User Info
            _buildSectionTitle("User Info"),
            Text("User ID: ${survey.userId}"),
            Text("Age: ${survey.age}"),
            Text("Gender: ${survey.gender.toString().split('.').last}"),
            const SizedBox(height: 12),

            // Allergies
            _buildSectionTitle("Allergies"),
            if (survey.allergies.isNotEmpty)
              Text(survey.allergies.join(", "))
            else
              const Text("No allergies specified."),
            const SizedBox(height: 12),

            // Known Symptoms
            _buildSectionTitle("Known Symptoms"),
            if (survey.knownSymptoms.isNotEmpty)
              ...survey.knownSymptoms.entries.map(
                (e) => Text("${e.key.name}: ${e.value.value}"),
              )
            else
              const Text("No known symptoms."),

            const SizedBox(height: 12),

            // Frequence Symptoms
            _buildSectionTitle("Frequency of Symptoms"),
            if (survey.frequenceSymptoms.isNotEmpty)
              ...survey.frequenceSymptoms.entries.map(
                (e) => Text("${e.key.name}: ${e.value.value}"),
              )
            else
              const Text("No data provided."),

            const SizedBox(height: 12),

            // Current Symptoms
            _buildSectionTitle("Current Symptoms"),
            if (survey.currentSymptoms.isNotEmpty)
              ...survey.currentSymptoms.entries.map(
                (e) => Text("${e.key.name}: ${e.value.value}"),
              )
            else
              const Text("No current symptoms."),

            const SizedBox(height: 24),

            // Confirm Button
            ElevatedButton(
              onPressed: () async {
                await survey.saveData(); // save to storage
                _submitSurvey(); // go back or close
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _submitSurvey() {
    Navigator.pushNamedAndRemoveUntil(context, '/mainpage', (route) => false);
  }
}

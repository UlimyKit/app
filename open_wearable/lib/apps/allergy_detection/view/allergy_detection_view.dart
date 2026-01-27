import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/login_view.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/symptom_frequency_survey.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/symptoms_survey.dart';

class AllergyDetectionView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlatformScaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: () =>{context.go("/login")}, child: const Text("Continue"))
          ],
        ),
      ),
      routes: {
        '/login': (context) => LoginView(),
        '/symptomKnowledgeSurvey': (context) => SymptomsSurveyView(),
        '/symptomFrequencySurvey': (context) => SymptomFrequencySurvey(),
      },
    );
  }
}

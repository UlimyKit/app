import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/main_page.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/current_symptom_survey.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/demographics_survey.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/login_view.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/symptom_frequency_survey.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/symptoms_survey.dart';

class AllergyDetectionView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginView(),
        '/demographicsSurvey': (context) => DemographicSurveyView(), 
        '/symptomKnowledgeSurvey': (context) => SymptomsSurveyView(),
        '/symptomFrequencySurvey': (context) => SymptomFrequencySurvey(),
        '/currentSymptomSurvey': (context) => CurrentSymptomsSurvey(),
        '/mainpage': (context) => MainPage(),
      },
    );
  }
}

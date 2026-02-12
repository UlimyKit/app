import 'package:flutter/material.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/main_page.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/current_symptom_survey.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/demographics_survey.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/login_view.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/symptom_frequency_survey.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/symptoms_survey.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';
import 'package:provider/provider.dart';

class AllergyDetectionView extends StatelessWidget {
  
  final Wearable leftWearable;
  final Wearable rightWearable;
  final SensorConfigurationProvider leftSensorConfigurationProvider;
  final SensorConfigurationProvider rightSensorConfigurationProvider;
  

  const AllergyDetectionView({super.key,
   required this.leftWearable,
    required this.leftSensorConfigurationProvider,
    required this.rightWearable,
    required this.rightSensorConfigurationProvider});

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider(
      create: (_) => SurveyData(),
      child: MaterialApp(
        routes: {
          '/': (context) => LoginView(),
          '/demographicsSurvey': (context) => DemographicSurveyView(), 
          '/symptomKnowledgeSurvey': (context) => SymptomsSurveyView(),
          '/symptomFrequencySurvey': (context) => SymptomFrequencySurvey(),
          '/currentSymptomSurvey': (context) => CurrentSymptomsSurvey(),
          '/mainpage': (context) => MainPage(
            leftWearable: leftWearable,
            leftSensorConfigurationProvider: leftSensorConfigurationProvider,
            rightWearable: rightWearable,
            rightSensorConfigurationProvider: rightSensorConfigurationProvider,
            ),
        },
    ));
  }
}

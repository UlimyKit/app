import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';
import 'package:open_wearable/apps/allergy_detection/view/Survey/likert_choice.dart';


class SymptomsSurveyView extends StatefulWidget {

  const SymptomsSurveyView({super.key});

  @override
  State<SymptomsSurveyView> createState() => _SymptomsSurveyViewState();
}

class _SymptomsSurveyViewState extends State<SymptomsSurveyView> {
  
  List<Symptom> symptoms = [
    Symptom(
      name: "Itchy eyes",
      description: "Eyes feel irritated, watery or itchy.",
      reactions: [
        "Rubbing eyes",
      ],
    ),
    Symptom(
      name: "Globus sensation",
      description:
          "A feeling of a lump, tightness, or something stuck in the throat.",
      reactions: [
        "Urge to swallow",
      ],
    ),
    Symptom(
      name: "Itchy palate",
      description: "Tickling/itching sensation on the roof of your mouth.",
      reactions: [
        "Coughing",
        "Throat clearing",
        "Tongue rubbing in the throat",
        "Saliva pumping in the throat",
      ],
    ),
    Symptom(
      name: "Itchy ears",
      description: "Itching sensation on or inside the ears.",
      reactions: [
        "Rubbing the ears",
      ],
    ),
    Symptom(
      name: "Running nose",
      description: "A nose that keeps dripping or feels wet.",
      reactions: [
        "Sniffing",
      ],
    ),
  ];

  Map<String, Widget> likertWidgets = {};

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("Symptoms Survey"),),

    );
  }

  Widget _build_known_Symptoms(){

    List<Widget> survey = [];

    for (int i = 0; i < symptoms.length; i++){
      survey.add(Text("${symptoms[i].name}(${symptoms[i].description})"));
      LikertChoice symptomWidget = LikertChoice();
      survey.add(symptomWidget);
      likertWidgets[symptoms[i].name] = symptomWidget;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        LikertChoice()
      ],
    );
  }

}
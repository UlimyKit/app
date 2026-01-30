import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/model/allergy.dart';
import 'package:open_wearable/apps/allergy_detection/model/gender.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:provider/provider.dart';



class DemographicSurveyView extends StatefulWidget {

  const DemographicSurveyView({super.key});

  @override
  State<DemographicSurveyView> createState() => _DemographicSurveyViewState();
}

class _DemographicSurveyViewState extends State<DemographicSurveyView> {
  TextEditingController ageInputController = TextEditingController();
  TextEditingController allergyInputController = TextEditingController();

  int age = -1;
  Gender? genderChoice = Gender.other;
  

  List<Allergy> hayFeverAllergies = [
  Allergy(name: "Ambrosia (Ragweed)"),
  Allergy(name: "Beifuß (Mugwort)"),
  Allergy(name: "Birke (Birch)"),
  Allergy(name: "Erle (Alder)"),
  Allergy(name: "Esche (Ash)"),
  Allergy(name: "Gräser (Grass pollen)"),
  Allergy(name: "Hasel (Hazel)"),
  Allergy(name: "Roggen (Rye pollen)"),
  ];

  Widget build(BuildContext context){
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("Fill out the Survey"),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How old are you?",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please enter your age in years",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: ageInputController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {
                      age = int.parse(value);
                    }),
                    decoration: InputDecoration(
                      labelText: "Age",
                      suffixText: "years",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: RadioGroup<Gender>(
              groupValue: genderChoice,
              onChanged: (Gender? value) {
                setState(() {
                  genderChoice = value;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What is your gender?",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 12),
                    RadioListTile<Gender>(
                      title: Text("Male"),
                      value: Gender.male,
                    ),
                    RadioListTile<Gender>(
                      title: Text("Female"),
                      value: Gender.female,
                    ),
                    RadioListTile<Gender>(
                      title: Text("Non-binary / Other"),
                      value: Gender.other,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Which pollens trigger your hay fever?",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12),
                  ...hayFeverAllergies.map((allergy) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(allergy.name),
                      value: allergy.selected,
                      onChanged: (value) {
                        setState(() {
                          allergy.selected = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                  SizedBox(height: 8),
                  TextField(
                    controller: allergyInputController,
                    decoration: InputDecoration(
                      labelText: "Other / Not sure",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10),
          child: ElevatedButton(onPressed: _isFilledOut()?_continueButtonPressed:null, child: const Text("Continue")),)
        ],
        
      ),
      )
    );
  }

  void _continueButtonPressed(){

    Provider.of<SurveyData>(context, listen: false).setAge(age);
    List<String> allergies = [];

    for (Allergy allergy in hayFeverAllergies) {
      //iterate through the allergies to check which is selected and add them to SurveyData
      if (allergy.selected) {
        allergies.add(allergy.name);
      }
    }
    if (allergyInputController.text != "") {
      //trim "other" allergies and add them to the list
      allergies.addAll(allergyInputController.text.split(',').map((s) => s.trim()).toList());
    }

    // change to next surveyPage
    Navigator.pushNamed(context, '/symptomKnowledgeSurvey');

  }

  bool _isFilledOut(){
    return age > 0;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

enum Gender {
  male,
  female,
  other,
}

class DemographicSurveyView extends StatefulWidget {

  const DemographicSurveyView({super.key});

  @override
  State<DemographicSurveyView> createState() => _DemographicSurveyViewState();
}

class _DemographicSurveyViewState extends State<DemographicSurveyView> {
  TextEditingController ageInputController = TextEditingController();
  TextEditingController allergyInputController = TextEditingController();


  Gender? genderChoice = Gender.other;


  Widget build(BuildContext context){
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("Fill out the Survey"),),
      body: Column(
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                PlatformText("Enter your Age"),
                TextField(
                  controller: ageInputController,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                            border: OutlineInputBorder(),
                            labelText: 'age',
                            filled: true,
                            labelStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,),
                        keyboardType: TextInputType.number,
                ),
                Spacer(),
                RadioGroup<Gender>(
                  groupValue: genderChoice,
                  onChanged: (Gender? value) {
                    setState(() {
                      genderChoice = value;
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      ListTile(
                        title: PlatformText("male"),
                        leading: Radio<Gender>(value: Gender.male),
                      ),
                      ListTile(
                        title: PlatformText("female"),
                        leading: Radio<Gender>(value: Gender.female),
                      ),
                      ListTile(
                        title: PlatformText("other"),
                        leading: Radio<Gender>(value: Gender.other),
                      ),
                    ],
                  ),
                  ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                PlatformText("enter your allergies"),
                PlatformListTile(title: PlatformText("Allergy A"),
                leading: Radio<bool>(value: false),
                ),
                PlatformListTile(title: PlatformText("Allergy b"),
                leading: Radio<bool>(value: false),
                ),
                TextField(
                  controller: allergyInputController,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                            border: OutlineInputBorder(),
                            labelText: 'allergies',
                            filled: true,
                            labelStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,),
                        keyboardType: TextInputType.number,
                ),
              ]
             ,),),
          Padding(padding: EdgeInsetsGeometry.fromLTRB(50, 10, 5, 10),
          child: ElevatedButton(onPressed: _submit, child: const Text("Continue")),)
        ],
        
      ),
    );
  }

  void _submit(){

  }
}

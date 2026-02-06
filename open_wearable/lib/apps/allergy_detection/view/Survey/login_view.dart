import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget{
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  String userId = "";

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText("Enter your ID"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // shrink column to content
            crossAxisAlignment: CrossAxisAlignment.stretch, // buttons fill width
            children: [
              SizedBox(
                height: 16,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "User ID",
                  
                ),
                onChanged: (value) => setState(() {
                  userId = value.trim();
                }),
              ),
              
              SizedBox(height: 16),
              Consumer<SurveyData>(
                builder: (context, surveyData, child) {return ElevatedButton(
                onPressed: userId.isNotEmpty ? _continueButtonPressed : null,
                child: PlatformText("Continue"),
              );})
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continueButtonPressed() async{
    
    final surveyData = context.read<SurveyData>();

    final exists = await surveyData.loadOrCreate(userId);


    if (exists) {
    // User already exists → resume
    Navigator.pushNamed(context, '/currentSymptomSurvey');
    } else {
    // New user → start survey
    Navigator.pushNamed(context, '/demographicsSurvey');
    }
  }


}

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget{
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText("Enter your ID"),
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
              ),
              SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: _submit_id,
                child: PlatformText("Submit"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _continueButtonPressed,
                child: PlatformText("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit_id(){
    
  }

  void _continueButtonPressed(){
    Navigator.pushReplacementNamed(context, '/demographicsSurvey');
  }
}

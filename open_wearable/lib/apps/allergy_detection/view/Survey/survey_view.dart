import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SurveyView extends StatefulWidget{
  SurveyView({super.key});

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: PlatformText("Enter your ID"),),
      body: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          SizedBox(
            width: 250,
            child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder(), labelText: "User ID"),
        ),
          ),
          FilledButton.tonal(onPressed: _submit_id, child: PlatformText("Submit")),
        ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 5, 0),
            child: ElevatedButton(onPressed: _continue_button_pressed, child: const Text("Continue")),
          ),
        ],
      ),
    );
  }

  void _submit_id(){
    
  }

  void _continue_button_pressed(){

  }
}

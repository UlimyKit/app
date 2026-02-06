import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/controller/recording_handler.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/recording.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';
import 'package:provider/provider.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  var stopwatch = Stopwatch();
  

  @override
  Widget build(BuildContext context) {
    var detectedSymptoms = context.watch<RecordingHandler>().getDetectedSymptoms();
    var recording = context.watch<RecordingHandler>().isRecording();

    return Scaffold(
      appBar: AppBar(title: Text("SessionPage"),),
      body: Column(
        children: [
          Expanded(
            child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
              child: ClipRRect(borderRadius: BorderRadiusGeometry.circular(16),
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
              child: ListView.builder(
                itemCount: detectedSymptoms.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text("${detectedSymptoms[index].symptom.name} at ${detectedSymptoms[index].detectionTime.format(context)}"),
                    trailing: OverflowBar(
                      overflowAlignment: OverflowBarAlignment.end,
                      spacing: 5,
                      children: <Widget>[
                        ElevatedButton(onPressed: () => recording?_symptomConfirmButton(index):null, child: Icon(Icons.check)),               
                        ElevatedButton(onPressed: () => recording?_symptomEditButton(index):null, child: Icon(Icons.edit)),
                        ElevatedButton(onPressed: () => recording?_symptomWrongButton(index):null, child: Icon(Icons.close)),
                      ],
                    ),
                  );
                },
              ),
            ),),),),
          Padding(padding: EdgeInsetsGeometry.fromLTRB(5, 20, 5, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: <Widget>[
              ElevatedButton(onPressed: _pressedPlayButton, child: recording?Icon(Icons.pause):Icon(Icons.play_arrow)),
              ElevatedButton(onPressed: recording?_pressedAddNewSymptomButton:null, child: Icon(Icons.add))
            ],
          ))
        ],
    
      ),
    );
  }

  void _symptomConfirmButton(int index){
    context.read<RecordingHandler>().confirmSymptom(index);
  }

  void _symptomEditButton(int index) {
    _showEditSymptomDialog(index);
    
  }

  void _symptomWrongButton(int index) {
    context.read<RecordingHandler>().deleteDetectedSymptom(index);
    
  }

  void addSymptom(Symptom symptom, TimeOfDay detectionTime) {
    context.read<RecordingHandler>().addDetectedSymptom(DetectedSymptom(symptom: symptom, detectionTime: detectionTime));
  }

  void _stopRecordingSession(){
    context.read<RecordingHandler>().stopRecording();
  }

  void _startRecordingSession(){
    context.read<RecordingHandler>().startRecording();
  }

  void _pressedPlayButton(){
    if (!context.read<RecordingHandler>().isRecording()){
      _startRecordingSession();
    } else {
      _stopRecordingSession();
    }
  }

  void editDetectedSymptom(Symptom symptom, int index) {
    context.read<RecordingHandler>().editDetectedSymptom(symptom, index);
  }

  void _pressedAddNewSymptomButton(){
    _showAddSymptomDialog();
  }

  Future<void> _showEditSymptomDialog(int index) async{
    Symptom? selectedSymptom;

    await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder( // allows setState inside the dialog
        builder: (context,setStateDialog) {
          return AlertDialog(
            title: Text('Edit Symptom'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Symptom name input
                Autocomplete<Symptom>(
                  optionsBuilder: (TextEditingValue value) {
                    if (value.text.isEmpty) {
                      return Symptoms.symptomList;
                    }
                    return Symptoms.symptomList.where((symptom)=>
                    symptom.name.toLowerCase().contains(value.text.toLowerCase()));
                  },
                  displayStringForOption: (Symptom s) => s.name,
                  onSelected: (Symptom selection) {
                    selectedSymptom = selection;
                  },
                  fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Symptom',
                          border: OutlineInputBorder(),
                        ),
                        onEditingComplete: () {
                          // prevent invalid text
                          final match = Symptoms.symptomList.any(
                              (s) => s.name == controller.text);
                          if (!match) {
                            controller.clear();
                            selectedSymptom = null;
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // cancel
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedSymptom != null) {
                    editDetectedSymptom(selectedSymptom!, index);
                    
                    Navigator.pop(context); // close dialog
                  }
                },
                child: Text('Edit'),
              ),
            ],
          );
        },
      );
    },
  );
    
  }

  Future<void> _showAddSymptomDialog() async {
  Symptom? selectedSymptom;
  TimeOfDay? selectedTime = TimeOfDay.now();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder( // allows setState inside the dialog
        builder: (context,setStateDialog) {
          return AlertDialog(
            title: Text('Add Symptom'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Symptom name input
                Autocomplete<Symptom>(
                  optionsBuilder: (TextEditingValue value) {
                    if (value.text.isEmpty) {
                      return Symptoms.symptomList;

                    }
                    return Symptoms.symptomList.where((symptom)=>
                    symptom.name.toLowerCase().contains(value.text.toLowerCase()));
                  },
                  displayStringForOption: (Symptom s) => s.name,
                  onSelected: (Symptom selection) {
                    selectedSymptom = selection;
                  },
                  fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Symptom',
                          border: OutlineInputBorder(),
                        ),
                        onEditingComplete: () {
                          // prevent invalid text
                          final match = Symptoms.symptomList.any(
                              (s) => s.name == controller.text);
                          if (!match) {
                            controller.clear();
                            selectedSymptom = null;
                          }
                        },
                      );
                    },
                  ),
                SizedBox(height: 16),

                // Time picker
                Row(
                  children: [
                    Text(
                      selectedTime != null
                          ? 'Time: ${selectedTime!.format(context)}'
                          : 'Select Time',
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.dial,
                        );
                        if (picked != null) {
                          setStateDialog(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: Text('Pick Time'),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // cancel
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedSymptom !=null && selectedTime != null) {
                    
                    addSymptom(selectedSymptom!, selectedTime!);
                    
                    Navigator.pop(context); // close dialog
                  }
                },
                child: Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
  }
}

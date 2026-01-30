import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/record.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';
import 'package:provider/provider.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  List<DetectedSymptom> detectedSymptoms = <DetectedSymptom>[DetectedSymptom(symptom: Symptoms.symptomList[0], detectionTime: TimeOfDay.now())];
  bool recording = false;
  var stopwatch = Stopwatch();
  Recording? record;

  @override
  Widget build(BuildContext context) {
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
                        ElevatedButton(onPressed: () => recording?_symptomAddButton(index):null, child: Icon(Icons.check)),               
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

  void _symptomAddButton(int index){
    print("Symptom ${detectedSymptoms[index]} was detected correctly");
    record!.addDetectedSymptom(detectedSymptoms[index]);
    setState(() {
      detectedSymptoms.removeAt(index);
    });
    
  }

  void _symptomEditButton(int index) {
    print("Symptom ${detectedSymptoms[index]} was edited");
    _showEditSymptomDialog(index);
    
  }

  void _symptomWrongButton(int index) {
    print("Symptom ${detectedSymptoms[index]} was detected incorrectly");
    setState(() {
      detectedSymptoms.removeAt(index);
    });
    
  }

  void addSymptom(Symptom symptom, TimeOfDay detectionTime) {
    setState(() {
      detectedSymptoms.add(DetectedSymptom(symptom: symptom, detectionTime: detectionTime));
    });
  }

  void _saveRecord(){
    print("saving Record");
  }

  void _stopRecordingSession(){
    record!.stopRecording();
      _saveRecord();

      setState(() {
        detectedSymptoms = [];
      });
  }

  void _startRecordingSession(){
    record = Recording(userId:Provider.of<SurveyData>(context, listen: false).userId);
  }

  void _pressedPlayButton(){
    print("PlayButton pressed");
    
    if (!recording){
      _startRecordingSession();
    } else {
      _stopRecordingSession();
    }

    setState(() {
      recording = !recording;
    });
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
                    setState(() {
                      detectedSymptoms[index] = DetectedSymptom(symptom: selectedSymptom!, detectionTime: detectedSymptoms[index].detectionTime);
                    });
                    
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

  Future<void> _showAddSymptomDialog() async {
  Symptom? selectedSymptom;
  TimeOfDay? selectedTime;

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

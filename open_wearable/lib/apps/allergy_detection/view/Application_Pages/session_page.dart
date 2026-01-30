import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  List<DetectedSymptom> detectedSymptoms = <DetectedSymptom>[DetectedSymptom(symptom: Symptoms.symptomList[0], detectionTime: TimeOfDay.now())];
  bool recording = false;
  var stopwatch = Stopwatch();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SessionPage"),),
      body: Column(
        children: [
          Expanded(
            child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
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
                        ElevatedButton(onPressed: () => _symptomAddButton(index), child: Icon(Icons.check)),               
                        ElevatedButton(onPressed: () => _symptomEditButton(index), child: Icon(Icons.edit)),
                        ElevatedButton(onPressed: () => _symptomWrongButton(index), child: Icon(Icons.close)),
                      ],
                    ),
                  );
                },
              ),
            ),),),),
          Padding(padding: EdgeInsetsGeometry.fromLTRB(5, 20, 5, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(onPressed: _pressedPlayButton, child: recording?Icon(Icons.play_arrow):Icon(Icons.pause)),
              ElevatedButton(onPressed: _pressedAddNewSymptomButton, child: Icon(Icons.add))
            ],
          ))
        ],
    
      ),
    );
  }

  void _symptomAddButton(int index){
    //TODO change 
    print("Symptom ${detectedSymptoms[index]} was detected correctly");
    setState(() {
      detectedSymptoms.removeAt(index);
    });
    
  }

  void _symptomEditButton(int index) {
    print("Symptom ${detectedSymptoms[index]} was edited");

    setState(() {
      
    });
    
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

  void _pressedPlayButton(){
    print("PlayButton pressed");
    setState(() {
      recording = !recording;
    });
  }

  void _pressedAddNewSymptomButton(){
    _showAddSymptomDialog();
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
                          initialEntryMode: TimePickerEntryMode.inputOnly,
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
                    // Add the symptom with time to your list
                    setState(() {
                      detectedSymptoms.add(
                          DetectedSymptom(symptom: selectedSymptom!, detectionTime: selectedTime!));
                      print(detectedSymptoms);
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
}

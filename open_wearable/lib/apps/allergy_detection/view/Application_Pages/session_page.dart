import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/controller/recording_handler.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
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
    List<DetectedSymptom> detectedSymptoms = context.watch<RecordingHandler>().getDetectedSymptoms();
    List<DetectedSymptom> symptomNotifications = context.watch<RecordingHandler>().getSymptomNotifications();
    bool recording = context.watch<RecordingHandler>().isRecording();
    return Scaffold(
      appBar: AppBar(title: Text("Session ${context.watch<RecordingHandler>().currentRecording !=null?context.watch<RecordingHandler>().currentRecording!.sessionId : "Paused"}"),),
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
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: detectedSymptoms.length,
                            itemBuilder: (BuildContext context, int index) {
                              var reverseIndex = detectedSymptoms.length - 1 - index;
                                return ListTile(
                                  title: Text("${detectedSymptoms[reverseIndex].humanLabel.name} at ${TimeOfDay.fromDateTime(detectedSymptoms[reverseIndex].detectionEndTime).format(context)}"),
                                  trailing: OverflowBar(
                                    overflowAlignment: OverflowBarAlignment.end,
                                    spacing: 5,
                                    children: <Widget>[               
                                      ElevatedButton(onPressed: () => recording?_symptomEditButton(reverseIndex):null, child: Icon(Icons.edit)),
                                    ],
                                  ),
                                );
                             },
                          ),
                          if (symptomNotifications.isNotEmpty)
                          ListView.builder(
                            itemCount: symptomNotifications.length,
                            
                            itemBuilder: (context, index) {
                              final symptom = symptomNotifications[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                child: Container(
                                  width: double.infinity, 
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        symptom.detectionStartTime == null? 
                                        "${symptom.humanLabel.name} at ${TimeOfDay.fromDateTime(symptom.detectionEndTime).format(context)}" 
                                        : "${symptom.humanLabel.name} between ${TimeOfDay.fromDateTime(symptom.detectionStartTime!).format(context)} and ${TimeOfDay.fromDateTime(symptom.detectionEndTime).format(context)}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4), 
                                      
                                      Text(
                                        symptom.humanLabel.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey, 
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => context.read<RecordingHandler>().confirmSymptomNotification(index),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                            child: const Text("Confirm"),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () => _showEditSymptomDialog(context.read<RecordingHandler>().editAndConfirmNotifiedSymptom,index),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.yellow,
                                            ),
                                            child: const Text("Edit"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },)
                        ],
                      ),
                  ),
                ),
              ),
          ),
          Padding(padding: EdgeInsetsGeometry.fromLTRB(5, 20, 5, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _pressedPlayButton,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: recording
                      ? const Icon(Icons.pause, size: 32)
                      : const Icon(Icons.play_arrow, size: 32),
                ),
                const SizedBox(width: 16), // space between buttons
                ElevatedButton(
                  onPressed: recording ? _pressedAddNewSymptomButton : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.add, size: 32),
                ),
                ElevatedButton(onPressed: () => context.read<RecordingHandler>().addSymptomNotification(DetectedSymptom(humanLabel: Symptoms.symptomList[0],detectionEndTime: DateTime.now())), child: Icon(Icons.ac_unit)),
              ],
            )
          )
        ],
    
      ),
    );
  }

  void _symptomEditButton(int index) {
    _showEditSymptomDialog(editDetectedSymptom,index);
    
  }

  void addSymptomHuman(Symptom symptom, DateTime detectionTime) {
    context.read<RecordingHandler>().addDetectedSymptom(DetectedSymptom(humanLabel: symptom, detectionEndTime: detectionTime));
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

  Future<void> _showEditSymptomDialog(Function(Symptom s, int i) editSymptomFunction,int index) async{
    Symptom? selectedSymptom;

    await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder( 
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
                              (s) => s.name == controller.text,);
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
                    editSymptomFunction(selectedSymptom!, index);
                    
                    Navigator.pop(context); // close dialog
                  }
                },
                child: Text('Confirm'),
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
  DateTime selectedTime = DateTime.now();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context,setStateDialog) {
          return AlertDialog(
            title: Text("Add Symptom"),
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
                          labelText: "Symptom",
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
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // cancel
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedSymptom !=null ) {
                    
                    addSymptomHuman(selectedSymptom!, selectedTime);
                    
                    Navigator.pop(context); // close dialog
                  }
                },
                child: Text("Add"),
              ),
            ],
          );
        },
      );
    },
  );
  }
}

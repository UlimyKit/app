import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  List<String> detectedSymptoms = <String>["Example_symptom"];
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
                    leading: Icon(Icons.loupe),
                    title: Text(detectedSymptoms[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
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
      detectedSymptoms.removeAt(index);
    });
    
  }

  void _symptomWrongButton(int index) {
    print("Symptom ${detectedSymptoms[index]} was detected incorrectly");
    setState(() {
      detectedSymptoms.removeAt(index);
    });
    
  }

  void addSymptom(String name) {
    setState(() {
      detectedSymptoms.add(name);
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
  String symptomName = '';
  TimeOfDay? selectedTime;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder( // allows setState inside the dialog
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Add Symptom'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Symptom name input
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Symptom Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    symptomName = value;
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
                        );
                        if (picked != null) {
                          setState(() {
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
                  if (symptomName.isNotEmpty && selectedTime != null) {
                    // Add the symptom with time to your list
                    setState(() {
                      detectedSymptoms.add(
                          '$symptomName at ${selectedTime!.format(context)}');
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

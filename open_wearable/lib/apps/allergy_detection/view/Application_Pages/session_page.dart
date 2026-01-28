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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SessionPage"),),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: detectedSymptoms.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.loupe),
                  title: Text(detectedSymptoms[index]),
                  trailing: Row(
                    children: <Widget>[
                      ElevatedButton(onPressed: () => _symptomAddButton(index), child: Icon(Icons.check)),
                      ElevatedButton(onPressed: () => _symptomEditButton(index), child: Icon(Icons.edit)),
                      ElevatedButton(onPressed: () => _symptomWrongButton(index), child: Icon(Icons.close)),
                    ],
                  ),
                );
              }
            ),
          ),
          Row(
            children: [
              ElevatedButton(onPressed: _pressedPlayButton, child: recording?Icon(Icons.play_arrow):Icon(Icons.pause))
            ],
          )
        ],
    
      ),
    );
  }

  void _symptomAddButton(int index){
    //TODO change 
    print("Symptom ${detectedSymptoms[index]} was detected correctly");
    detectedSymptoms.removeAt(index);
  }

  void _symptomEditButton(int index) {
    print("Symptom ${detectedSymptoms[index]} was edited");
    detectedSymptoms.removeAt(index);
  }

  void _symptomWrongButton(int index) {
    print("Symptom ${detectedSymptoms[index]} was detected incorrectly");
    detectedSymptoms.removeAt(index);
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
}

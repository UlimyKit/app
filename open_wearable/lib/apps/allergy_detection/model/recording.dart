
import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/data/symptom_recording_storage.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

class Recording {
  late String sessionId;
  final String userId;
  late DateTime startingTime;
  DateTime? endingTime;
  List<DetectedSymptom> _detectedSymptoms = [];

  Recording({required this.userId}){
    startingTime = DateTime.now().toUtc();
    sessionId = "$userId@${startingTime.toUtc().toIso8601String()}";
  }
  void addDetectedSymptom(DetectedSymptom? detectedSymptom){
    if (detectedSymptom != null){
    _detectedSymptoms.add(detectedSymptom);
    }
  }

  void stopRecording(){
    endingTime = DateTime.now();
  }

  List<DetectedSymptom> getDetectedSymptoms(){
    return _detectedSymptoms;
  }

  String toCsv(){
    String sessionBlock = "";
    for (DetectedSymptom symptom in _detectedSymptoms) {
      // userId|sessionID|machinelabel(optional)|humanLabel|Startofsymptomdetection(optional)|EndofSymptomDetection
      sessionBlock = "$userId,$sessionBlock$sessionId,${(symptom.machineLabel == null)? "-" : symptom.machineLabel!.name},${symptom.humanLabel.name},${symptom.detectionStartTime?.toUtc().toIso8601String() ?? "-"},${symptom.detectionEndTime.toUtc().toIso8601String()}\n";
    }
    return sessionBlock;
  }

  String timeOfDaytoString(DateTime time){
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void fromString(String csvString){
    
    if (csvString == ""){
      return;
    }

    for(String detectedSymtpomLine in csvString.split("\n")) {
      List<String> lineElements = detectedSymtpomLine.split(",");
      Symptom? machineLabel = lineElements[2] == "-"? null : SymptomParsing.symptomFromName(lineElements[2]);
      Symptom? humanLabel = SymptomParsing.symptomFromName(lineElements[3]);

      if (humanLabel == null) {
        throw FormatException("humanlabel cannot be null");
      }

      DateTime? detectionStartTime = lineElements[4] == "-" ? null : DateTime.tryParse(lineElements[4]);
      DateTime? detectionEndTime = DateTime.parse(lineElements[5]);

      _detectedSymptoms.add(DetectedSymptom(humanLabel: humanLabel, detectionEndTime: detectionEndTime!, machineLabel: machineLabel, detectionStartTime: detectionStartTime));
    }
  }

  void saveRecording(){
    RecordingCsvStorage.appendRecording(this);
  }
}

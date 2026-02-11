
import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/data/symptom_recording_storage.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

class Recording {
  final String userId;
  DateTime startingTime;
  DateTime? endingTime;
  List<DetectedSymptom> _detectedSymptoms = [];

  Recording({required this.userId}): startingTime = DateTime.now();

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

  String toCsvRow(){
    String detectedSymptoms = _detectedSymptoms.map((s) => "${s.symptom.name}@${timeOfDaytoString(s.detectionTime)}").join('|');

    return "$startingTime,$detectedSymptoms";
  }

  String timeOfDaytoString(TimeOfDay time){
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void fromString(String csvString){
    startingTime = DateTime.parse(csvString.split(',')[0]);
    _detectedSymptoms = csvString.split(',')[1].split('|').map((entry) {
    final parts = entry.split('@');
    return DetectedSymptom(
      symptom: SymptomParsing.symptomFromName(parts[0])!,
      detectionTime: timeOfDayfromString(parts[1]),
    );
  }).toList();
  }

  TimeOfDay timeOfDayfromString(String time){
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  void saveRecording(){
    RecordingCsvStorage.appendRecording(this);
  }
}

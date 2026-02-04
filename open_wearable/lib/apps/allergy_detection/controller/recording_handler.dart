

import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/recording.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

class RecordingHandler extends ChangeNotifier{
  bool _recording = false;
  Recording? currentRecording;
  String userId;
  List<DetectedSymptom> _currentlyDetectedSymptoms = [];


  RecordingHandler({required this.userId});

  List<DetectedSymptom> getDetectedSymptoms() {
    return _currentlyDetectedSymptoms;
  }

  void startRecording(){
    currentRecording = Recording(userId: userId);
    _recording = true;
    notifyListeners();
  }

  bool addDetectedSymptom(DetectedSymptom symptom) {
    if (_recording){
      _currentlyDetectedSymptoms.add(symptom);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool confirmSymptom(int index) {
    if (_recording){
      currentRecording!.addDetectedSymptom(_currentlyDetectedSymptoms[index]);
      _currentlyDetectedSymptoms.removeAt(index);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool deleteDetectedSymptom(int index) {
    if (_recording) {
      _currentlyDetectedSymptoms.removeAt(index);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool editDetectedSymptom(Symptom symptom, int index) {
    if (_recording) {
      _currentlyDetectedSymptoms[index] = DetectedSymptom(symptom: symptom, detectionTime: _currentlyDetectedSymptoms[index].detectionTime);
      notifyListeners();
      return true;
    }
    return false;
  }

  void stopRecording() {
    if (currentRecording != null) {
      currentRecording!.stopRecording();
      _saveRecording();
      _recording = false;
      _currentlyDetectedSymptoms = [];
      notifyListeners();
    } else {
      print("stopped recording without starting");
    }

  }

  void _saveRecording(){
    currentRecording!.saveRecording();
  }

  bool isRecording(){
    return _recording;
  }
}
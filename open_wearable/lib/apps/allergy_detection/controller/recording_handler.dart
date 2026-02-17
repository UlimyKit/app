import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/recording.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

class RecordingHandler extends ChangeNotifier{
  bool _recording = false;
  Recording? currentRecording;
  String userId;
  List<DetectedSymptom> _currentlyDetectedSymptoms = [];
  List<DetectedSymptom> _symptomNotifications = [];

  RecordingHandler({required this.userId});

  List<DetectedSymptom> getDetectedSymptoms() {
    return _currentlyDetectedSymptoms;
  }

  List<DetectedSymptom> getSymptomNotifications() {
    return _symptomNotifications;
  }

  void addSymptomNotification(DetectedSymptom symptom) {
    _symptomNotifications.add(symptom);
    notifyListeners();
  }

  void editAndConfirmNotifiedSymptom(Symptom symptom, int index) {
    _symptomNotifications[index].humanLabel = symptom;
    confirmSymptomNotification(index);
  }

  void confirmSymptomNotification(int index){
    _currentlyDetectedSymptoms.add(_symptomNotifications[index]);
    _symptomNotifications.removeAt(index);
    notifyListeners();
  }

  void startRecording(){
    currentRecording = Recording(userId: userId, startingTime: DateTime.now().toUtc());
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

  bool editDetectedSymptom(Symptom symptom, int index) {
    if (_recording) {
      _currentlyDetectedSymptoms[index].humanLabel = symptom;
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
    for ( DetectedSymptom symptom in _currentlyDetectedSymptoms) {
      currentRecording!.addDetectedSymptom(symptom);
    }
    currentRecording!.saveRecording();
  }

  bool isRecording(){
    return _recording;
  }

}

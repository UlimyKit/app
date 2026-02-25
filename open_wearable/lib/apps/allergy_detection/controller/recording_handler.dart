import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/controller/symptom_detector.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/recording.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

/*  Class that handles the notifcations and symptoms input from user and algorithm.
It holds a recording object to which everything is written at the end of a session.

*/
class RecordingHandler extends ChangeNotifier{
  bool _recording = false;
  Recording? currentRecording;
  SymptomDetector detector;
  String userId;
  //confirmed symptoms detected by user or algorithm
  List<DetectedSymptom> _currentlyDetectedSymptoms = [];
  //notification of detected symptoms from algorithm
  List<DetectedSymptom> _symptomNotifications = [];

  RecordingHandler({required this.userId, required this.detector});

  List<DetectedSymptom> getDetectedSymptoms() {
    return _currentlyDetectedSymptoms;
  }

  List<DetectedSymptom> getSymptomNotifications() {
    return _symptomNotifications;
  }

  String? getSessionId() {
    if ( currentRecording == null) {
      return null;
    }
    return currentRecording!.sessionId;
  }

  //adds a notifcation of a detected symptom only if currently recording
  void addSymptomDetectionNotification(DetectedSymptom symptom) {
    if (isRecording()){
    _symptomNotifications.add(symptom);
    
    notifyListeners();
    }
  }

  //edits and confirms notification
  void editAndConfirmNotifiedSymptom(Symptom symptom, int index) {
    _symptomNotifications[index].humanLabel = symptom;
    confirmSymptomNotification(index);
  }

  //confirms notification
  void confirmSymptomNotification(int index){
    _currentlyDetectedSymptoms.add(_symptomNotifications[index]);
    _symptomNotifications.removeAt(index);
    notifyListeners();
  }

  //creates new recording object and sets recording true
  void startRecording(){
    currentRecording = Recording(userId: userId, startingTime: DateTime.now().toUtc());
    detector.startRecording(currentRecording!.sessionId, currentRecording!.startingTime, addSymptomDetectionNotification);
    _recording = true;
    notifyListeners();
  }

  //adds a detected symptom to the recording
  bool addDetectedSymptom(DetectedSymptom symptom) {
    if (_recording){
      _currentlyDetectedSymptoms.add(symptom);
      notifyListeners();
      return true;
    }
    return false;
  }

  //edits a detected symptom in the recording
  bool editDetectedSymptom(Symptom symptom, int index) {
    if (_recording) {
      _currentlyDetectedSymptoms[index].humanLabel = symptom;
      notifyListeners();
      return true;
    }
    return false;
  }

  //stops recording saves it and clears the ui of symptoms
  void stopRecording() {
    if (currentRecording != null) {
      currentRecording!.stopRecording();
      _saveRecording();
      _recording = false;
      _currentlyDetectedSymptoms = [];
      _symptomNotifications = [];
      currentRecording = null;
      notifyListeners();
    } else {
      print("stopped recording without starting");
    }

  }

  //adds all the detected symptoms to the recording object and saves them to persistant data
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


import 'dart:async';

import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/apps/allergy_detection/controller/recording_handler.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';

class SymptomDetector {
  final RecordingHandler _recordingHandler;
  final Wearable _leftWearable;
  final SensorConfigurationProvider _leftSensorConfigurationProvider;
  final Wearable _rightWearable;
  final SensorConfigurationProvider _rightSensorConfigurationProvider;

  StreamSubscription<SensorValue>? _leftSubscription;
  StreamSubscription<SensorValue>? _rightSubscription;

  SymptomDetector(
    this._leftWearable,
    this._leftSensorConfigurationProvider,
    this._rightWearable,
    this._rightSensorConfigurationProvider,
    this._recordingHandler,
  );

  RecordingHandler getRecordingHandler() {
    return _recordingHandler;
  }
  
  void startRecording() {
    _configureSensors();




  }

  Future<void> setRcordingFilePrefix(String prefix) async{
    if (_leftWearable is! EdgeRecorderManager) {
      throw Exception(
        "The left wearable is not an EdgeRecorderManager",
      );
    }

    if (_rightWearable is! EdgeRecorderManager) {
      throw Exception(
        "The right wearable is not an EdgeRecorderManager",
      );
    }

    await Future.wait([
      (_leftWearable as EdgeRecorderManager).setFilePrefix("left_$prefix"),
      (_rightWearable as EdgeRecorderManager).setFilePrefix("right_$prefix"),
    ]);
  }

  //analyze sensorstream and call _recordingHandler.addSymptom(Symptom symptom)
  void _startDetection() {

  }

  void _configureSensors() {

  }

  void _stopDetection() {

  }

  void stopRecording () {

  }
}

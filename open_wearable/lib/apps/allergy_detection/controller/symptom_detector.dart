
import 'dart:async';

import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/apps/allergy_detection/controller/recording_handler.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';

class SymptomDetector {
  final RecordingHandler _recordingHandler;
  final SensorManager _sensorManager;
  final SensorConfigurationProvider _sensorConfigurationProvider;

  SymptomDetector(this._sensorManager, this._sensorConfigurationProvider, this._recordingHandler);

  RecordingHandler getRecordingHandler() {
    return _recordingHandler;
  }
  //analyze sensorstream and call _recordingHandler.addSymptom(Symptom symptom)
}
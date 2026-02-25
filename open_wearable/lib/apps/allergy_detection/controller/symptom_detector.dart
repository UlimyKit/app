
import 'dart:async';

import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/controller/recording_handler.dart';
import 'package:open_wearable/apps/allergy_detection/controller/synchornizationevent_logger.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/sensor_configuration.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';

class SymptomDetector {
  final Wearable _leftWearable;
  final SensorConfigurationProvider _leftSensorConfigurationProvider;
  final Wearable _rightWearable;
  final SensorConfigurationProvider _rightSensorConfigurationProvider;
  late DateTime _sessionStartTime;
  late void Function(DetectedSymptom) onSymptomDetected;


  StreamSubscription<SensorValue>? _leftSubscription;
  StreamSubscription<SensorValue>? _rightSubscription;

  SymptomDetector(
    this._leftWearable,
    this._leftSensorConfigurationProvider,
    this._rightWearable,
    this._rightSensorConfigurationProvider,
  );

  Future<void> startRecording(String sessionId, DateTime sessionStartTime, void Function(DetectedSymptom) onSymptomDetected) async {
    this.onSymptomDetected = onSymptomDetected;
    _configureSensors(sessionId);
    await setRecordingFilePrefix(sessionId);
    await _startSyncEvent();
    _applyConfiguration(_leftWearable, _leftSensorConfigurationProvider, GlobalSensorConfig.globalSensorConfigs);
    _applyConfiguration(_rightWearable, _rightSensorConfigurationProvider, GlobalSensorConfig.globalSensorConfigs);
  }

  void _configureSensors(String sessionId) {
    _enableRecordingSensors(_leftWearable, _leftSensorConfigurationProvider);
    _enableRecordingSensors(_rightWearable, _rightSensorConfigurationProvider);
  }

  Future<void> setRecordingFilePrefix(String prefix) async{
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

  Future<void> _startSyncEvent() async{
    Synchronizer synchronizer = Synchronizer(sessionStartTime: _sessionStartTime);

    if (_leftWearable is SensorManager) {
        List<Sensor> sensors = (_leftWearable as SensorManager).sensors;
        for (var sensor in sensors) {
          if (sensor.sensorName == "OPTICAL_TEMPERATURE_SENSOR") {
            _leftSubscription = sensor.sensorStream.listen(
              (SensorValue value) => synchronizer.logSyncLeftEvent(value.timestamp),
              onDone: () async => await _leftSubscription?.cancel(),
              onError: (error) async {
                print('Right streaming error: $error');
                await _leftSubscription?.cancel();
              },
            );
          }
        }
      }

      if (_rightWearable is SensorManager) {
        List<Sensor> sensors = (_rightWearable as SensorManager).sensors;
        for (var sensor in sensors) {
          if (sensor.sensorName == "OPTICAL_TEMPERATURE_SENSOR") {
            _rightSubscription = sensor.sensorStream.listen(
              (SensorValue value) => synchronizer.logSyncRightEvent(value.timestamp),
              onDone: () async => await _rightSubscription?.cancel(),
              onError: (error) async {
                print('Right streaming error: $error');
                await _rightSubscription?.cancel();
              },
            );
          }
        }
      }
      await synchronizer.sensorsReady;
  }

  void _stopDetection() {

  }
  
  void _enableRecordingSensors(Wearable wearable, SensorConfigurationProvider configProvider) {
    SensorManager sensorManager = wearable.requireCapability<SensorManager>();

    for (Sensor sensor in sensorManager.sensors) {
      List<SensorConfiguration> configurations = sensor.relatedConfigurations;

      for (var configuration in configurations) {
        if(configuration is ConfigurableSensorConfiguration) {
          if(configuration.availableOptions.contains(RecordSensorConfigOption())) {
            configProvider.addSensorConfigurationOption(configuration, RecordSensorConfigOption());
          }
        }
      }
    }
  }

  void _applyConfiguration(Wearable wearable, SensorConfigurationProvider configProvider, Map<String, SensorConfig> configs) {
    SensorManager sensorManager = wearable.requireCapability<SensorManager>();

    for (Sensor sensor in sensorManager.sensors) {
      
      if(configs.containsKey(sensor.sensorName.toLowerCase())) {
        
        List<SensorConfiguration> configurations = sensor.relatedConfigurations;
        (sensor as SensorFrequencyConfiguration).setFrequencyBestEffort(configs[sensor.sensorName]!.sampleRate);
        for (var configuration in configurations) {
          configuration.setConfiguration(configProvider.getSelectedConfigurationValue(configuration)!);
        }

      }
    }
  }

  

  void stopRecording () {

  }
}

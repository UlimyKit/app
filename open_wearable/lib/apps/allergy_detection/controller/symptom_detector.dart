import 'dart:async';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';
import 'package:open_wearable/apps/allergy_detection/model/sensor_configuration.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';

class SymptomDetector {
  final Wearable leftWearable;
  final SensorConfigurationProvider leftSensorCfgProvider;
  final Wearable rightWearable;
  final SensorConfigurationProvider rightSensorCfgProvider;
  late void Function(DetectedSymptom) onSymptomDetected;

  /// Default sensor ID mapping for OpenEarable v2
  static const Map<String, String> defaultSensorIdMap = {
    'imu': "9-Axis IMU",
    'ppg': "Pulse Oximeter",
    'temperature': "Skin Temperature Sensor",
    'pressure': "Ear Canal Pressure Sensor",
    'bone_conduction': "Bone Conduction Accelerometer",
    'microphone': "Microphones",
  };

  late Map<String, SensorConfiguration> _leftSensorIdToCfgMap;
  late Map<String, SensorConfiguration> _rightSensorIdToCfgMap;

  StreamSubscription<SensorValue>? _leftSubscription;
  StreamSubscription<SensorValue>? _rightSubscription;

  SymptomDetector(
    this.leftWearable,
    this.leftSensorCfgProvider,
    this.rightWearable,
    this.rightSensorCfgProvider,
  );

  void _setConfigProvider(
    String? sensorId,
    SensorConfigurationProvider cfgProvider,
    Map<String, SensorConfiguration<SensorConfigurationValue>>
        sensorIdToConfigMap,
    SensorConfig experimentSensorConfig,
  ) {
    if (sensorId != null && sensorIdToConfigMap.containsKey(sensorId)) {
      final cfg = sensorIdToConfigMap[sensorId]!;

      if (cfg is SensorFrequencyConfiguration) {
        List<SensorConfigurationValue> values =
            cfgProvider.getSensorConfigurationValues(cfg, distinct: true);

        // Find the closest sample rate
        final bestMatch = _findBestMatch(values, experimentSensorConfig);

        if (bestMatch != null) {
          cfgProvider.addSensorConfiguration(
            cfg,
            bestMatch,
          );
        }
      }

      // for all sensors enable recording
      if (cfg is ConfigurableSensorConfiguration) {
        if (cfg.availableOptions.contains(RecordSensorConfigOption())) {
          cfgProvider.addSensorConfigurationOption(
            cfg,
            RecordSensorConfigOption(),
          );
        }
        
      }
    }
  }

  SensorFrequencyConfigurationValue? _findBestMatch(
    List<SensorConfigurationValue> values,
    SensorConfig experimentSensorConfig,
  ) {
    SensorFrequencyConfigurationValue? bestMatch;
    double minDiff = 1000000;
    for (var value in values) {
      if (value is SensorFrequencyConfigurationValue) {
        double diff =
            (value.frequencyHz - experimentSensorConfig.sampleRate).abs();
        if (diff < minDiff) {
          minDiff = diff;
          bestMatch = value;
        }
        if (minDiff == 0) {
          break;
        }
      }
    }
    return bestMatch;
  }

  /// Configure sensors based on global configuration
  Future<
      (
        List<
            (
              SensorConfiguration<SensorConfigurationValue>,
              SensorConfigurationValue
            )>,
        List<
            (
              SensorConfiguration<SensorConfigurationValue>,
              SensorConfigurationValue
            )>
      )> configureSensors() async {
    if (leftWearable is! SensorConfigurationManager) {
      throw Exception(
        "The left wearable does not support sensor configuration",
      );
    }
    if (rightWearable is! SensorConfigurationManager) {
      throw Exception(
        "The right wearable does not support sensor configuration",
      );
    }

    // Configure each sensor according to the global configuration
    for (var sensorConfig in GlobalSensorConfig.globalSensorConfigs) {
      final sensorName = sensorConfig.sensorName.toLowerCase();

      // Get the sensor ID from the configuration
      final sensorId = defaultSensorIdMap[sensorName];

      _setConfigProvider(
        sensorId,
        leftSensorCfgProvider,
        _leftSensorIdToCfgMap,
        sensorConfig,
      );
      _setConfigProvider(
        sensorId,
        rightSensorCfgProvider,
        _rightSensorIdToCfgMap,
        sensorConfig,
      );
    }

    var leftSelectedCfgs = leftSensorCfgProvider.getSelectedConfigurations();
    for (var entry in leftSelectedCfgs) {
      SensorConfiguration config = entry.$1;
      SensorConfigurationValue value = entry.$2;
      config.setConfiguration(value);
    }

    var rightSelectedCfgs = rightSensorCfgProvider.getSelectedConfigurations();
    for (var entry in rightSelectedCfgs) {
      SensorConfiguration config = entry.$1;
      SensorConfigurationValue value = entry.$2;
      config.setConfiguration(value);
    }

    String leftSelectedCfgsString = leftSelectedCfgs.map(
      (entry) {
        String name = entry.$1.name;
        String frequency = entry.$2 is SensorFrequencyConfigurationValue
            ? "${(entry.$2 as SensorFrequencyConfigurationValue).frequencyHz}Hz"
            : "configured";
        return "$name: $frequency";
      },
    ).join("; ");

    String rightSelectedCfgsString = rightSelectedCfgs.map(
      (entry) {
        String name = entry.$1.name;
        String frequency = entry.$2 is SensorFrequencyConfigurationValue
            ? "${(entry.$2 as SensorFrequencyConfigurationValue).frequencyHz}Hz"
            : "configured";
        return "$name: $frequency";
      },
    ).join("; ");

    print(leftSelectedCfgsString);
    print(rightSelectedCfgsString);

    return (leftSelectedCfgs, rightSelectedCfgs);
  }

  String? getSensorId(String sensorName) {
    final normalizedName = sensorName.toLowerCase();
    return defaultSensorIdMap[normalizedName];
  }

  Future<void> turnOffSensors() async{
    await Future.wait([
      rightSensorCfgProvider.turnOffAllSensors(),
      leftSensorCfgProvider.turnOffAllSensors(),
    ]);
  }
}

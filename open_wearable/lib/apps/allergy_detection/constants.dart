import 'package:open_wearable/apps/allergy_detection/model/sensor_configuration.dart';

import 'model/symptom.dart';

class Symptoms {
  static const List<Symptom> symptomList = [
    Symptom(
        name: "Itchy eyes",
        description: "Eyes feel irritated, watery or itchy.",
        reactions: [
          "Rubbing eyes",
        ],
      ),
      Symptom(
        name: "Globus sensation",
        description:
            "A feeling of a lump, tightness, or something stuck in the throat.",
        reactions: [
          "Urge to swallow",
        ],
      ),
      Symptom(
        name: "Itchy palate",
        description: "Tickling/itching sensation on the roof of your mouth.",
        reactions: [
          "Coughing",
          "Throat clearing",
          "Tongue rubbing in the throat",
          "Saliva pumping in the throat",
        ],
      ),
      Symptom(
        name: "Itchy ears",
        description: "Itching sensation on or inside the ears.",
        reactions: [
          "Rubbing the ears",
        ],
      ),
      Symptom(
        name: "Running nose",
        description: "A nose that keeps dripping or feels wet.",
        reactions: [
          "Sniffing",
        ],
      ),
  ];
}

class GlobalSensorConfig {

  static final Map<String, SensorConfig> globalSensorConfigs = {
  "imu": SensorConfig(sensorName: "imu", sampleRate: 50),
  "pressure": SensorConfig(sensorName: "pressure", sampleRate: 50),
  "microphone": SensorConfig(sensorName: "microphone", sampleRate: 48000),
  "ppg": SensorConfig(sensorName: "ppg", sampleRate: 50),
  "boneConduction": SensorConfig(sensorName: "boneConduction", sampleRate: 1600),
  "temperature": SensorConfig(sensorName: "temperature", sampleRate: 8),
};
}
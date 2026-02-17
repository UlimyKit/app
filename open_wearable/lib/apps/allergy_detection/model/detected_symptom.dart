import 'dart:core';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

class DetectedSymptom {
Symptom humanLabel;
Symptom? machineLabel;
DateTime? detectionStartTime;
final DateTime detectionEndTime;

DetectedSymptom ({
    required this.humanLabel,
    this.machineLabel,
    this.detectionStartTime,
    required this.detectionEndTime,
});
}

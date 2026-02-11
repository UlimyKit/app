import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

class DetectedSymptom {
final Symptom symptom;
final TimeOfDay detectionTime;

const DetectedSymptom ({
    required this.symptom,
    required this.detectionTime,
});
}

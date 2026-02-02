
import 'package:open_wearable/apps/allergy_detection/model/detected_symptom.dart';

class Recording {
  final String userId;
  DateTime startingTime;
  DateTime? endingTime;
  List<DetectedSymptom> _detectedSymptoms = [];

  Recording({required this.userId}): startingTime = DateTime.now();

  void addDetectedSymptom(DetectedSymptom? detectedSymptom){
    if (detectedSymptom != null){
    _detectedSymptoms.add(detectedSymptom);
    }
  }

  void stopRecording(){
    endingTime = DateTime.now();
  }

  List<DetectedSymptom> getDetectedSymptoms(){
    return _detectedSymptoms;
  }
}

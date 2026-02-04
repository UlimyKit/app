import 'package:open_wearable/apps/allergy_detection/constants.dart';

class Symptom {
  final String name;
  final String description;
  final List<String> reactions;

  const Symptom ({
    required this.name,
    required this.description,
    required this.reactions,
});

}

extension SymptomParsing on Symptom{
  static Symptom? symptomFromName(String name) {
    for (Symptom symptom in Symptoms.symptomList) {
      if (symptom.name == name) {
        return symptom;
      } 
    }
    return null;
  }
}
import 'package:open_wearable/apps/allergy_detection/constants.dart';

/// ---------------------------------------------------------------------------
/// Symptom
/// ---------------------------------------------------------------------------
/// 
/// Represents a medical symptom used within the allergy detection survey.
/// 
/// Each symptom contains:
/// - A unique [name]
/// - A short [description]
/// - A list of possible [reactions] related to the symptom
/// 
/// ---------------------------------------------------------------------------
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

/// ---------------------------------------------------------------------------
/// SymptomParsing Extension
/// ---------------------------------------------------------------------------
/// 
/// Provides helper to return a Symptom from a String
/// [Symptom] objects.
/// 
/// ---------------------------------------------------------------------------
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

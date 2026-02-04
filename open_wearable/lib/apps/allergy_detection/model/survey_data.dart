

import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/constants.dart';
import 'package:open_wearable/apps/allergy_detection/data/user_survey_storage.dart';
import 'package:open_wearable/apps/allergy_detection/model/gender.dart';
import 'package:open_wearable/apps/allergy_detection/model/likert_scale.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

class SurveyData with ChangeNotifier{
  final SurveyStorage storage = SurveyStorage();
  String userId = "";
  int age = -1;
  Gender gender = Gender.other;
  List<String> allergies = [];
  Map<Symptom,LikertScale> knownSymptoms = {};
  Map<Symptom,LikertScale> frequenceSymptoms = {};
  Map<Symptom,LikertScale> currentSymptoms = {};

  bool userIdFilled = false;
  bool ageFilled = false;
  bool genderFilled = false;
  bool allergiesFilled = false;
  bool knownSymptomsFilled = false;
  bool frequenceSymptomsFilled = false;
  bool currentSymptomsFilled = false;

  void setUserId(String userId) {
    this.userId = userId;
    userIdFilled = userId.trim().isNotEmpty;
    notifyListeners();
  }

  void setAge(int age) {
    this.age = age;
    ageFilled = age>0;
    notifyListeners();
  }

  void setGender(Gender gender) {
    this.gender = gender;
    genderFilled = true;
    notifyListeners();
  }

  void setAllergiess(List<String> allergies) {
    this.allergies = allergies;
    allergiesFilled = allergies.isNotEmpty;
    notifyListeners();
  }

  void setKnownSymptoms(Map<Symptom,LikertScale> knownSymptoms) {
    this.knownSymptoms = knownSymptoms;
    knownSymptomsFilled = knownSymptoms.isNotEmpty;
    notifyListeners();

  }

  void setFrequenceSymptoms(Map<Symptom,LikertScale> frequenceSymptoms) {
    this.frequenceSymptoms = frequenceSymptoms;
    frequenceSymptomsFilled = frequenceSymptoms.isNotEmpty;
    notifyListeners();
  }
  void setCurrentSymptoms(Map<Symptom,LikertScale> currentSymptoms) {
    this.currentSymptoms = currentSymptoms;
    currentSymptomsFilled = currentSymptoms.isNotEmpty;
    notifyListeners();
  }

  bool getSurveyFilled() {
    return userIdFilled && ageFilled && genderFilled && allergiesFilled && knownSymptomsFilled && frequenceSymptomsFilled && currentSymptomsFilled;
  }

  Map<String,dynamic> toJson() {
    return {
    'userId': userId,
    'age': age,
    'gender': gender.toString().split('.').last,
    'allergies': allergies,

    'knownSymptoms': knownSymptoms.map(
      (k, v) => MapEntry(k.name, v.value),
    ),
    'frequenceSymptoms': frequenceSymptoms.map(
      (k, v) => MapEntry(k.name, v.value),
    ),
    'currentSymptoms': currentSymptoms.map(
      (k, v) => MapEntry(k.name, v.value),
    ),
  };
  }

  void fromJson(Map<String, dynamic> json) {
    setAge(json['age']??-1);
    setGender(json['gender'] != null ? enumFromString(Gender.values, json['gender']): Gender.other);
    allergies = List<String>.from(json['allergies'] ?? []);
    knownSymptoms = (json['knownSymptoms'] as Map<String, dynamic>? ?? {})
      .map((k, v) => MapEntry(
            SymptomParsing.symptomFromName(k)!,
            LikertScale(v),
          ));

  frequenceSymptoms =
      (json['frequenceSymptoms'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(
                SymptomParsing.symptomFromName(k)!,
                LikertScale(v),
              ));

  currentSymptoms =
      (json['currentSymptoms'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(
                SymptomParsing.symptomFromName(k)!,
                LikertScale(v),
              ));
  }

  T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere(
    (e) => (e as Object).toString().split('.').last == value,
  );
  }

  Future<bool> loadOrCreate(String userId) async {
    this.userId = userId;

    if (await storage.exists(userId)) {
      final json = await storage.load(userId);
      if (json != null) {
        fromJson(json);
        return true; // existing user
      }
    }

    notifyListeners();
    return false; // new user
  }

  Future<void> saveData() async {
  if (userId.isEmpty) return;
  await storage.save(userId, toJson());
  }

}

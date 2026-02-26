import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/data/user_survey_storage.dart';
import 'package:open_wearable/apps/allergy_detection/model/gender.dart';
import 'package:open_wearable/apps/allergy_detection/model/likert_scale.dart';
import 'package:open_wearable/apps/allergy_detection/model/symptom.dart';

/// Stores and manages all survey-related user data.
/// 
/// Uses ChangeNotifier to update UI when data changes.
/// Handles:
/// - Survey state management
/// - Completion validation
/// - JSON serialization
/// - Persistent storage
class SurveyData with ChangeNotifier{
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

  /// Sets the user ID.
  /// 
  /// Updates [userIdFilled] and notifies listeners.
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

  void setAllergies(List<String> allergies) {
    this.allergies = allergies;
    allergiesFilled = allergies.isNotEmpty;
    notifyListeners();
  }

  /// Adds or updates known symptoms.
  /// 
  /// Merges the provided map into the existing [knownSymptoms] map.
  /// Marks [knownSymptomsFilled] true if input map is not empty.
  /// Notifies listeners after updating state.
  void addKnownSymptoms(Map<Symptom,LikertScale> knownSymptoms) {
    knownSymptoms.forEach((key,value) {
      this.knownSymptoms[key] = value;
    });
    knownSymptomsFilled = knownSymptoms.isNotEmpty;
    notifyListeners();

  }

  /// Adds or updates frequency-related symptom data.
  /// 
  /// Merges the provided map into [frequenceSymptoms].
  /// Marks [frequenceSymptomsFilled] true if input map is not empty.
  /// Notifies listeners after updating state.
  void addFrequenceSymptoms(Map<Symptom,LikertScale> frequenceSymptoms) {
    frequenceSymptoms.forEach((key,value) {
      this.frequenceSymptoms[key] = value;
    });
    frequenceSymptomsFilled = frequenceSymptoms.isNotEmpty;
    notifyListeners();
  }

  /// Adds or updates currently experienced symptoms.
  /// 
  /// Merges the provided map into [currentSymptoms].
  /// Marks [currentSymptomsFilled] true if input map is not empty.
  /// Notifies listeners after updating state.
  void addCurrentSymptoms(Map<Symptom,LikertScale> currentSymptoms) {
    currentSymptoms.forEach((key,value) {
      this.currentSymptoms[key] = value;
    });
    currentSymptomsFilled = currentSymptoms.isNotEmpty;
    notifyListeners();
  }

  bool getSurveyFilled() {
    return userIdFilled && ageFilled && genderFilled && allergiesFilled && knownSymptomsFilled && frequenceSymptomsFilled && currentSymptomsFilled;
  }

   /// Converts the survey data into a JSON-compatible map.
  /// 
  /// - Enums are converted to their string representation.
  /// - Symptom maps are converted into:
  ///     Map<String symptomName, int likertValue>
  /// 
  /// Used for persistent storage.
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

  /// Restores survey data from a JSON map.
  /// 
  /// Safely handles missing fields using default values.
  /// Converts stored symptom names (String) back into Symptom enums.
  /// Reconstructs LikertScale objects from stored integer values.
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

  /// Converts a string back into its corresponding enum value.
  /// 
  /// Matches based on the enum's name (after splitting at '.').
  T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere(
    (e) => (e as Object).toString().split('.').last == value,
  );
  }

  /// Loads an existing survey from persistent storage,
  /// or prepares a new survey if none exists.
  /// 
  /// Returns:
  /// - true  → existing survey was loaded
  /// - false → new survey (no previous data found)
  Future<bool> loadOrCreate(String userId) async {
    this.userId = userId;

    if (await SurveyStorage.exists(userId)) {
      final json = await SurveyStorage.load(userId);
      if (json != null) {
        fromJson(json);
        return true; // existing user
      }
    }

    notifyListeners();
    return false; // new user
  }

  /// Saves the current survey data persistently.
  /// 
  /// Does nothing if userId is empty.
  Future<void> saveData() async {
  if (userId.isEmpty) return;
  await SurveyStorage.save(userId, toJson());
  }

  /// Converts survey data into CSV format.
  /// 
  /// Structure:
  /// - Basic user info
  /// - Known symptoms
  /// - Frequency symptoms
  /// - Current symptoms
  /// 
  /// Symptoms are formatted as:
  ///   symptomName=likertValue
  String toCSV() {
    String csv = "UserID:$userId\nAge:$age\nGender:${gender.toString().split('.').last}\nAllergies:${allergies.join("|")}";
    csv = "$csv\nKnownledge of Symptoms:${knownSymptoms.entries.map((ks) => "${ks.key.name}=${ks.value.value}").join(', ')}";
    csv = "$csv\nFrequence of Symptoms:${frequenceSymptoms.entries.map((ks) => "${ks.key.name}=${ks.value.value}").join(', ')}";
    csv = "$csv\nCurrent Symptoms:${currentSymptoms.entries.map((ks) => "${ks.key.name}=${ks.value.value}").join(', ')}";
    return csv;
  }
}

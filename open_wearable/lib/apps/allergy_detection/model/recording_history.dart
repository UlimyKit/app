import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/data/symptom_recording_storage.dart';
import 'recording.dart';

class RecordingHistory with ChangeNotifier {
  String userId;

  RecordingHistory({required this.userId});
  List<Recording> _recordings = [];

  List<Recording> get recordings => _recordings;

  Future<void> loadRecordings(String userId) async { 
    
    _recordings = await RecordingCsvStorage.readRecordings(userId);

    // Sort by startingTime descending (latest first)
    _recordings.sort((a, b) => b.startingTime.compareTo(a.startingTime));
    notifyListeners();
  }
}
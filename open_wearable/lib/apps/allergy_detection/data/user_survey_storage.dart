import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

///
/// Static class to store the survey results persistently 
/// in a json in the application storage
///
class SurveyStorage {

  //creates or returns file for survey of user with given userid
  static Future<File> _fileForUser(String userId) async {
    final dir = await getApplicationDocumentsDirectory();
    
    return File('${dir.path}/survey_$userId.json');
  }

  // saves survey as json to file
  static Future<void> save(String userId, Map<String, dynamic> data) async {
    final file = await _fileForUser(userId);
    await file.writeAsString(jsonEncode(data));
  }

  //loads survey from json
  static Future<Map<String, dynamic>?> load(String userId) async {
    final file = await _fileForUser(userId);
    if (!await file.exists()) return null;

    return jsonDecode(await file.readAsString());
  }

  // checks if the survey file exists already
  static Future<bool> exists(String userId) async {
    final file = await _fileForUser(userId);
    return file.exists();
  }

  // removes the survey file
  static Future<void> clear(String userId) async {
    final file = await _fileForUser(userId);
    if (await file.exists()) await file.delete();
  }
}

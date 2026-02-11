import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class SurveyStorage {

  static Future<File> _fileForUser(String userId) async {
    final dir = await getApplicationDocumentsDirectory();
    
    return File('${dir.path}/survey_$userId.json');
  }

  static Future<void> save(String userId, Map<String, dynamic> data) async {
    final file = await _fileForUser(userId);
    await file.writeAsString(jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> load(String userId) async {
    final file = await _fileForUser(userId);
    if (!await file.exists()) return null;

    return jsonDecode(await file.readAsString());
  }

  static Future<bool> exists(String userId) async {
    final file = await _fileForUser(userId);
    return file.exists();
  }

  static Future<void> clear(String userId) async {
    final file = await _fileForUser(userId);
    if (await file.exists()) await file.delete();
  }
}

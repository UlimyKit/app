import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SurveyStorage {
  Future<File> _fileForUser(String userId) async {
    final dir = await getApplicationDocumentsDirectory();
    
    return File('${dir.path}/survey_$userId.json');
  }

  Future<void> save(String userId, Map<String, dynamic> data) async {
    final file = await _fileForUser(userId);
    await file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>?> load(String userId) async {
    final file = await _fileForUser(userId);
    if (!await file.exists()) return null;

    return jsonDecode(await file.readAsString());
  }

  Future<bool> exists(String userId) async {
    final file = await _fileForUser(userId);
    return file.exists();
  }

  Future<void> clear(String userId) async {
    final file = await _fileForUser(userId);
    if (await file.exists()) await file.delete();
  }
}

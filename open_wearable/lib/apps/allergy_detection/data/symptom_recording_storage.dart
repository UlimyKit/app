import 'dart:io';
import 'package:open_wearable/apps/allergy_detection/model/recording.dart';
import 'package:path_provider/path_provider.dart';

class RecordingCsvStorage {

  Future<File> _file(String userId) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$userId');
  }

  Future<void> appendRecording(Recording recording) async {
    final file = await _file(recording.userId);

    // Write header if file doesn't exist
    if (!await file.exists()) {
      await file.writeAsString('recording_id,symptoms\n');
    }

    final row = recording.toCsvRow();
    await file.writeAsString('$row\n', mode: FileMode.append);
  }

  Future<List<Recording>> readRecordings(String userId) async {
    final file = await _file(userId);

    if(!await file.exists()) {
      return [];
    }
    
    final lines = await file.readAsLines();
    List<Recording> recordings = [];

    for (var i = 1; i<lines.length; i++) {
      Recording recording = Recording(userId: userId);
      recording.fromString(lines[i]);
      recordings.add(recording);
    }
    return recordings;
  }
}
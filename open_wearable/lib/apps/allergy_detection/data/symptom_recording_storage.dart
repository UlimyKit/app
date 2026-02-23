import 'dart:io';
import 'package:open_wearable/apps/allergy_detection/model/recording.dart';
import 'package:path_provider/path_provider.dart';

/* 
static class that saves a recording object to persistent data storage.
It saves every recording in a file as symtpoms with sessionID userId|sessionID|machinelabel(optional)|humanLabel|Startofsymptomdetection(optional)|EndofSymptomDetection
it also saves a file for the recordings userId|sessionID|startingTime|endingTime
*/
class RecordingCsvStorage {

  static Future<File> getSessionsFile() async{
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/sessions.csv");
  }

  static Future<File> getFile(String userId) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/${getFileName(userId)}');
  }

  static Future<void> appendRecording(Recording recording) async {
    final file = await getFile(recording.userId);

    // Write header if file doesn't exist
    if (!await file.exists()) {
      await file.writeAsString('userID|sessionID|machinelabel(optional)|humanLabel|Startofsymptomdetection(optional)|EndofSymptomDetection\n');
    }

    final row = recording.toCsv();
    await file.writeAsString(row, mode: FileMode.append);

    final sessionFile = await getSessionsFile();
    if (!await sessionFile.exists()) {
      await sessionFile.writeAsString('userID|sessionID|startingTime|endingTime\n');
    }

    final sessionRow = "${recording.userId},${recording.sessionId},${recording.startingTime.toIso8601String()},${recording.endingTime?.toIso8601String()}\n";
    await sessionFile.writeAsString(sessionRow, mode: FileMode.append);
  }

  static Future<List<Recording>> readRecordings(String userId) async {
    final file = await getFile(userId);

    if(!await file.exists()) {
      return [];
    }

    final lines = await file.readAsLines();

    List<Recording> recordings = await getRecordingFromSessions(userId);
    String currentSessionId = "";
    Recording? currentRecording;
    for (var i = 1; i < lines.length; i++) {
      if (lines[i] == "") {
        return recordings;
      }
      
      final lineElements = lines[i].split(",");

      if (currentSessionId != lineElements[1]) {
        currentSessionId = lineElements[1];
        currentRecording = recordings.firstWhere(
          (rec) {return rec.sessionId == currentSessionId;},
        );
      }

      if (currentRecording == null) {
        throw FormatException("No Recording with this session Id found");
      }

      currentRecording.fromStringAddSymptom(lines[i]);
    }
    return recordings;
  }

  static String getFileName(String userId){
    return "Session_Record_of_$userId.csv";
  }

  static Future<List<Recording>> getRecordingFromSessions(String userId) async {
    
    File sessionFile = await getSessionsFile();

    final lines = await sessionFile.readAsLines();
    
    List<Recording> recordings = [];
    
    
    for (var i = 1; i < lines.length; i++) {
      final lineElements = lines[i].split(",");
      
      if (lineElements[0] == userId) {
        var recording = Recording(userId: lineElements[0], startingTime: DateTime.parse(lineElements[2]));
        recording.endingTime = DateTime.parse(lineElements[3]);
        recordings.add(recording);
      }
    }
    return recordings;
  }

  static Future<void> copyToOther(String userId, String dirPath) async {
    final sourceFile = await getFile(userId);
    String targetPath = "$dirPath/${getFileName(userId)}";
    final targetFile = File(targetPath);

    // Make sure the directory exists
    await Directory(dirPath).create(recursive: true);

    // Delete target if it exists (overwrite safely)
    await targetFile.writeAsString(await sourceFile.readAsString());
    
}


  static Future<void> clearDocumentsDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      if (await directory.exists()) {
        // List all files & directories
        final files = directory.listSync(recursive: true);

        for (final file in files) {
          if (file is File) {
            await file.delete();
          } else if (file is Directory) {
            await file.delete(recursive: true); // delete directories recursively
          }
        }

        print("All files deleted from ${directory.path}");
      }
    } catch (e) {
      print("Error deleting files: $e");
    }
  }


}

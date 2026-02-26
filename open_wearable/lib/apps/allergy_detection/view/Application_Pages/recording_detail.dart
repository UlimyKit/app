import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/model/recording.dart';

///
/// Page which holds Information of a specific Recording
///
///
///
class RecordingDetailPage extends StatelessWidget {
  final Recording recording;

  const RecordingDetailPage({super.key, required this.recording});

  @override
  Widget build(BuildContext context) {
    final symptoms = recording.getDetectedSymptoms();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording Details'),
      ),
      body: ListView.builder(
        itemCount: symptoms.length,
        itemBuilder: (context, index) {
          final s = symptoms[index];
          return ListTile(
            title: Text(s.humanLabel.name),
            subtitle: Text(
              '${s.humanLabel.description} at ${s.detectionEndTime.hour.toString().padLeft(2, '0')}:${s.detectionEndTime.minute.toString().padLeft(2, '0')}',
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:open_wearable/apps/allergy_detection/model/recording_history.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/recording_detail.dart';
import 'package:provider/provider.dart';

class SessionHistoryPage extends StatefulWidget {
  const SessionHistoryPage({super.key});

  @override
  State<SessionHistoryPage> createState() => _SessionHistoryPageState();
}

class _SessionHistoryPageState extends State<SessionHistoryPage> {



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecordingHistory(userId:context.read<SurveyData>().userId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Session History'),
        ),
        body: Consumer<RecordingHistory>(
          builder: (context, history, child) {
            final recordings = history.recordings;
            if (recordings.isEmpty) {
              return const Center(child: Text('No recordings yet'));
            }
            return ListView.builder(
              itemCount: recordings.length,
              itemBuilder: (context, index) {
                final rec = recordings[index];
                return ListTile(
                  title: Text(
                    'Recording at ${rec.startingTime.toLocal().toString().split('.')[0]}',
                  ),
                  subtitle: Text(
                    '${rec.getDetectedSymptoms().length} symptoms detected',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecordingDetailPage(recording: rec),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
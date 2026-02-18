import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/data/symptom_recording_storage.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Settings'),
        trailingActions: [PlatformIconButton(
          icon: Icon(context.platformIcons.clear, color: Colors.red, size: 32,), 
          onPressed: exitAppDialog,
        ),]
      ),
      body: PlatformWidget(
        material: (_, __) => _buildMaterial(),
        cupertino: (_, __) => _buildCupertino(),
      ),
    );
  }

  Widget _buildMaterial() {
    return ListView(
      children: [
        const _SectionHeader(title: 'Data export'),

        ListTile(
          leading: const Icon(Icons.assignment_outlined),
          title: const Text('Export surveys'),
          subtitle: const Text('Save survey data as CSV'),
          trailing: _exporting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right),
          onTap:_exporting ? null : _exportSurveys, ),

        const Divider(height: 1),

        ListTile(
          leading: const Icon(Icons.mic_none),
          title: const Text('Export recordings'),
          subtitle: const Text('Save audio files'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _exporting ? null : _exportRecordings,
        ),
        const _SectionHeader(title: 'Reset'),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete Data'),
          subtitle: const Text('Reset the stored data'),
          trailing: _exporting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right),
          onTap:_exporting ? null : RecordingCsvStorage.clearDocumentsDirectory, ),

        const Divider(height: 1),
      ],
    );
  }

  Widget _buildCupertino() {
    return CupertinoListSection.insetGrouped(
      header: const Text('Data export'),
      children: [
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.doc_text),
          title: const Text('Export surveys'),
          subtitle: const Text('Save survey data as CSV'),
          trailing: _exporting
              ? const CupertinoActivityIndicator()
              : const CupertinoListTileChevron(),
          onTap: _exporting ? null : _exportSurveys,
        ),
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.mic),
          title: const Text('Export recordings'),
          subtitle: const Text('Save recording file'),
          trailing: const CupertinoListTileChevron(),
          onTap: _exporting ? null : _exportRecordings,
        ),
      ],
    );
  }
  
  
  Future<void> _exportSurveys() async {
    setState(() => _exporting = true);

    try {
      SurveyData surveyData = context.read<SurveyData>();
      final userId = surveyData.userId;
      final surveyDataCSV = surveyData.toCSV(true);
      
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        return;
      }
      File file = File("$selectedDirectory/survey_of_$userId.csv");
      await file.writeAsString(surveyDataCSV);
      _showMessage("Survey File has been succesfully exported");
      
    } catch (e) {
      _showMessage('Failed to export surveys');
    } finally {
      setState(() => _exporting = false);
    }
  }

  

  Future<void> _exportRecordings() async {
    setState(() => _exporting = true);

    try {
      SurveyData surveyData = context.read<SurveyData>();
      final userId = surveyData.userId;

      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        return;
      }

      await RecordingCsvStorage.copyToOther(userId, selectedDirectory);
      _showMessage('Recordings File has been succesfully exported');
    } catch (e) {
      _showMessage('Failed to export recordings');
      print(e);
    } finally {
      setState(() => _exporting = false);
    }
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void exitAppDialog() async{
    final navigator = Navigator.of(context, rootNavigator: true);
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
      title: const Text('Exit App?'),
      content: const Text('Make sure to save your session.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Exit'),
          ),
        ],
      ),
    );
    if (shouldExit == true) {
      navigator.pop();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Colors.grey),
      ),
    );
  }
}
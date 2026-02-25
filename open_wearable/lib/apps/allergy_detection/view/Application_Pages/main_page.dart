import 'package:flutter/material.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import 'package:open_wearable/apps/allergy_detection/controller/recording_handler.dart';
import 'package:open_wearable/apps/allergy_detection/controller/symptom_detector.dart';
import 'package:open_wearable/apps/allergy_detection/model/survey_data.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/pollen_flight.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/session_history.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/session_page.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/settings_page.dart';
import 'package:open_wearable/view_models/sensor_configuration_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  
  final Wearable leftWearable;
  final SensorConfigurationProvider leftSensorConfigurationProvider;
  final Wearable rightWearable;
  final SensorConfigurationProvider rightSensorConfigurationProvider;
  
  const MainPage({super.key,
  required this.leftWearable,
  required this.leftSensorConfigurationProvider,
  required this.rightWearable,
  required this.rightSensorConfigurationProvider,
  
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentPageIndex = 0;
  late RecordingHandler _recordingHandler;

  @override
  void initState() {
    super.initState();
    SymptomDetector detector = SymptomDetector(widget.leftWearable,
     widget.leftSensorConfigurationProvider,
     widget.rightWearable,
     widget.rightSensorConfigurationProvider);
    _recordingHandler = RecordingHandler(userId: context.read<SurveyData>().userId, detector: detector);
    
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _recordingHandler,
      child: Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentPageIndex,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                selectedIcon:Icon(Icons.notes),
                icon: Icon(Icons.notes_outlined), 
                label: 'Session',),
              NavigationDestination(selectedIcon: Icon(Icons.history),
                icon: Icon(Icons.history_outlined),
                label: 'Session History',),
                
              NavigationDestination(selectedIcon: Icon(Icons.flight),
              icon: Icon(Icons.flight_outlined),
              label: 'Pollen flight',
              ),
              NavigationDestination(selectedIcon: Icon(Icons.settings),
                icon: Icon(Icons.settings_outlined), 
                label: 'Settings',),
              ],
          
          ),
        body: <Widget>[
          SessionPage(),
          SessionHistoryPage(),
          PollenFlightPage(),
          SettingsPage(),
        ][currentPageIndex],
        ),
      );
  }
}

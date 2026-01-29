import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/pollen_flight.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/session_history.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/session_page.dart';
import 'package:open_wearable/apps/allergy_detection/view/Application_Pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: 'Session History'),
            
          NavigationDestination(selectedIcon: Icon(Icons.flight),
          icon: Icon(Icons.flight_outlined),
          label: 'Pollen flight',
          ),
          NavigationDestination(selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined), 
            label: 'Settings'),
          ],
      
      ),
    body: <Widget>[
      SessionPage(),
      SessionHistoryPage(),
      PollenFlightPage(),
      SettingsPage(),
    ][currentPageIndex],
    );
  }
}
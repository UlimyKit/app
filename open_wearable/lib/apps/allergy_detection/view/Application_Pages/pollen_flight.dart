import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PollenFlightPage extends StatefulWidget {
  const PollenFlightPage({super.key});

  @override
  State<PollenFlightPage> createState() => _PollenFlightPageState();
}

class _PollenFlightPageState extends State<PollenFlightPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PollenFlightPage"),),
    );
  }
}

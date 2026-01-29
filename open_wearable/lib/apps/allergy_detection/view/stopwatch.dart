import 'dart:async';
import 'package:flutter/material.dart';

class Stopwatch extends StatefulWidget {
  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _running = false;
  
  

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = twoDigits(duration.inHours.remainder(24));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Text(
              _formatDuration(_elapsed),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
        );
  }

  void toggleStopwatch() {
    if (_running) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _elapsed += Duration(seconds: 1);
        });
      });
    }
    setState(() {
      _running = !_running;
    });
  }

  void resetStopwatch() {
    _timer?.cancel();
    setState(() {
      _elapsed = Duration.zero;
      _running = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
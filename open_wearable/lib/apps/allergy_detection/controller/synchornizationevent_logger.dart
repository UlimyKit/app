import 'dart:async';

import 'package:open_wearable/apps/allergy_detection/model/synchornization_event.dart';

class Synchronizer {
  List<SyncEvent> _leftSyncEvents = [];
  List<SyncEvent> _rightSyncEvents = [];

  Completer<void>? _sensorsReady;

  late DateTime sessionStartTime;

  Synchronizer({required this.sessionStartTime});

  Future<void> get sensorsReady {
    // If both are already satisfied, just return immediately
    if (_leftSyncEvents.isNotEmpty && _rightSyncEvents.isNotEmpty) {
      return Future.value();
    }

    // Create a new pending completer if none exists or the old one is completed
    if (_sensorsReady == null || _sensorsReady!.isCompleted) {
      _sensorsReady = Completer<void>();
    }

    return _sensorsReady!.future;
  }

  void _checkReady() {
    if (_leftSyncEvents.isNotEmpty &&
        _rightSyncEvents.isNotEmpty &&
        _sensorsReady != null &&
        !_sensorsReady!.isCompleted) {
      _sensorsReady!.complete();
    }
  }

  void logSyncRightEvent(int deviceTimestamp) {
    final now = DateTime.now();
    final relative = now.difference(sessionStartTime).inMilliseconds;
    final event = SyncEvent(
      deviceTimestamp: deviceTimestamp,
      phoneTimestamp: now,
      relativePhoneTime: relative,
    );
    print(event.toCsvRow());
    _rightSyncEvents.add(event);
    _checkReady();
  }

  void logSyncLeftEvent(int deviceTimestamp) {
    final now = DateTime.now();
    final relative = now.difference(sessionStartTime).inMilliseconds;
    final event = SyncEvent(
      deviceTimestamp: deviceTimestamp,
      phoneTimestamp: now,
      relativePhoneTime: relative,
    );
    print(event.toCsvRow());
    _leftSyncEvents.add(event);
    _checkReady();
  }

  List<SyncEvent> get rightSyncEvents => _rightSyncEvents;

  List<SyncEvent> get leftSyncEvents => _leftSyncEvents;
}
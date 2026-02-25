class SyncEvent {
  final int deviceTimestamp;
  final DateTime phoneTimestamp;
  final int relativePhoneTime;
  SyncEvent({
    required this.deviceTimestamp,
    required this.phoneTimestamp,
    required this.relativePhoneTime,
  });

  List<String> toCsvRow() {
    return [
      deviceTimestamp.toString(),
      phoneTimestamp.toIso8601String(),
      relativePhoneTime.toString(),
    ];
  }
}
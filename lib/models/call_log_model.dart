enum CallStatus {
  completed,
  busy,
  noAnswer,
  failed,
}

class CallLog {
  final String id;
  final String phoneNumber;
  final DateTime dateTime;
  final CallStatus status;
  final String duration;
  final String? notes;

  CallLog({
    required this.id,
    required this.phoneNumber,
    required this.dateTime,
    required this.status,
    required this.duration,
    this.notes,
  });
}

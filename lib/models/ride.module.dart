class Ride {
  final int? id;
  final String startStreet;
  final String finalStreet;
  final int waitTime;  // in minutes
  String status;
  final DateTime startTime;  // new field

  Ride({
    this.id,
    required this.startStreet,
    required this.finalStreet,
    required this.waitTime,
    this.status = "waiting",
    required this.startTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startStreet': startStreet,
      'finalStreet': finalStreet,
      'waitTime': waitTime,
      'status': status,
      'startTime': startTime.toIso8601String(),
    };
  }

  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      id: map['id'],
      startStreet: map['startStreet'],
      finalStreet: map['finalStreet'],
      waitTime: map['waitTime'],
      status: map['status'],
      startTime: DateTime.parse(map['startTime']),
    );
  }
}

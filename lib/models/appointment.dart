class Appointment {
  final int id;
  final String date; // YYYY-MM-DD
  final String time; // HH:MM:SS
  final bool status;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }
}

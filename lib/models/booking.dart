// models/booking.dart
import 'package:face2face/models/procedure.dart';

class Booking {
  final int id;
  final Procedure procedure;
  final String cosmetologist;
  final String date;
  final String time;
  final bool status;

  Booking({
    required this.id,
    required this.procedure,
    required this.cosmetologist,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? 0,
      procedure: Procedure.fromJson(json['procedure']),
      cosmetologist: json['cosmetologist'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] != null ? json['time'].toString().substring(0, 5) : '',
      status: json['status'] ?? false,
    );
  }
}

// repository/booking_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../bloc/auth/helper/helper.dart';
import '../../models/booking.dart';

class BookingRepository {
  String? baseUrl = 'http://192.168.1.42:8000';
  final AuthStorage authStorage = AuthStorage();

  Future<List<Booking>> getUserBookings() async {
    final access = await authStorage.getAccessToken();
    if (access == null) return [];

    final response = await http.get(
      Uri.parse('$baseUrl/api/get_lists/get_user_bookings/'),
      headers: {'Authorization': 'Bearer $access'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Booking.fromJson(e)).toList();
    }

    throw Exception('Ошибка получения бронирований');
  }

  Future<List<Booking>> getCosmetologistBookings() async {
    final access = await authStorage.getAccessToken();
    if (access == null) return [];

    final response = await http.get(
      Uri.parse('$baseUrl/api/get_lists/get_cosmetologist_bookings/'),
      headers: {'Authorization': 'Bearer $access'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Booking.fromJson(e)).toList();
    }

    throw Exception('Ошибка получения бронирований косметолога');
  }

  Future<void> createBooking(int appointmentId, int procedureId) async {
    final access = await authStorage.getAccessToken();
    if (access == null) throw Exception('Неавторизованный');

    final response = await http.post(
      Uri.parse('$baseUrl/api/booking/add_booking/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
      body: jsonEncode({'appointment_id': appointmentId, 'procedure_id': procedureId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Ошибка создания бронирования: ${response.body}');
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    final access = await authStorage.getAccessToken();
    if (access == null) throw Exception('Неавторизованный');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/booking/$bookingId/cancel/'),
      headers: {'Authorization': 'Bearer $access'},
    );

    if (response.statusCode != 204) {
      throw Exception('Ошибка отмены бронирования: ${response.body}');
    }
  }
}

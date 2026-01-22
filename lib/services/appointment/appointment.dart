// repository/appointment_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../bloc/auth/helper/helper.dart';
import '../../models/appointment.dart';

class AppointmentRepository {
  String? baseUrl = 'http://192.168.1.42:8000';
  final AuthStorage authStorage = AuthStorage();

  Future<List<Appointment>> getAppointmentsByCosmetologist(int cosmetologistId) async {
    print(cosmetologistId);
    final response = await http.get(Uri.parse('$baseUrl/api/get_lists/get_appointments/$cosmetologistId/'));
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print(data);
      return data.map((e) => Appointment.fromJson(e)).toList();
    }
    throw Exception('Ошибка получения записей');
  }

  Future<void> addAppointment(String date, String time) async {
    final access = await authStorage.getAccessToken();
    if (access == null) throw Exception('Неавторизованный');

    final response = await http.post(
      Uri.parse('$baseUrl/api/appointment/add_appointment/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
      body: jsonEncode({'date': date, 'time': time}),
    );

    if (response.statusCode != 201) {
      throw Exception('Ошибка добавления записи: ${response.body}');
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    final access = await authStorage.getAccessToken();
    if (access == null) throw Exception('Неавторизованный');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/appointment/delete_appointment/$appointmentId/'),
      headers: {'Authorization': 'Bearer $access'},
    );

    if (response.statusCode != 204) {
      throw Exception('Ошибка удаления записи: ${response.body}');
    }
  }
}

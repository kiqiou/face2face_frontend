// repository/procedure_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../bloc/auth/helper/helper.dart';
import '../../models/procedure.dart';

class ProcedureRepository {
  String? baseUrl = 'http://192.168.1.42:8000';
  final AuthStorage authStorage = AuthStorage();

  Future<List<Procedure>> getProcedures() async {
    final response = await http.get(Uri.parse('$baseUrl/api/get_lists/get_procedures/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Procedure.fromJson(e)).toList();
    }
    throw Exception('Ошибка получения процедур');
  }

  Future<List<Procedure>> getProceduresByCosmetologist(int cosmetologistId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/get_lists/list_procedures_by_cosmetologist/$cosmetologistId/'));
    print(cosmetologistId);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print('$data');
      return data.map((e) => Procedure.fromJson(e)).toList();
    }
    throw Exception('Ошибка получения процедур');
  }

  Future<void> addProcedure(Map<String, dynamic> data) async {
    final access = await authStorage.getAccessToken();
    if (access == null) throw Exception('Неавторизованный');

    final response = await http.post(
      Uri.parse('$baseUrl/api/procedures/add/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Ошибка добавления процедуры: ${response.body}');
    }
  }

  Future<void> updateProcedure(int id, Map<String, dynamic> data) async {
    final access = await authStorage.getAccessToken();
    if (access == null) throw Exception('Неавторизованный');

    final response = await http.put(
      Uri.parse('$baseUrl/api/procedures/$id/update/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка обновления процедуры: ${response.body}');
    }
  }

  Future<void> deleteProcedure(int id) async {
    final access = await authStorage.getAccessToken();
    if (access == null) throw Exception('Неавторизованный');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/procedures/$id/delete/'),
      headers: {'Authorization': 'Bearer $access'},
    );

    if (response.statusCode != 204) {
      throw Exception('Ошибка удаления процедуры: ${response.body}');
    }
  }
}

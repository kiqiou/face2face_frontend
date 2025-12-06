import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../bloc/auth/helper/helper.dart';
import '../../models/cosmetologist.dart';
import '../../models/user.dart';

class UserRepository {
  String? baseUrl = 'http://192.168.1.42:8000';
  final AuthStorage authStorage;

  UserRepository({required this.authStorage});

  Future<void> sendPhone(String phone) async {
    final url = '$baseUrl/api/users/register/';
    print('Отправка запроса на: $url с номером: $phone');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      print('Ответ сервера: ${response.statusCode} ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Ошибка отправки номера: ${response.body}');
      }
    } catch (e) {
      print('Ошибка при отправке запроса: $e');
      rethrow;
    }
  }

  Future<MyUser?> confirmCode(String phone, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/confirm/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'code': code}),
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json is Map<String, dynamic>) {
        final access = json['access'];
        final refresh = json['refresh'];
        await authStorage.saveTokens( access: access, refresh: refresh);
      } else {
        throw Exception('Неправильный формат ответа сервера: $json');
      }

      return MyUser.fromJson(json['user']);
    } else {
      throw Exception('Ошибка подтверждения кода: ${response.body}');
    }
  }

  Future<void> resendCode(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/resend/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка повторной отправки: ${response.body}');
    }
  }

  Future<MyUser?> getUserFromToken() async {
    final access = await authStorage.getAccessToken();
    if (access == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me/'),
      headers: {'Authorization': 'Bearer $access'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return MyUser.fromJson(json);
    } else {
      await authStorage.clear();
      return null;
    }
  }

  Future<MyUser?> updateAvatar(String filePath) async {
    final access = await authStorage.getAccessToken();
    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('$baseUrl/api/users/avatar/'),
    )
      ..headers['Authorization'] = 'Bearer $access'
      ..files.add(await http.MultipartFile.fromPath('avatar', filePath));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final json = jsonDecode(respStr);
      return MyUser.fromJson(json['user']);
    } else {
      throw Exception('Ошибка загрузки аватара: $respStr');
    }
  }

  Future<void> logoutUser() async {
    await authStorage.clear();
  }

  Future<List<Cosmetologist>> getCosmetologists() async {
    final response = await http.get(Uri.parse('$baseUrl/api/get_lists/get_cosmetologists/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Cosmetologist.fromJson(e)).toList();
    }
    throw Exception('Ошибка получения косметологов');
  }
}

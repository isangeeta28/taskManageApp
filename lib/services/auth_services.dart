import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  final String baseUrl = 'https://reqres.in/api';

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(id: data['id'], email: email, token: data['token']);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(id: data['id'], email: email, token: data['token']);
    } else {
      throw Exception('Failed to register');
    }
  }
}

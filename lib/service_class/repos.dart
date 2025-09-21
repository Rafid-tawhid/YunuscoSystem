import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_model.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
}

class ApiUserRepository implements UserRepository {
  final String baseUrl;

  ApiUserRepository({required this.baseUrl});

  @override
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
}
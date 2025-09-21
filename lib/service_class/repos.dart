import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/test_model.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserDetails(int userId);
}

class ApiUserRepository implements UserRepository {
  final String baseUrl;

  ApiUserRepository({required this.baseUrl});

  @override
  Future<List<User>> getUsers() async {
    final headers = {
      'User-Agent': 'Dart/3.0 (dart:io)',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      print('STATUS CODE ${response.statusCode}');
      print('URL $baseUrl/users');
      print('RESPONSE ${response.body}');
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
  @override
  Future<User> getUserDetails(int userId) async {
    final headers = {
      'User-Agent': 'Dart/3.0 (dart:io)',
      'Accept': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: headers,
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user details: ${response.statusCode}');
    }
  }
}
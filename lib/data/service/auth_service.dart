import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/data/api/auth_response.dart';
import 'package:news_app/data/models/user.dart';

import 'package:news_app/data/service/token_service.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.100.63:8000';

  final TokenService _tokenService;
  AuthService(this._tokenService);

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/register');

    try {
      final response = await http
          .post(
            url,
            headers: {'Accept': 'application/json'},
            body: {'name': name, 'email': email, 'password': password},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final auth = AuthResponse.fromJson(data);

        await _tokenService.saveToken(auth.token);
        return auth;
      } else {
        throw Exception(response.body);
      }
    } on TimeoutException {
      throw Exception('Koneksi timeout. Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/login');

    try {
      final response = await http
          .post(
            url,
            headers: {'Accept': 'application/json'},
            body: {'email': email, 'password': password},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final auth = AuthResponse.fromJson(data);

        await _tokenService.saveToken(auth.token);
        return auth;
      } else {
        throw Exception(response.body);
      }
    } on TimeoutException {
      throw Exception('Koneksi timeout. Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> logout() async {
    final token = await _tokenService.getToken();
    if (token == null) {
      return;
    }

    final url = Uri.parse('$baseUrl/api/logout');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        await _tokenService.clearToken();
      } else {
        throw Exception(response.body);
      }
    } on TimeoutException {
      throw Exception('Koneksi timeout saat logout. Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat logout: $e');
    }
  }

  Future<UserModel> getUser() async {
    final token = await _tokenService.getToken();
    if (token == null) {
      throw Exception('Belum login.');
    }

    final url = Uri.parse('$baseUrl/api/user');

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else if (response.statusCode == 401) {
        await _tokenService.clearToken();
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(response.body);
      }
    } on TimeoutException {
      throw Exception('Koneksi timeout saat mengambil data user.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data user: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    return await _tokenService.hasToken();
  }
}

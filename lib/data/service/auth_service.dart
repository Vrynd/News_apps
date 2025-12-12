import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/data/models/user.dart';
import 'package:news_app/data/responses/auth_response.dart';

import 'package:news_app/core/storage/token_storage.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.100.63:8000';

  final TokenStorage _tokenStorage;

  AuthService(this._tokenStorage);

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
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: {'name': name, 'email': email, 'password': password},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final auth = AuthResponse.fromJson(data);

        await _tokenStorage.saveToken(auth.token);
        return auth;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Registrasi gagal');
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
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: {'email': email, 'password': password},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final auth = AuthResponse.fromJson(data);

        await _tokenStorage.saveToken(auth.token);
        return auth;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Login gagal');
      }
    } on TimeoutException {
      throw Exception('Koneksi timeout. Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> logout() async {
    final token = await _tokenStorage.getToken();
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
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        await _tokenStorage.clearToken();
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Logout gagal');
      }
    } on TimeoutException {
      throw Exception('Koneksi timeout saat logout. Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat logout: $e');
    }
  }

  Future<UserModel> getUser() async {
    final token = await _tokenStorage.getToken();
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
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else if (response.statusCode == 401) {
        await _tokenStorage.clearToken();
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Load user gagal');
      }
    } on TimeoutException {
      throw Exception('Koneksi timeout saat mengambil data user.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data user: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    return await _tokenStorage.hasToken();
  }

  /// Ambil daftar semua user yang terdaftar
  Future<List<UserModel>> getAllUsers() async {
    final token = await _tokenStorage.getToken();
    if (token == null) {
      throw Exception('Belum login.');
    }

    final url = Uri.parse('$baseUrl/api/users');

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Handle response format: could be { "data": [...] } or { "users": [...] } or just [...]
        final List usersList = data['data'] ?? data['users'] ?? data;
        return usersList.map((json) => UserModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        await _tokenStorage.clearToken();
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengambil daftar user');
      }
    } on TimeoutException {
      throw Exception('Koneksi timeout saat mengambil daftar user.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil daftar user: $e');
    }
  }
}

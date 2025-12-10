import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/core/api/api_exception.dart';
import 'package:news_app/core/storage/token_storage.dart';

class ApiClient {
  // base url api portal berita
  static const String baseUrl = 'http://192.168.100.63:8000/api';

  final TokenStorage _tokenStorage;
  ApiClient(this._tokenStorage);

  Future<Map<String, String>> _header({bool auth = false}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    if (auth) {
      final token = await _tokenStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  dynamic _response(http.Response response) {
    final body = response.body.isNotEmpty ? json.decode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = body is Map && body['message'] != null
        ? body['message']
        : 'Terjadi kesalahan';

    throw ApiException(message, statusCode: response.statusCode);
  }

  Future<dynamic> get(String endpoint, {bool auth = false}) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: await _header(auth: auth),
          )
          .timeout(const Duration(seconds: 10));

      return _response(response);
    } on TimeoutException {
      throw ApiException('Koneksi timeout. Silakan coba lagi.');
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: await _header(auth: auth),
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      return _response(response);
    } on TimeoutException {
      throw ApiException('Koneksi timeout, silakan coba lagi.');
    }
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: await _header(auth: auth),
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      return _response(response);
    } on TimeoutException {
      throw ApiException('Koneksi timeout, silakan coba lagi.');
    }
  }

  Future<dynamic> delete(String endpoint, {bool auth = false}) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: await _header(auth: auth),
          )
          .timeout(const Duration(seconds: 10));

      return _response(response);
    } on TimeoutException {
      throw ApiException('Koneksi timeout');
    }
  }
}

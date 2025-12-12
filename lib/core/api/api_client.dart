import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/core/api/api_exception.dart';
import 'package:news_app/core/storage/token_storage.dart';

class ApiClient {
  // base url api portal berita
  // Base URL API portal berita - pastikan IP sama dengan auth_service.dart
  static const String baseUrl = 'http://192.168.100.63:8000/api';

  final TokenStorage _tokenStorage;
  ApiClient(this._tokenStorage);

  Future<Map<String, String>> _header({bool auth = false}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',  // Changed from x-www-form-urlencoded
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
      debugPrint('POST $baseUrl$endpoint');
      debugPrint('Body: $body');
      
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: await _header(auth: auth),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      
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
            body: body != null ? json.encode(body) : null,
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

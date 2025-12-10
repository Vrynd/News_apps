import 'package:news_app/data/models/user.dart';

class AuthResponse {
  final String message;
  final String token;
  final UserModel user;

  AuthResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}

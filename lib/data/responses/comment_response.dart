import 'package:news_app/data/models/comment_model.dart';

/// Response wrapper untuk single comment dari API
class CommentResponse {
  final String message;
  final CommentModel comment;

  CommentResponse({
    required this.message,
    required this.comment,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      message: json['message'] ?? '',
      comment: CommentModel.fromJson(json['comment'] ?? json['data'] ?? json),
    );
  }
}

/// Response wrapper untuk list comments dari API
class CommentListResponse {
  final String? message;
  final List<CommentModel> comments;

  CommentListResponse({
    this.message,
    required this.comments,
  });

  factory CommentListResponse.fromJson(dynamic json) {
    List<dynamic> data;
    String? message;
    
    if (json is List) {
      data = json;
    } else if (json is Map<String, dynamic>) {
      message = json['message'];
      data = json['data'] ?? json['comments'] ?? [];
    } else {
      data = [];
    }
    
    return CommentListResponse(
      message: message,
      comments: data.map((item) => CommentModel.fromJson(item)).toList(),
    );
  }
}

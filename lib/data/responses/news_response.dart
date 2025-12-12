import 'package:news_app/data/models/news_model.dart';

/// Response wrapper untuk single news dari API
class NewsResponse {
  final String message;
  final NewsModel news;

  NewsResponse({
    required this.message,
    required this.news,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      message: json['message'] ?? '',
      news: NewsModel.fromJson(json['news'] ?? json['data'] ?? json),
    );
  }
}

/// Response wrapper untuk list news dari API
class NewsListResponse {
  final String? message;
  final List<NewsModel> news;

  NewsListResponse({
    this.message,
    required this.news,
  });

  factory NewsListResponse.fromJson(dynamic json) {
    List<dynamic> data;
    String? message;
    
    if (json is List) {
      data = json;
    } else if (json is Map<String, dynamic>) {
      message = json['message'];
      data = json['data'] ?? json['news'] ?? [];
    } else {
      data = [];
    }
    
    return NewsListResponse(
      message: message,
      news: data.map((item) => NewsModel.fromJson(item)).toList(),
    );
  }
}

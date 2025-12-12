import 'package:flutter/foundation.dart';
import 'package:news_app/data/models/news_model.dart';
import 'package:news_app/data/models/comment_model.dart';
import 'package:news_app/data/responses/news_response.dart';
import 'package:news_app/data/responses/comment_response.dart';
import 'package:news_app/core/api/api_client.dart';
import 'package:news_app/core/storage/token_storage.dart';

/// Service untuk operasi berita dengan API.
class NewsService {
  final ApiClient _apiClient;

  NewsService(this._apiClient);

  /// Factory constructor untuk production dengan API
  factory NewsService.withApi(TokenStorage tokenStorage) {
    return NewsService(ApiClient(tokenStorage));
  }

  /// Ambil semua berita
  Future<List<NewsModel>> getNewsList({String? category}) async {
    final response = await _apiClient.get('/news', auth: true);
    final newsListResponse = NewsListResponse.fromJson(response);
    
    // Filter by category jika diperlukan
    if (category != null && category != 'Semua') {
      return newsListResponse.news.where((n) => n.category == category).toList();
    }
    return newsListResponse.news;
  }

  /// Ambil detail berita
  Future<NewsModel> getNewsDetail(int id) async {
    final response = await _apiClient.get('/news/$id', auth: true);
    final newsResponse = NewsResponse.fromJson(response);
    return newsResponse.news;
  }

  /// Buat berita baru
  Future<NewsModel> createNews({
    required String title,
    required String content,
    required String category,
    String? imageUrl,
    String? author,
  }) async {
    // Gunakan gambar placeholder jika tidak ada image URL
    final placeholderImage = 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/800/400';
    
    final response = await _apiClient.post(
      '/news',
      body: {
        'title': title,
        'content': content,
        'category': category,
        'image': imageUrl?.isNotEmpty == true ? imageUrl : placeholderImage,
      },
      auth: true,
    );
    final newsResponse = NewsResponse.fromJson(response);
    return newsResponse.news;
  }

  /// Update berita
  Future<NewsModel> updateNews({
    required int newsId,
    required String title,
    required String content,
    required String category,
    String? imageUrl,
  }) async {
    final response = await _apiClient.put(
      '/news/$newsId',
      body: {
        'title': title,
        'content': content,
        'category': category,
        if (imageUrl != null && imageUrl.isNotEmpty) 'image': imageUrl,
      },
      auth: true,
    );
    final newsResponse = NewsResponse.fromJson(response);
    return newsResponse.news;
  }

  /// Hapus berita
  Future<void> deleteNews(int newsId) async {
    debugPrint('Deleting news with ID: $newsId');
    await _apiClient.delete('/news/$newsId', auth: true);
  }

  /// Ambil berita berdasarkan user ID
  Future<List<NewsModel>> getNewsByUserId(int userId) async {
    final allNews = await getNewsList();
    return allNews.where((n) => n.userId == userId).toList();
  }

  // ========== Comment Methods ==========

  /// Ambil komentar berita
  Future<List<CommentModel>> getComments(int newsId) async {
    debugPrint('Fetching comments for news $newsId');
    final response = await _apiClient.get('/news/$newsId/comments', auth: false);
    debugPrint('Comments response: $response');
    
    final commentListResponse = CommentListResponse.fromJson(response);
    return commentListResponse.comments;
  }

  /// Tambah komentar
  Future<CommentModel> addComment({
    required int newsId,
    required String content,
    required int userId,
    required String userName,
  }) async {
    debugPrint('Adding comment to news $newsId: $content');
    final response = await _apiClient.post(
      '/news/$newsId/comments',
      body: {
        'comment': content,
      },
      auth: true,
    );
    debugPrint('Add comment response: $response');
    
    final commentResponse = CommentResponse.fromJson(response);
    return commentResponse.comment;
  }

  /// Hapus komentar
  Future<void> deleteComment({
    required int newsId,
    required int commentId,
  }) async {
    await _apiClient.delete('/comments/$commentId', auth: true);
  }

  /// Share news (untuk tracking)
  Future<void> shareNews(int newsId) async {
    debugPrint('Sharing news with ID: $newsId');
  }
}

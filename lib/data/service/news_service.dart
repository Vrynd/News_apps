import 'dart:async';
import 'package:news_app/data/models/news_model.dart';
import 'package:news_app/data/models/comment_model.dart';
import 'package:news_app/core/api/api_client.dart';
import 'package:news_app/core/storage/token_storage.dart';

/// Service untuk operasi berita.
/// Dengan flag `useDummyData` bisa switch antara data dummy dan API.
class NewsService {
  final ApiClient? _apiClient;
  final bool useDummyData;

  // Dummy data storage untuk simulasi
  static final List<NewsModel> _dummyNews = NewsModel.getDummyNews();
  static final Map<int, List<CommentModel>> _dummyComments = {};
  static int _nextNewsId = 100;
  static int _nextCommentId = 100;

  NewsService({
    ApiClient? apiClient,
    this.useDummyData = true,
  }) : _apiClient = apiClient;

  // Factory constructor untuk production dengan API
  factory NewsService.withApi(TokenStorage tokenStorage) {
    return NewsService(
      apiClient: ApiClient(tokenStorage),
      useDummyData: false,
    );
  }

  // Factory constructor untuk development dengan data dummy
  factory NewsService.dummy() {
    return NewsService(useDummyData: true);
  }

  /// Ambil semua berita
  Future<List<NewsModel>> getNewsList({String? category}) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulasi network
      if (category == null || category == 'Semua') {
        return List.from(_dummyNews);
      }
      return _dummyNews.where((n) => n.category == category).toList();
    }

    // API call
    final response = await _apiClient!.get('/news', auth: true);
    final List data = response['data'] ?? response;
    return data.map((json) => NewsModel.fromJson(json)).toList();
  }

  /// Ambil detail berita
  Future<NewsModel> getNewsDetail(int id) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _dummyNews.firstWhere(
        (n) => n.id == id,
        orElse: () => throw Exception('Berita tidak ditemukan'),
      );
    }

    final response = await _apiClient!.get('/news/$id', auth: true);
    return NewsModel.fromJson(response['data'] ?? response);
  }

  /// Buat berita baru
  Future<NewsModel> createNews({
    required String title,
    required String content,
    required String category,
    required String imageUrl,
    required String author,
  }) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 500));
      final newNews = NewsModel(
        id: _nextNewsId++,
        title: title,
        content: content,
        category: category,
        imageUrl: imageUrl.isEmpty 
            ? 'https://picsum.photos/seed/news$_nextNewsId/800/400'
            : imageUrl,
        author: author,
        createdAt: DateTime.now(),
        commentsCount: 0,
        sharesCount: 0,
        likesCount: 0,
      );
      _dummyNews.insert(0, newNews);
      return newNews;
    }

    final response = await _apiClient!.post(
      '/news',
      body: {
        'title': title,
        'content': content,
        'category': category,
        'image_url': imageUrl,
        'author': author,
      },
      auth: true,
    );
    return NewsModel.fromJson(response['data'] ?? response);
  }

  /// Ambil komentar berita
  Future<List<CommentModel>> getComments(int newsId) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!_dummyComments.containsKey(newsId)) {
        _dummyComments[newsId] = CommentModel.getDummyComments(newsId);
      }
      return List.from(_dummyComments[newsId]!);
    }

    final response = await _apiClient!.get('/news/$newsId/comments', auth: true);
    final List data = response['data'] ?? response;
    return data.map((json) => CommentModel.fromJson(json)).toList();
  }

  /// Tambah komentar
  Future<CommentModel> addComment({
    required int newsId,
    required String content,
    required int userId,
    required String userName,
  }) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 300));
      final comment = CommentModel(
        id: _nextCommentId++,
        newsId: newsId,
        userId: userId,
        userName: userName,
        content: content,
        createdAt: DateTime.now(),
      );
      
      if (!_dummyComments.containsKey(newsId)) {
        _dummyComments[newsId] = [];
      }
      _dummyComments[newsId]!.insert(0, comment);
      
      // Update comment count
      final newsIndex = _dummyNews.indexWhere((n) => n.id == newsId);
      if (newsIndex != -1) {
        _dummyNews[newsIndex] = _dummyNews[newsIndex].copyWith(
          commentsCount: _dummyNews[newsIndex].commentsCount + 1,
        );
      }
      
      return comment;
    }

    final response = await _apiClient!.post(
      '/news/$newsId/comments',
      body: {
        'content': content,
      },
      auth: true,
    );
    return CommentModel.fromJson(response['data'] ?? response);
  }

  /// Increment share count (dummy only)
  Future<void> shareNews(int newsId) async {
    if (useDummyData) {
      final index = _dummyNews.indexWhere((n) => n.id == newsId);
      if (index != -1) {
        _dummyNews[index] = _dummyNews[index].copyWith(
          sharesCount: _dummyNews[index].sharesCount + 1,
        );
      }
    }
    // For API, share tracking might be handled differently
  }

  /// Increment like count (dummy only)
  Future<void> likeNews(int newsId) async {
    if (useDummyData) {
      final index = _dummyNews.indexWhere((n) => n.id == newsId);
      if (index != -1) {
        _dummyNews[index] = _dummyNews[index].copyWith(
          likesCount: _dummyNews[index].likesCount + 1,
        );
      }
    }
  }
  
  /// Hitung total berita yang dibuat user tertentu
  int getNewsCountByAuthor(String author) {
    return _dummyNews.where((n) => n.author == author).length;
  }

  /// Hitung total komentar user
  int getCommentCountByUser(int userId) {
    int count = 0;
    for (var comments in _dummyComments.values) {
      count += comments.where((c) => c.userId == userId).length;
    }
    return count;
  }

  /// Edit komentar
  Future<CommentModel> editComment({
    required int newsId,
    required int commentId,
    required String newContent,
  }) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (_dummyComments.containsKey(newsId)) {
        final index = _dummyComments[newsId]!.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          final updatedComment = CommentModel(
            id: _dummyComments[newsId]![index].id,
            newsId: newsId,
            userId: _dummyComments[newsId]![index].userId,
            userName: _dummyComments[newsId]![index].userName,
            content: newContent,
            createdAt: _dummyComments[newsId]![index].createdAt,
          );
          _dummyComments[newsId]![index] = updatedComment;
          return updatedComment;
        }
      }
      throw Exception('Komentar tidak ditemukan');
    }

    final response = await _apiClient!.put(
      '/news/$newsId/comments/$commentId',
      body: {'content': newContent},
      auth: true,
    );
    return CommentModel.fromJson(response['data'] ?? response);
  }

  /// Hapus komentar
  Future<void> deleteComment({
    required int newsId,
    required int commentId,
  }) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (_dummyComments.containsKey(newsId)) {
        _dummyComments[newsId]!.removeWhere((c) => c.id == commentId);
        
        // Update comment count
        final newsIndex = _dummyNews.indexWhere((n) => n.id == newsId);
        if (newsIndex != -1) {
          _dummyNews[newsIndex] = _dummyNews[newsIndex].copyWith(
            commentsCount: _dummyNews[newsIndex].commentsCount - 1,
          );
        }
      }
      return;
    }

    await _apiClient!.delete('/news/$newsId/comments/$commentId', auth: true);
  }
}

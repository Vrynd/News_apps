class NewsModel {
  final int id;
  final int? userId;
  final String title;
  final String content;
  final String category;
  final String imageUrl;
  final String author;
  final DateTime createdAt;
  final int commentsCount;
  final int sharesCount;
  final int likesCount;

  // Static list of available categories
  static const List<String> categories = [
    'Semua',
    'Teknologi',
    'Bisnis',
    'Olahraga',
    'Hiburan',
    'Nasional',
    'Internasional',
  ];

  NewsModel({
    required this.id,
    this.userId,
    required this.title,
    required this.content,
    required this.category,
    required this.imageUrl,
    required this.author,
    required this.createdAt,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.likesCount = 0,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    // Hitung jumlah komentar dari array 'comments' jika ada
    int commentsCount = 0;
    if (json['comments'] != null && json['comments'] is List) {
      commentsCount = (json['comments'] as List).length;
    } else {
      commentsCount = json['comments_count'] ?? 0;
    }

    return NewsModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['user_id'] != null 
          ? (json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()))
          : null,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      // Support both 'image' (API) and 'image_url' (legacy)
      imageUrl: json['image'] ?? json['image_url'] ?? json['imageUrl'] ?? '',
      author: json['author'] ?? (json['user'] != null ? json['user']['name'] : '') ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      commentsCount: commentsCount,
      sharesCount: json['shares_count'] ?? 0,
      likesCount: json['views'] ?? json['likes_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'image_url': imageUrl,
      'author': author,
      'created_at': createdAt.toIso8601String(),
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'likes_count': likesCount,
    };
  }

  NewsModel copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    String? imageUrl,
    String? author,
    DateTime? createdAt,
    int? commentsCount,
    int? sharesCount,
    int? likesCount,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      likesCount: likesCount ?? this.likesCount,
    );
  }
}

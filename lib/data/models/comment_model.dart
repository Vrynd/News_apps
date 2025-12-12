class CommentModel {
  final int id;
  final int newsId;
  final int userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.newsId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      newsId: json['news_id'] ?? json['newsId'] ?? 0,
      userId: json['user_id'] ?? json['userId'] ?? 0,
      userName: json['user_name'] ?? json['userName'] ?? 'Anonymous',
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'news_id': newsId,
      'user_id': userId,
      'user_name': userName,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Dummy comments untuk development
  static List<CommentModel> getDummyComments(int newsId) {
    final dummyData = <CommentModel>[
      CommentModel(
        id: 1,
        newsId: newsId,
        userId: 1,
        userName: 'Andi Pratama',
        content: 'Berita yang sangat informatif! Terima kasih sudah berbagi.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      CommentModel(
        id: 2,
        newsId: newsId,
        userId: 2,
        userName: 'Putri Lestari',
        content: 'Semoga perkembangan ini terus berlanjut ke arah yang positif.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      CommentModel(
        id: 3,
        newsId: newsId,
        userId: 3,
        userName: 'Rudi Hermawan',
        content: 'Menarik sekali! Saya akan share ke teman-teman.',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CommentModel(
        id: 4,
        newsId: newsId,
        userId: 4,
        userName: 'Maya Sari',
        content: 'Kapan ada update selanjutnya tentang topik ini?',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      CommentModel(
        id: 5,
        newsId: newsId,
        userId: 5,
        userName: 'Doni Setiawan',
        content: 'Saya setuju dengan poin-poin yang disampaikan di artikel ini.',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ];
    
    return dummyData;
  }

  // Format waktu relatif
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays > 7) {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} hari lalu';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
}

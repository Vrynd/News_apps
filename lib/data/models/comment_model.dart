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
    // Handle userName dari berbagai format response
    String userName = 'Anonymous';
    if (json['user_name'] != null) {
      userName = json['user_name'].toString();
    } else if (json['userName'] != null) {
      userName = json['userName'].toString();
    } else if (json['user'] != null && json['user'] is Map) {
      userName = json['user']['name']?.toString() ?? 'Anonymous';
    }

    // Helper untuk parse int dari berbagai tipe
    int parseIntValue(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    return CommentModel(
      id: parseIntValue(json['id']),
      newsId: parseIntValue(json['news_id'] ?? json['newsId']),
      userId: parseIntValue(json['user_id'] ?? json['userId']),
      userName: userName,
      // API returns 'comment' not 'content'
      content: (json['comment'] ?? json['content'])?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
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

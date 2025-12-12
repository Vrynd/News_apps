import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:news_app/data/models/news_model.dart';
import 'package:news_app/data/models/comment_model.dart';
import 'package:news_app/data/models/user.dart';
import 'package:news_app/data/service/news_service.dart';
import 'package:news_app/data/service/auth_service.dart';
import 'package:news_app/data/service/bookmark_service.dart';
import 'package:news_app/core/storage/token_storage.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsModel news;

  const NewsDetailPage({super.key, required this.news});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final TokenStorage _tokenStorage = TokenStorage();
  late final NewsService _newsService;
  late final AuthService _authService;
  final BookmarkService _bookmarkService = BookmarkService();
  final TextEditingController _commentController = TextEditingController();

  List<CommentModel> _comments = [];
  bool _isLoadingComments = true;
  bool _isBookmarked = false;
  late NewsModel _news;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _newsService = NewsService.withApi(_tokenStorage);
    _authService = AuthService(_tokenStorage);
    _news = widget.news;
    _isBookmarked = _bookmarkService.isBookmarked(_news.id);
    _loadCurrentUser();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getUser();
      if (mounted) {
        setState(() => _currentUser = user);
      }
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  Future<void> _loadComments() async {
    try {
      final comments = await _newsService.getComments(_news.id);
      setState(() {
        _comments = comments;
        _isLoadingComments = false;
      });
    } catch (e) {
      debugPrint('Error loading comments: $e');
      setState(() => _isLoadingComments = false);
    }
  }

  Future<void> _addComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu untuk berkomentar')),
      );
      return;
    }

    try {
      final comment = await _newsService.addComment(
        newsId: _news.id,
        content: content,
        userId: _currentUser!.id,
        userName: _currentUser!.name,
      );
      
      setState(() {
        _comments.insert(0, comment);
        _news = _news.copyWith(commentsCount: _news.commentsCount + 1);
      });
      _commentController.clear();
      FocusScope.of(context).unfocus();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Komentar berhasil ditambahkan'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      debugPrint('Error adding comment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteComment(CommentModel comment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Komentar?'),
        content: const Text('Komentar ini akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    try {
      await _newsService.deleteComment(
        newsId: _news.id,
        commentId: comment.id,
      );
      
      setState(() {
        _comments.removeWhere((c) => c.id == comment.id);
        _news = _news.copyWith(commentsCount: _news.commentsCount - 1);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Komentar berhasil dihapus'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _toggleBookmark() {
    _isBookmarked = _bookmarkService.toggleBookmark(_news);
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked ? 'Ditambahkan ke bookmark' : 'Dihapus dari bookmark',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _shareNews() async {
    await _newsService.shareNews(_news.id);
    await Share.share(
      '${_news.title}\n\nBaca selengkapnya di aplikasi News App',
      subject: _news.title,
    );
    setState(() {
      _news = _news.copyWith(sharesCount: _news.sharesCount + 1);
    });
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.network(
              _news.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: colorScheme.primary.withOpacity(0.2),
                child: Icon(
                  LucideIcons.image,
                  size: 64,
                  color: colorScheme.primary.withOpacity(0.5),
                ),
              ),
            ),
          ),

          // Content dengan rounded top
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.32,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Date
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _news.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          LucideIcons.calendar,
                          size: 14,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(_news.createdAt),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Title
                    Text(
                      _news.title,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Author
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              _news.author.isNotEmpty ? _news.author[0].toUpperCase() : 'A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _news.author,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Penulis',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Stats Row
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(icon: LucideIcons.heart, count: _news.likesCount, label: 'Likes'),
                          _StatItem(icon: LucideIcons.messageCircle, count: _news.commentsCount, label: 'Komentar'),
                          _StatItem(icon: LucideIcons.share2, count: _news.sharesCount, label: 'Share'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Content
                    Text(
                      _news.content,
                      style: textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        color: colorScheme.onSurface.withOpacity(0.85),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Comments Section
                    Row(
                      children: [
                        Icon(LucideIcons.messageCircle, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Komentar (${_news.commentsCount})',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Comment Input
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: 'Tulis komentar...',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _addComment,
                            icon: Icon(LucideIcons.send, color: colorScheme.primary),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Comments List
                    if (_isLoadingComments)
                      const Center(child: CircularProgressIndicator())
                    else if (_comments.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Belum ada komentar',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _comments.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          // Check if current user owns this comment
                          final isOwner = _currentUser != null && comment.userId == _currentUser!.id;
                          return _CommentCard(
                            comment: comment,
                            isOwner: isOwner,
                            onDelete: isOwner ? () => _deleteComment(comment) : null,
                          );
                        },
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),

          // Top Actions
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              children: [
                _ActionButton(
                  icon: LucideIcons.arrowLeft,
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                _ActionButton(
                  icon: _isBookmarked ? LucideIcons.bookmarkMinus : LucideIcons.bookmark,
                  onTap: _toggleBookmark,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: LucideIcons.share2,
                  onTap: _shareNews,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const _StatItem({
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Icon(icon, color: colorScheme.primary, size: 22),
        const SizedBox(height: 6),
        Text(
          count >= 1000 ? '${(count / 1000).toStringAsFixed(1)}K' : count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  final CommentModel comment;
  final bool isOwner;
  final VoidCallback? onDelete;

  const _CommentCard({
    required this.comment,
    required this.isOwner,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    comment.userName.isNotEmpty ? comment.userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.userName,
                          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (isOwner) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Anda',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      comment.timeAgo,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Delete button - hanya tampil jika owner
              if (isOwner && onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    LucideIcons.trash2,
                    size: 18,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  tooltip: 'Hapus komentar',
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.content,
            style: textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}

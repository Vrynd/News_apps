import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:news_app/core/storage/token_storage.dart';
import 'package:news_app/data/models/user.dart';
import 'package:news_app/data/service/auth_service.dart';
import 'package:news_app/data/service/news_service.dart';
import 'package:news_app/data/service/bookmark_service.dart';
import 'package:news_app/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TokenStorage _tokenStorage = TokenStorage();
  late final AuthService _authService;
  final NewsService _newsService = NewsService.dummy();
  final BookmarkService _bookmarkService = BookmarkService();

  UserModel? _user;
  bool _isLoading = true;
  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(_tokenStorage);
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final hasToken = await _tokenStorage.hasToken();
      if (!hasToken) {
        setState(() {
          _isAnonymous = true;
          _isLoading = false;
        });
        return;
      }

      final user = await _authService.getUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isAnonymous = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _tokenStorage.clearToken();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPageView()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Unified layout untuk anonymous dan logged in user
    final userName = _isAnonymous ? 'Pengguna Anonim' : (_user?.name ?? 'User');
    final userEmail = _isAnonymous ? 'Belum login' : (_user?.email ?? '');
    final newsCount = _isAnonymous ? 0 : _newsService.getNewsCountByAuthor(userName);
    final commentCount = _isAnonymous ? 0 : _newsService.getCommentCountByUser(_user?.id ?? 0);
    final bookmarkCount = _bookmarkService.count;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Profile',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              // Profile Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Login button for anonymous
                    if (_isAnonymous)
                      FilledButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPageView()),
                        ),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        child: const Text('Login'),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats Row
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(icon: LucideIcons.newspaper, count: newsCount, label: 'Berita', color: colorScheme.primary),
                    Container(width: 1, height: 40, color: colorScheme.outline.withOpacity(0.2)),
                    _StatItem(icon: LucideIcons.messageCircle, count: commentCount, label: 'Komentar', color: Colors.orange),
                    Container(width: 1, height: 40, color: colorScheme.outline.withOpacity(0.2)),
                    _StatItem(icon: LucideIcons.bookmark, count: bookmarkCount, label: 'Saved', color: Colors.pink),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Menu
              Text(
                'Menu',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              
              const SizedBox(height: 12),

              _MenuCard(
                icon: LucideIcons.user,
                title: 'Edit Profile',
                subtitle: 'Ubah nama dan foto profil',
                color: Colors.blue,
                colorScheme: colorScheme,
                onTap: () => _isAnonymous 
                    ? _showLoginRequired(context) 
                    : _showComingSoon(context),
              ),

              const SizedBox(height: 10),

              _MenuCard(
                icon: LucideIcons.fileEdit,
                title: 'Kelola Berita',
                subtitle: 'Edit atau hapus berita kamu',
                color: Colors.orange,
                colorScheme: colorScheme,
                onTap: () => _isAnonymous 
                    ? _showLoginRequired(context) 
                    : _showManageNewsDialog(context, userName),
              ),

              const SizedBox(height: 10),

              _MenuCard(
                icon: LucideIcons.info,
                title: 'Tentang Aplikasi',
                subtitle: 'Versi dan informasi aplikasi',
                color: Colors.indigo,
                colorScheme: colorScheme,
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'News App',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 News App. All rights reserved.',
                ),
              ),

              // Logout only for logged in users
              if (!_isAnonymous) ...[
                const SizedBox(height: 10),
                _MenuCard(
                  icon: LucideIcons.logOut,
                  title: 'Logout',
                  subtitle: 'Keluar dari akun',
                  color: Colors.red,
                  colorScheme: colorScheme,
                  onTap: _logout,
                ),
              ],

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fitur segera hadir!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLoginRequired(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Silakan login terlebih dahulu'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPageView()),
          ),
        ),
      ),
    );
  }

  void _showManageNewsDialog(BuildContext context, String userName) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    final allNews = await _newsService.getNewsList();
    final userNews = allNews.where((n) => n.author == userName).toList();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(LucideIcons.newspaper, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Kelola Berita',
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '${userNews.length} berita',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              
              Divider(color: colorScheme.outline.withOpacity(0.1)),
              
              Expanded(
                child: userNews.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.fileX, size: 48, color: colorScheme.primary.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text('Belum ada berita', style: textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              'Buat berita pertamamu di tab Buat',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: userNews.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final news = userNews[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  news.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60,
                                    height: 60,
                                    color: colorScheme.primary.withOpacity(0.1),
                                    child: Icon(LucideIcons.image, color: colorScheme.primary),
                                  ),
                                ),
                              ),
                              title: Text(
                                news.title,
                                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  news.category,
                                  style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
                                ),
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: Icon(LucideIcons.moreVertical, color: colorScheme.onSurface.withOpacity(0.5)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                onSelected: (value) async {
                                  Navigator.pop(context);
                                  if (value == 'edit') {
                                    _showComingSoon(this.context);
                                  } else if (value == 'delete') {
                                    _confirmDeleteNews(this.context, news);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(LucideIcons.edit, size: 18, color: colorScheme.primary),
                                        const SizedBox(width: 10),
                                        const Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(LucideIcons.trash2, size: 18, color: Colors.red),
                                        SizedBox(width: 10),
                                        Text('Hapus', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteNews(BuildContext context, dynamic news) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Berita?'),
        content: Text('Berita "${news.title}" akan dihapus permanen.'),
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

    if (confirm == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Berita berhasil dihapus'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      setState(() {});
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    LucideIcons.chevronRight,
                    color: colorScheme.onSurface.withOpacity(0.4),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

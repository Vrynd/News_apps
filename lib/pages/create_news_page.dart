import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:news_app/data/models/news_model.dart';
import 'package:news_app/data/models/user.dart';
import 'package:news_app/data/service/news_service.dart';
import 'package:news_app/data/service/auth_service.dart';
import 'package:news_app/core/storage/token_storage.dart';
import 'package:news_app/utils/helper/toast.dart';

class CreateNewsPage extends StatefulWidget {
  const CreateNewsPage({super.key});

  @override
  State<CreateNewsPage> createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  final _formKey = GlobalKey<FormState>();
  final TokenStorage _tokenStorage = TokenStorage();
  late final NewsService _newsService;
  late final AuthService _authService;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedCategory = 'Teknologi';
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _newsService = NewsService.withApi(_tokenStorage);
    _authService = AuthService(_tokenStorage);
    _loadCurrentUser();
  }

  /// Mengambil data user yang sedang login
  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoadingUser = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingUser = false);
        ToastHelper.error(context, 'Gagal memuat data penulis');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitNews() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    if (_currentUser == null) {
      ToastHelper.error(context, 'Data penulis tidak tersedia');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _newsService.createNews(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _selectedCategory,
        imageUrl: _imageUrlController.text.trim(),
        author: _currentUser!.name,
      );

      if (!mounted) return;
      
      ToastHelper.success(context, 'Berita berhasil dipublikasikan!');
      
      _titleController.clear();
      _contentController.clear();
      _imageUrlController.clear();
      setState(() => _selectedCategory = 'Teknologi');
    } catch (e) {
      if (!mounted) return;
      ToastHelper.error(context, 'Gagal membuat berita: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categories = NewsModel.categories.where((c) => c != 'Semua').toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Buat Berita',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bagikan cerita menarikmu ke dunia',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 24),

                // Image Preview Card
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.2),
                        width: 2,
                      ),
                      image: _imageUrlController.text.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(_imageUrlController.text),
                              fit: BoxFit.cover,
                              onError: (_, __) {},
                            )
                          : null,
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  LucideIcons.imagePlus,
                                  size: 32,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tambahkan Gambar',
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Masukkan URL gambar di bawah',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 24),

                // Form Section Title
                _SectionTitle(icon: LucideIcons.newspaper, title: 'Detail Berita'),
                
                const SizedBox(height: 12),

                // Image URL
                _RoundedTextField(
                  controller: _imageUrlController,
                  label: 'URL Gambar',
                  hint: 'https://example.com/image.jpg',
                  prefixIcon: LucideIcons.image,
                  colorScheme: colorScheme,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 12),

                // Title
                _RoundedTextField(
                  controller: _titleController,
                  label: 'Judul Berita',
                  hint: 'Tulis judul yang menarik',
                  prefixIcon: LucideIcons.text,
                  colorScheme: colorScheme,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Judul tidak boleh kosong';
                    if (value!.length < 10) return 'Judul minimal 10 karakter';
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Author Field (Read-only, auto-filled from logged in user)
                Container(
                  key: ValueKey('author_$_isLoadingUser'),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: _isLoadingUser 
                        ? 'Memuat...' 
                        : (_currentUser?.name ?? 'Tidak tersedia'),
                    decoration: InputDecoration(
                      labelText: 'Nama Penulis',
                      prefixIcon: Icon(LucideIcons.userCircle, color: colorScheme.primary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Category Tags
                _SectionTitle(icon: LucideIcons.tags, title: 'Pilih Kategori'),
                
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? colorScheme.primary 
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected 
                                ? colorScheme.primary 
                                : colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          category,
                          style: textTheme.bodyMedium?.copyWith(
                            color: isSelected ? Colors.white : colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Content Section
                _SectionTitle(icon: LucideIcons.fileText, title: 'Isi Berita'),

                const SizedBox(height: 12),

                // Content Field
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: _contentController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: 'Tulis isi berita kamu di sini...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Konten tidak boleh kosong';
                      if (value!.length < 50) return 'Konten minimal 50 karakter';
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submitNews,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(LucideIcons.upload, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Publish Berita',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final ColorScheme colorScheme;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const _RoundedTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.colorScheme,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(prefixIcon, color: colorScheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}

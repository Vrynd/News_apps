import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:news_app/data/models/news_model.dart';
import 'package:news_app/data/service/news_service.dart';
import 'package:news_app/core/storage/token_storage.dart';
import 'package:news_app/utils/helper/toast.dart';

class EditNewsPage extends StatefulWidget {
  final NewsModel news;
  
  const EditNewsPage({super.key, required this.news});

  @override
  State<EditNewsPage> createState() => _EditNewsPageState();
}

class _EditNewsPageState extends State<EditNewsPage> {
  final _formKey = GlobalKey<FormState>();
  final NewsService _newsService = NewsService.withApi(TokenStorage());

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _imageUrlController;

  late String _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.news.title);
    _contentController = TextEditingController(text: widget.news.content);
    _imageUrlController = TextEditingController(text: widget.news.imageUrl);
    _selectedCategory = widget.news.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await _newsService.updateNews(
        newsId: widget.news.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _selectedCategory,
        imageUrl: _imageUrlController.text.trim(),
      );

      if (!mounted) return;
      
      ToastHelper.success(context, 'Berita berhasil diperbarui!');
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      if (!mounted) return;
      ToastHelper.error(context, 'Gagal memperbarui berita: $e');
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
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          'Edit Berita',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Preview Card
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    image: _imageUrlController.text.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(_imageUrlController.text),
                            fit: BoxFit.cover,
                            onError: (_, __) {},
                          )
                        : null,
                  ),
                  child: _imageUrlController.text.isEmpty
                      ? Center(
                          child: Icon(
                            LucideIcons.imagePlus,
                            size: 40,
                            color: colorScheme.primary.withOpacity(0.5),
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 20),

                // Image URL
                _buildTextField(
                  controller: _imageUrlController,
                  label: 'URL Gambar',
                  hint: 'https://example.com/image.jpg',
                  icon: LucideIcons.image,
                  colorScheme: colorScheme,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 12),

                // Title
                _buildTextField(
                  controller: _titleController,
                  label: 'Judul Berita',
                  hint: 'Tulis judul yang menarik',
                  icon: LucideIcons.text,
                  colorScheme: colorScheme,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Judul tidak boleh kosong';
                    if (value!.length < 10) return 'Judul minimal 10 karakter';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Category
                Text(
                  'Kategori',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                
                const SizedBox(height: 10),

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

                const SizedBox(height: 20),

                // Content
                Text(
                  'Isi Berita',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: _contentController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Tulis isi berita...',
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

                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submitUpdate,
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
                              const Icon(LucideIcons.save, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Simpan Perubahan',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ColorScheme colorScheme,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
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
          prefixIcon: Icon(icon, color: colorScheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}

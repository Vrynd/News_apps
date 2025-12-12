import 'package:news_app/data/models/news_model.dart';

/// Service untuk mengelola bookmark berita.
/// Menggunakan in-memory storage (bisa dikembangkan ke SQLite/SharedPrefs)
class BookmarkService {
  // Singleton pattern untuk shared state
  static final BookmarkService _instance = BookmarkService._internal();
  factory BookmarkService() => _instance;
  BookmarkService._internal();

  // In-memory storage untuk bookmarks
  final List<NewsModel> _bookmarks = [];
  
  // Listeners untuk notifikasi perubahan
  final List<Function()> _listeners = [];

  /// Tambah listener untuk update UI
  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  /// Hapus listener
  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  /// Notify semua listener
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  /// Ambil semua bookmark
  List<NewsModel> getBookmarks() {
    return List.unmodifiable(_bookmarks);
  }

  /// Cek apakah berita sudah di-bookmark
  bool isBookmarked(int newsId) {
    return _bookmarks.any((n) => n.id == newsId);
  }

  /// Toggle bookmark (tambah jika belum ada, hapus jika sudah ada)
  bool toggleBookmark(NewsModel news) {
    if (isBookmarked(news.id)) {
      removeBookmark(news.id);
      return false;
    } else {
      addBookmark(news);
      return true;
    }
  }

  /// Tambah ke bookmark
  void addBookmark(NewsModel news) {
    if (!isBookmarked(news.id)) {
      _bookmarks.insert(0, news);
      _notifyListeners();
    }
  }

  /// Hapus dari bookmark
  void removeBookmark(int newsId) {
    _bookmarks.removeWhere((n) => n.id == newsId);
    _notifyListeners();
  }

  /// Hapus semua bookmark
  void clearBookmarks() {
    _bookmarks.clear();
    _notifyListeners();
  }

  /// Jumlah bookmark
  int get count => _bookmarks.length;
}

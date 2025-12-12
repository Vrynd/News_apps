class NewsModel {
  final int id;
  final String title;
  final String content;
  final String category;
  final String imageUrl;
  final String author;
  final DateTime createdAt;
  final int commentsCount;
  final int sharesCount;
  final int likesCount;

  NewsModel({
    required this.id,
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
    return NewsModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      author: json['author'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      commentsCount: json['comments_count'] ?? 0,
      sharesCount: json['shares_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
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

  // Dummy data untuk development
  static List<NewsModel> getDummyNews() {
    return [
      NewsModel(
        id: 1,
        title: 'Teknologi AI Semakin Berkembang di Indonesia',
        content: '''
Perkembangan teknologi kecerdasan buatan (AI) di Indonesia semakin pesat. Berbagai startup dan perusahaan besar mulai mengadopsi teknologi ini untuk meningkatkan efisiensi operasional.

Menurut data terbaru, investasi di sektor AI Indonesia meningkat hingga 200% dalam dua tahun terakhir. Hal ini menunjukkan kepercayaan investor terhadap potensi pasar teknologi di tanah air.

Pemerintah juga turut mendukung perkembangan ini melalui berbagai program pelatihan dan insentif untuk perusahaan yang mengembangkan solusi berbasis AI.
        ''',
        category: 'Teknologi',
        imageUrl: 'https://picsum.photos/seed/tech1/800/400',
        author: 'Ahmad Rizki',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        commentsCount: 24,
        sharesCount: 156,
        likesCount: 342,
      ),
      NewsModel(
        id: 2,
        title: 'Pasar Saham Indonesia Menguat di Tengah Ketidakpastian Global',
        content: '''
Indeks Harga Saham Gabungan (IHSG) mencatatkan penguatan signifikan pada perdagangan hari ini. Meski kondisi ekonomi global masih tidak menentu, investor asing tetap percaya pada fundamental ekonomi Indonesia.

Analis pasar modal menilai bahwa kebijakan moneter Bank Indonesia yang prudent menjadi faktor utama yang menjaga stabilitas pasar keuangan domestik.

Sektor perbankan dan komoditas menjadi motor penggerak utama penguatan IHSG pada hari ini.
        ''',
        category: 'Bisnis',
        imageUrl: 'https://picsum.photos/seed/business1/800/400',
        author: 'Siti Nurhayati',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        commentsCount: 18,
        sharesCount: 89,
        likesCount: 215,
      ),
      NewsModel(
        id: 3,
        title: 'Timnas Indonesia Melaju ke Final Piala AFF',
        content: '''
Tim Nasional Indonesia berhasil mengalahkan Vietnam dengan skor 2-1 di leg kedua semifinal Piala AFF. Dengan agregat 3-2, Garuda Muda resmi melaju ke babak final.

Dua gol Indonesia dicetak oleh striker andalan pada menit ke-23 dan 78. Pelatih tim nasional menyatakan kepuasannya atas performa para pemain.

Final Piala AFF akan digelar dalam dua leg, dengan leg pertama dijadwalkan berlangsung pekan depan.
        ''',
        category: 'Olahraga',
        imageUrl: 'https://picsum.photos/seed/sport1/800/400',
        author: 'Budi Santoso',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        commentsCount: 156,
        sharesCount: 892,
        likesCount: 2341,
      ),
      NewsModel(
        id: 4,
        title: 'Cuaca Ekstrem Diprediksi Melanda Beberapa Wilayah',
        content: '''
BMKG memperingatkan potensi cuaca ekstrem di beberapa wilayah Indonesia dalam beberapa hari ke depan. Hujan lebat disertai angin kencang diprediksi melanda Pulau Jawa dan Sumatera.

Masyarakat diimbau untuk meningkatkan kewaspadaan dan menghindari aktivitas di luar ruangan saat cuaca buruk. Potensi banjir dan tanah longsor juga perlu diantisipasi.

Instansi terkait telah menyiapkan tim evakuasi dan posko bantuan di daerah-daerah rawan bencana.
        ''',
        category: 'Nasional',
        imageUrl: 'https://picsum.photos/seed/weather1/800/400',
        author: 'Dewi Kartika',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        commentsCount: 45,
        sharesCount: 234,
        likesCount: 567,
      ),
      NewsModel(
        id: 5,
        title: 'Film Indonesia Raih Penghargaan di Festival Internasional',
        content: '''
Sebuah film karya sutradara Indonesia berhasil meraih penghargaan Best Picture di festival film internasional. Pencapaian ini menjadi kebanggaan bagi industri perfilman tanah air.

Film yang mengangkat tema budaya lokal ini mendapat pujian dari kritikus internasional atas keindahan sinematografi dan kedalaman ceritanya.

Produser film menyatakan akan terus mengangkat cerita-cerita lokal Indonesia ke panggung internasional.
        ''',
        category: 'Hiburan',
        imageUrl: 'https://picsum.photos/seed/movie1/800/400',
        author: 'Ratna Sari',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        commentsCount: 67,
        sharesCount: 445,
        likesCount: 1023,
      ),
    ];
  }

  // Kategori yang tersedia
  static List<String> get categories => [
        'Semua',
        'Teknologi',
        'Bisnis',
        'Olahraga',
        'Nasional',
        'Hiburan',
        'Internasional',
      ];
}

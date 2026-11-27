
class DataPengajuan {
  final int id;
  final int userId;
  final String judul;
  final String deskripsi;
  final String status;

  const DataPengajuan({
    required this.id,
    required this.userId,
    required this.judul,
    required this.deskripsi,
    required this.status,
  });

  factory DataPengajuan.fromJson(Map<String, dynamic> json) {
    return DataPengajuan(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      judul: json['title'] as String? ?? 'Tanpa Judul',
      deskripsi: json['body'] as String? ?? 'Tidak ada deskripsi',
      status: json['status'] as String? ?? 'menunggu',
    );
  }
}
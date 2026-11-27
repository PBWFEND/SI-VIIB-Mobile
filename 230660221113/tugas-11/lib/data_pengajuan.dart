/// Model pengajuan FasKampus yang digunakan oleh CRUD lokal dan REST API.
class DataPengajuan {
  final String id;
  final String namaFasilitas;
  final String tanggal;
  final String jamMulai;
  final String jamSelesai;
  final String tujuan;
  final String status;

  const DataPengajuan({
    required this.id,
    required this.namaFasilitas,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.tujuan,
    required this.status,
  });

  /// Membaca data JSON dari API.
  /// JSONPlaceholder menggunakan field title dan body, sedangkan backend
  /// FasKampus nantinya dapat menggunakan field yang lebih spesifik.
  factory DataPengajuan.fromJson(Map<String, dynamic> json) {
    return DataPengajuan(
      id: (json['id'] ?? '').toString(),
      namaFasilitas: (json['namaFasilitas'] ?? json['ruang'] ?? json['title'] ?? 'Fasilitas tidak diketahui').toString(),
      tanggal: (json['tanggal'] ?? '-').toString(),
      jamMulai: (json['jamMulai'] ?? '-').toString(),
      jamSelesai: (json['jamSelesai'] ?? '-').toString(),
      tujuan: (json['tujuan'] ?? json['body'] ?? '-').toString(),
      status: (json['status'] ?? 'Menunggu').toString(),
    );
  }

  /// Mengubah objek menjadi payload JSON untuk operasi POST.
  Map<String, dynamic> toJson() {
    return {
      'namaFasilitas': namaFasilitas,
      'tanggal': tanggal,
      'jamMulai': jamMulai,
      'jamSelesai': jamSelesai,
      'tujuan': tujuan,
      'status': status,
      // Field title/body/userId disediakan agar kompatibel dengan
      // endpoint simulasi JSONPlaceholder.
      'title': namaFasilitas,
      'body': tujuan,
      'userId': 1,
    };
  }

  @override
  String toString() => '$namaFasilitas - $tanggal - $status';
}

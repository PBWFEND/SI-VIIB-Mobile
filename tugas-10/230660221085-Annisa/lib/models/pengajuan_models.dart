/// Aturan Proses Bisnis: Status Pengajuan Laboratorium
enum StatusPengajuan { menunggu, disetujui, ditolak }

/// Model 1: Data Pengguna (Pemohon) dari endpoint /users
class DataPengguna {
  final int id;
  final String nama;
  final String email;

  const DataPengguna({
    required this.id,
    required this.nama,
    required this.email,
  });

  factory DataPengguna.fromJson(Map<String, dynamic> json) {
    return DataPengguna(
      id: json['id'] as int? ?? 0,
      nama: json['name'] as String? ?? 'Mahasiswa Pemohon',
      email: json['email'] as String? ?? '-',
    );
  }
}

/// Model 2: Data Ruangan dari endpoint /comments (dipetakan ke nama lab Bahasa Indonesia)
class DataRuang {
  final int id;
  final String namaRuang;

  const DataRuang({
    required this.id,
    required this.namaRuang,
  });

  factory DataRuang.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] as int? ?? 0;
    const daftarLabIndonesia = [
      'Lab Rekayasa Perangkat Lunak',
      'Lab Jaringan Komputer & Keamanan',
      'Lab Basis Data & Sistem Informasi',
      'Lab Multimedia & Desain Antarmuka',
      'Lab Kecerdasan Buatan & Komputasi',
    ];
    final namaLab = daftarLabIndonesia[id % daftarLabIndonesia.length];

    return DataRuang(
      id: id,
      namaRuang: '$namaLab (R.0$id)',
    );
  }
}

/// Model 3: Data Transaksi Pengajuan dari endpoint /posts
class DataPengajuan {
  final int id;
  final int userId;
  final int roomId;
  final String keperluan;
  final StatusPengajuan status;

  const DataPengajuan({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.keperluan,
    required this.status,
  });

  factory DataPengajuan.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] as int? ?? 0;
    return DataPengajuan(
      id: id,
      userId: json['userId'] as int? ?? 0,
      roomId: (id % 5) + 1,
      keperluan: _terjemahkanKeperluanSimulasi(id),
      status: _tentukanStatusBisnis(id, json['status'] as String?),
    );
  }

  /// Pemetaan payload simulasi menjadi keperluan praktikum berbahasa Indonesia
  static String _terjemahkanKeperluanSimulasi(int id) {
    const daftarKeperluan = [
      'Praktikum Pemrograman Aplikasi Bergerak (Flutter)',
      'Simulasi Konfigurasi Jaringan & Routing Terpusat',
      'Pengujian Integrasi REST API & Basis Data Terdistribusi',
      'Workshop Desain Antarmuka & Pengalaman Pengguna (UI/UX)',
      'Asistensi Proyek Akhir Sistem Informasi',
      'Pelatihan Keamanan Aplikasi Web & Mobile',
    ];
    return daftarKeperluan[id % daftarKeperluan.length];
  }

  /// Aturan Proses Bisnis: Penentuan status pengajuan
  static StatusPengajuan _tentukanStatusBisnis(int id, String? rawStatus) {
    if (rawStatus == 'disetujui') return StatusPengajuan.disetujui;
    if (rawStatus == 'ditolak') return StatusPengajuan.ditolak;

    if (id % 3 == 0) return StatusPengajuan.disetujui;
    if (id % 4 == 0) return StatusPengajuan.ditolak;
    return StatusPengajuan.menunggu;
  }
}

/// ViewModel Gabungan: Siap disajikan ke Widget UI tanpa olah ID manual
class DataPengajuanRingkas {
  final int idPengajuan;
  final String namaPemohon;
  final String emailPemohon;
  final String namaRuang;
  final String keperluan;
  final StatusPengajuan status;

  const DataPengajuanRingkas({
    required this.idPengajuan,
    required this.namaPemohon,
    required this.emailPemohon,
    required this.namaRuang,
    required this.keperluan,
    required this.status,
  });

  String get labelStatus {
    switch (status) {
      case StatusPengajuan.disetujui:
        return 'Disetujui';
      case StatusPengajuan.ditolak:
        return 'Ditolak';
      case StatusPengajuan.menunggu:
        return 'Menunggu Verifikasi';
    }
  }
}
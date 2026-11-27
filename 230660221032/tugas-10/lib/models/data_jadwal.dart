/// Aturan Proses Bisnis: Status alur produksi program siaran RadiAct
enum StatusJadwal { progres, tayang, terkendala }

extension StatusJadwalEkstensi on StatusJadwal {
  String get label {
    switch (this) {
      case StatusJadwal.tayang:
        return 'Tayang';
      case StatusJadwal.terkendala:
        return 'Terkendala';
      case StatusJadwal.progres:
        return 'Progres';
    }
  }
}

/// Model 2: Data Jadwal Konten dari endpoint /posts
class DataJadwal {
  const DataJadwal({
    required this.id,
    required this.userId,
    required this.judul,
    required this.divisi,
    required this.tanggal,
    required this.status,
    required this.catatan,
  });

  final int id;
  final int userId; // Identifier penghubung ke DataPengguna.id
  final String judul;
  final String divisi;
  final String tanggal;
  final StatusJadwal status;
  final String catatan;

  static StatusJadwal _kodeKeStatus(int id) {
    switch (id % 3) {
      case 1:
        return StatusJadwal.tayang;
      case 2:
        return StatusJadwal.progres;
      default:
        return StatusJadwal.terkendala;
    }
  }

  static String _kodeKeDivisi(int kode) {
    switch (kode % 4) {
      case 1:
        return 'DIVISI EDUKASI';
      case 2:
        return 'DIVISI ENTERTAIN';
      case 3:
        return 'DIVISI MARCOMM';
      default:
        return 'DIVISI REDAKSI';
    }
  }

  /// Mengubah JSON dari /posts menjadi objek DataJadwal
  factory DataJadwal.fromJson(Map<String, dynamic> json) {
    final int idAngka = (json['id'] as num?)?.toInt() ?? 0;
    final int kodeUser = (json['userId'] as num?)?.toInt() ?? 0;

    return DataJadwal(
      id: idAngka,
      userId: kodeUser,
      judul: json['title'] as String? ?? 'Program Tanpa Judul',
      divisi: json['divisi'] as String? ?? _kodeKeDivisi(kodeUser),
      tanggal: json['tanggal'] as String? ?? '25 November 2026',
      status: _kodeKeStatus(idAngka),
      catatan: json['body'] as String? ?? 'Tidak ada catatan.',
    );
  }
}
// Tugas 10: Integrasi Data dan Proses Bisnis — Model Data
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — perancangan model relasional dengan identifier userId dan enum StatusPesanan

/// Aturan status proses bisnis pemesanan kantin
enum StatusPesanan { menunggu, diproses, siapDiambil }

StatusPesanan statusDariKode(int id) {
  if (id % 3 == 0) {
    return StatusPesanan.siapDiambil;
  } else if (id % 2 == 0) {
    return StatusPesanan.diproses;
  }
  return StatusPesanan.menunggu;
}

String labelStatusPesanan(StatusPesanan status) {
  switch (status) {
    case StatusPesanan.menunggu:
      return 'Menunggu Konfirmasi';
    case StatusPesanan.diproses:
      return 'Sedang Dimasak';
    case StatusPesanan.siapDiambil:
      return 'Siap Diambil';
  }
}

/// Model 1: Data Pemesan Mahasiswa dari Endpoint /users
class DataPemesan {
  const DataPemesan({
    required this.id,
    required this.nama,
    required this.email,
  });

  final int id;
  final String nama;
  final String email;

  factory DataPemesan.fromJson(Map<String, dynamic> json) {
    return DataPemesan(
      id: json['id'] as int? ?? 0,
      nama: json['name'] as String? ?? 'Mahasiswa Tanpa Nama',
      email: json['email'] as String? ?? '-',
    );
  }
}

/// Model 2: Data Pesanan Kantin dari Endpoint /posts
class DataPesanan {
  const DataPesanan({
    required this.id,
    required this.userId,
    required this.namaMenu,
    required this.catatan,
    required this.status,
  });

  final int id;
  final int userId;
  final String namaMenu;
  final String catatan;
  final StatusPesanan status;

  factory DataPesanan.fromJson(Map<String, dynamic> json) {
    final int idPesanan = json['id'] as int? ?? 0;
    return DataPesanan(
      id: idPesanan,
      userId: json['userId'] as int? ?? 0,
      namaMenu: json['title'] as String? ?? 'Menu Tidak Diketahui',
      catatan: json['body'] as String? ?? '-',
      status: statusDariKode(idPesanan),
    );
  }
}

/// Model 3 (ViewModel): Hasil penggabungan DataPesanan + DataPemesan berdasarkan userId
class PesananTerintegrasi {
  const PesananTerintegrasi({
    required this.idPesanan,
    required this.namaPemesan,
    required this.emailPemesan,
    required this.namaMenu,
    required this.catatan,
    required this.status,
  });

  final int idPesanan;
  final String namaPemesan;
  final String emailPemesan;
  final String namaMenu;
  final String catatan;
  final StatusPesanan status;

  PesananTerintegrasi salinDenganStatus(StatusPesanan statusBaru) {
    return PesananTerintegrasi(
      idPesanan: idPesanan,
      namaPemesan: namaPemesan,
      emailPemesan: emailPemesan,
      namaMenu: namaMenu,
      catatan: catatan,
      status: statusBaru,
    );
  }
}
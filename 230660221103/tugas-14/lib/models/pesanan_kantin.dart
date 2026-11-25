// Tugas 14: Integrasi Project & Candidate Release — Kontrak Data Bersama
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — penyatuan model PesananKantin dan enum StatusPesanan lintas halaman

/// Enum status tunggal yang dipakai bersama oleh Daftar, Detail, Filter, dan Form
enum StatusPesanan {
  menunggu('Menunggu'),
  diproses('Sedang Dimasak'),
  siapDiambil('Siap Diambil');

  const StatusPesanan(this.label);
  final String label;
}

/// Satu model entitas terpadu yang digunakan seluruh halaman
class PesananKantin {
  const PesananKantin({
    required this.id,
    required this.namaPemesan,
    required this.namaMenu,
    required this.jumlahPorsi,
    required this.nomorMeja,
    required this.catatan,
    required this.status,
  });

  final String id;
  final String namaPemesan;
  final String namaMenu;
  final int jumlahPorsi;
  final int nomorMeja;
  final String catatan;
  final StatusPesanan status;

  PesananKantin salinDengan({StatusPesanan? status}) {
    return PesananKantin(
      id: id,
      namaPemesan: namaPemesan,
      namaMenu: namaMenu,
      jumlahPorsi: jumlahPorsi,
      nomorMeja: nomorMeja,
      catatan: catatan,
      status: status ?? this.status,
    );
  }
}
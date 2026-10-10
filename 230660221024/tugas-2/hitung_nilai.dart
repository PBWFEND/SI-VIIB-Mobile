// ============================================================================
// PAB — Tugas 2: Modul Hitung Nilai
// Domain   : Aplikasi Absensi Organisasi Mahasiswa
// Modul    : Penilaian Keaktifan Anggota Organisasi
// ============================================================================
// Bantuan: AI coding assistant — membantu menyusun kerangka fungsi
//          hitungRataRata, predikat, dan struktur blok main sesuai panduan
//          Tugas 2 Pertemuan 2.
// ============================================================================
//
// Cara menjalankan:
//   dart hitung_nilai.dart
//
// Modul ini konsisten dengan domain Tugas 1 (Aplikasi Absensi Organisasi
// Mahasiswa). Lima komponen di bawah mewakili indikator keaktifan anggota
// yang direkap dari data kehadiran kegiatan organisasi.
// ============================================================================

void main() {
  // Daftar komponen penilaian keaktifan anggota (minimal 5 komponen).
  // Kunci konsisten: nama (String), bobot (int), skor (int).
  // Skor maksimal = bobot. Total bobot = 100.
  final List<Map<String, Object>> komponen = [
    {'nama': 'Kehadiran Kegiatan', 'bobot': 40, 'skor': 36},
    {'nama': 'Kontribusi Kepanitiaan', 'bobot': 20, 'skor': 18},
    {'nama': 'Kedisiplinan Waktu', 'bobot': 15, 'skor': 13},
    {'nama': 'Partisipasi Rapat', 'bobot': 15, 'skor': 12},
    {'nama': 'Pengumpulan Laporan', 'bobot': 10, 'skor': 9},
  ];

  const String namaMataKuliah = 'Pemrograman Aplikasi Bergerak';
  const String domain = 'Aplikasi Absensi Organisasi Mahasiswa';

  print('=' * 60);
  print('Mata Kuliah : $namaMataKuliah');
  print('Domain      : $domain');
  print('Modul       : Hitung Nilai Keaktifan Anggota');
  print('=' * 60);

  // 1. Menampilkan nama mata kuliah dan daftar komponen
  print('\nDaftar Komponen Penilaian:');
  for (var i = 0; i < komponen.length; i++) {
    final k = komponen[i];
    final bobot = k['bobot'] as int;
    final skor = k['skor'] as int;
    final capaian = (skor / bobot * 100).toStringAsFixed(1);
    print('  ${i + 1}. ${k['nama']} — bobot $bobot, skor $skor ($capaian%)');
  }

  // 2. Rata-rata skor seluruh komponen
  final double rataRata = hitungRataRata(komponen);
  print('\nRata-rata skor: ${rataRata.toStringAsFixed(2)}');

  // 3. Predikat akhir berdasarkan rata-rata
  final String hasilPredikat = predikat(rataRata);
  print('Predikat akhir: $hasilPredikat');
  print('=' * 60);
}

// Aturan predikat keaktifan anggota organisasi:
//   >= 86    -> "Sangat Aktif"
//   76 - 85  -> "Aktif"
//   61 - 75  -> "Cukup Aktif"
//   < 61     -> "Perlu Pembinaan"
//
// Nilai yang diberikan adalah persentase (0-100) hasil hitungRataRata,
// sehingga seluruh rentang nilai tercakup oleh cabang di bawah ini.
String predikat(double nilai) {
  if (nilai >= 86) return 'Sangat Aktif';
  if (nilai >= 76) return 'Aktif';
  if (nilai >= 61) return 'Cukup Aktif';
  return 'Perlu Pembinaan';
}

// Menghitung rata-rata skor berbobot dari seluruh komponen penilaian.
// Rumus: (jumlah seluruh skor / jumlah seluruh bobot) * 100.
// Skor dan bobot berada pada skala yang sama (skor <= bobot), sehingga
// hasil dibagi total bobot lalu dikali 100 untuk mendapat persentase 0-100.
// Return type double agar hasil persentase tidak terpotong.
double hitungRataRata(List<Map<String, Object>> komponen) {
  if (komponen.isEmpty) return 0.0;

  var totalSkor = 0;
  var totalBobot = 0;
  for (final k in komponen) {
    totalSkor += k['skor'] as int;
    totalBobot += k['bobot'] as int;
  }

  if (totalBobot == 0) return 0.0;
  return totalSkor / totalBobot * 100;
}

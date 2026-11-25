// Tugas 2: Modul Hitung Nilai — Pemrograman Aplikasi Bergerak
// Bantuan: Gemini — referensi struktur tipe eksplisit List> dan dekonstruksi Map

/// Fungsi untuk menghitung rata-rata skor dari seluruh komponen penilaian.
/// Mengembalikan tipe data double sesuai spesifikasi.
double hitungRataRata(List> komponen) {
  if (komponen.isEmpty) return 0.0;

  var totalSkor = 0;
  for (final item in komponen) {
    // Melakukan type casting (as int) karena tipe value pada Map adalah Object
    totalSkor += item['skor'] as int;
  }

  // Pembagian (/) di Dart selalu menghasilkan tipe double
  return totalSkor / komponen.length;
}

/// Fungsi untuk menentukan predikat berdasarkan nilai rata-rata[cite: 11, 12].
///
/// Aturan rentang predikat (skala skor komponen 0 - 20):
/// >= 17.5  -> A (Sangat Baik)
/// 15.0 - 17.49 -> B (Baik)
/// 12.0 - 14.99 -> C (Cukup)
/// < 12.0   -> Perlu perbaikan
String predikat(double nilai) {
  if (nilai >= 17.5) {
    return 'A';
  } else if (nilai >= 15.0) {
    return 'B';
  } else if (nilai >= 12.0) {
    return 'C';
  } else {
    return 'Perlu perbaikan';
  }
}

void main() {
  // 1. Deklarasi nama mata kuliah menggunakan final
  final namaMataKuliah = 'Pemrograman Aplikasi Bergerak (USA-WP2360241)';

  // 2. Deklarasi List> berisi 5 komponen penilaian (total bobot = 100)[cite: 11, 12]
  final List> komponenPenilaian = [
    {'nama': 'Kehadiran & Keaktifan', 'bobot': 20, 'skor': 19},
    {'nama': 'Tugas Mandiri', 'bobot': 20, 'skor': 18},
    {'nama': 'Praktikum Mingguan', 'bobot': 20, 'skor': 17},
    {'nama': 'Ujian Tengah Semester (UTS)', 'bobot': 20, 'skor': 16},
    {'nama': 'Ujian Akhir Semester (UAS)', 'bobot': 20, 'skor': 18},
  ];

  // Menampilkan Header & Nama Mata Kuliah[cite: 11, 12]
  print('==========================================================');
  print('Mata Kuliah : $namaMataKuliah');
  print('==========================================================');
  print('Daftar Komponen Penilaian:');

  // 3. Menampilkan daftar komponen menggunakan perulangan for-in[cite: 11, 12]
  var nomor = 1;
  var totalBobot = 0;
  for (final item in komponenPenilaian) {
    final nama = item['nama'] as String;
    final bobot = item['bobot'] as int;
    final skor = item['skor'] as int;

    totalBobot += bobot;
    print('$nomor.$nama | Bobot: $bobot\% \vert{} Skor:$skor');
    nomor++;
  }

  print('----------------------------------------------------------');
  print('Total Bobot : $totalBobot%');

  // 4. Menghitung dan menampilkan rata-rata skor serta predikat akhir[cite: 11, 12]
  final rataRata = hitungRataRata(komponenPenilaian);
  final hasilPredikat = predikat(rataRata);

  print('Rata-rata Skor : ${rataRata.toStringAsFixed(2)}');
  print('Predikat Akhir : $hasilPredikat');
  print('==========================================================');
}
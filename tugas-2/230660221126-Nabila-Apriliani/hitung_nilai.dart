// 1.1 Struktur Data: List<Map<String, Object>>
final List<Map<String, Object>> komponenPenilaian = [
  {'nama': 'Tugas Mandiri', 'bobot': 30, 'skor': 28},
  {'nama': 'Praktikum PAB', 'bobot': 25, 'skor': 24},
  {'nama': 'Kuis Interaktif', 'bobot': 15, 'skor': 14},
  {'nama': 'Ujian Tengah Semester', 'bobot': 15, 'skor': 12},
  {'nama': 'Ujian Akhir Semester', 'bobot': 15, 'skor': 13},
];

// 1.2 Fungsi hitungRataRata
double hitungRataRata(List<Map<String, Object>> komponen) {
  if (komponen.isEmpty) return 0.0;
  
  double totalSkor = 0.0;
  for (var item in komponen) {
    var skor = item['skor'];
    if (skor is num) {
      totalSkor += skor.toDouble();
    }
  }
  return totalSkor / komponen.length;
}

// 1.3 Fungsi predikat
// Aturan predikat rentang nilai:
// >= 25.0       -> A (Sangat Memuaskan)
// 20.0 - 24.99  -> B (Memuaskan)
// 15.0 - 19.99  -> C (Cukup)
// < 15.0        -> Perlu Perbaikan
String predikat(double nilai) {
  if (nilai >= 25.0) {
    return 'A (Sangat Memuaskan)';
  } else if (nilai >= 20.0) {
    return 'B (Memuaskan)';
  } else if (nilai >= 15.0) {
    return 'C (Cukup)';
  } else {
    return 'Perlu Perbaikan';
  }
}

// 1.4 Blok main()
void main() {
  print('=== MODUL HITUNG NILAI MATA KULIAH ===');
  print('Mata Kuliah: Pemrograman Aplikasi Bergerak');
  print('--------------------------------------');

  print('Daftar Komponen Penilaian:');
  for (var item in komponenPenilaian) {
    print('- ${item['nama']}: Bobot = ${item['bobot']}, Skor = ${item['skor']}');
  }
  print('--------------------------------------');

  double rataRata = hitungRataRata(komponenPenilaian);
  print('Rata-rata Skor: ${rataRata.toStringAsFixed(2)}');

  String predikatAkhir = predikat(rataRata);
  print('Predikat Akhir: $predikatAkhir');
  print('======================================');
}
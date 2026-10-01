
// dibantu ai untuk memeriksa struktur data

final List<Map<String, Object>> komponen = [
  {'nama': 'Tugas', 'bobot': 30, 'skor': 27},
  {'nama': 'Praktikum', 'bobot': 25, 'skor': 23},
  {'nama': 'Kuis', 'bobot': 15, 'skor': 14},
  {'nama': 'UTS', 'bobot': 15, 'skor': 13},
  {'nama': 'Proyek', 'bobot': 15, 'skor': 12},
];

double hitungRataRata(List<Map<String, Object>> komponen) {
  int totalSkor = 0;

  for (final item in komponen) {
    totalSkor += item['skor'] as int;
  }

  return totalSkor / komponen.length;
}

String predikat(double nilai) {
  if (nilai >= 17.0) {
    return 'A';
  } else if (nilai >= 15.0) {
    return 'B';
  } else if (nilai >= 13.0) {
    return 'C';
  } else if (nilai >= 10.0) {
    return 'D';
  } else {
    return 'E';
  }
}

void main() {
  const String mataKuliah = 'Pemrograman Aplikasi Bergerak';

  print('Mata Kuliah: $mataKuliah');
  print('Daftar Komponen Penilaian:');

  for (final item in komponen) {
    print(
      '- ${item['nama']}: '
      'Bobot ${item['bobot']}, '
      'Skor ${item['skor']}',
    );
  }

  final double rataRata = hitungRataRata(komponen);
  final String hasilPredikat = predikat(rataRata);

  print('');
  print('Rata-rata skor: ${rataRata.toStringAsFixed(2)}');
  print('Predikat akhir: $hasilPredikat');
}
// Tugas 2 - Modul Hitung Nilai
// Mata Kuliah: Pemrograman Aplikasi Bergerak
// Nama: Kikania Zahra
// NIM: [ISI NIM ANDA]

final String namaMataKuliah = 'Pemrograman Aplikasi Bergerak';

final List<Map<String, Object>> komponen = [
  {
    'nama': 'Tugas',
    'bobot': 20,
    'skor': 18,
  },
  {
    'nama': 'Praktikum',
    'bobot': 25,
    'skor': 23,
  },
  {
    'nama': 'Kuis',
    'bobot': 15,
    'skor': 13,
  },
  {
    'nama': 'UTS',
    'bobot': 20,
    'skor': 17,
  },
  {
    'nama': 'UAS',
    'bobot': 20,
    'skor': 18,
  },
];

// Menghitung rata-rata skor seluruh komponen.
double hitungRataRata(List<Map<String, Object>> komponen) {
  var totalSkor = 0;

  for (final item in komponen) {
    totalSkor += item['skor'] as int;
  }

  return totalSkor / komponen.length;
}

// Aturan predikat berdasarkan rata-rata skor:
// >= 18 -> A
// 16 - 17.99 -> B
// 12 - 15.99 -> C
// < 12 -> Perlu perbaikan
String predikat(double nilai) {
  if (nilai >= 18) {
    return 'A';
  } else if (nilai >= 16) {
    return 'B';
  } else if (nilai >= 12) {
    return 'C';
  } else {
    return 'Perlu perbaikan';
  }
}

void main() {
  final rataRata = hitungRataRata(komponen);
  final hasilPredikat = predikat(rataRata);

  print('==========================================');
  print('       MODUL HITUNG NILAI MAHASISWA');
  print('==========================================');
  print('Mata Kuliah : $namaMataKuliah');
  print('');
  print('Daftar Komponen Penilaian:');
  print('------------------------------------------');

  for (final item in komponen) {
    final nama = item['nama'] as String;
    final bobot = item['bobot'] as int;
    final skor = item['skor'] as int;

    print('$nama - Bobot: $bobot - Skor: $skor');
  }

  print('------------------------------------------');
  print('Rata-rata Skor : ${rataRata.toStringAsFixed(2)}');
  print('Predikat Akhir : $hasilPredikat');
  print('==========================================');
}
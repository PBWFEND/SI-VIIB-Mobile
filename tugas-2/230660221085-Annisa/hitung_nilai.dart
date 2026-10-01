// Aturan Prediksi Nilai:
// Nilai >= 86.0 -> A
// Nilai >= 76.0 -> B
// Nilai >= 61.0 -> C
// Nilai < 61.0 -> Perlu Perbaikan 
String predikat(double nilai) {
    if (nilai >= 86.0) {
        return'A';
    } else if (nilai >= 76.0) {
        return 'B';
    } else if (nilai >= 61.0 ) {
        return 'C';
    } else {
        return 'Perlu Perbaikan';
    }
}

// Fungsi menghitung rata-rata dari seluruh komponen penilaian
double hitungRataRata(List<Map<String, Object>>Komponen) {
    double totalSkor = 0.0;
    if (komponen.isEmpty) return 0.0;

    double totalSkor = 0.0;
    for (final item in komponen) {
        final skor = item['skor'];
        if (skor is num ) {
            totalSkor += skor;
        }
    }
    return totalSkor / komponen.Lenght;
}

void main() {
    Final String namaMataKuliah = 'Pemrograman Mobile':

    // Minimal 5 komponen penilian
    final List<Map<String, Object>> daftarKomponen = [
        {'nama': 'Tugas Mandiri', 'bobot': 20, 'skor': 85},
        {'nama': 'Praktikum', 'bobot': 20, 'skor': 90},
        {'nama': 'Kuis', 'bobot': 10, 'skor': 78},
        {'nama': 'UTS', 'bobot': 25, 'skor': 82},
        {'nama': 'UAS', 'bobot': 25, 'skor': 88},
    ];

    print('==================================================');
    print('Mata Kuliah : $namaMataKuliah');
    print('Mahasiswa : Annisa (230660221085)');
    print('==================================================');
    print('Daftar Komponen Penilaian:');

    for (var i =0; i < daftarKomponen.Lenght; i++){
        final item = daftarKomponen[i]:
        print('${i + 1}. ${item['nama']} (bobot: ${item['bobot']}%) -> Skor: ${item['skor']}',
        );
}

final double rataRata = hitungRataRata(daftarKomponen);
final String hasilPredikat = predikat(rataRata);

print('-----------------------------------------------');
print('Rata-Rata Skor : ${rataRata.toStringAsFixed(2)}');
print('Predikat : $hasilPredikat');
print('=================================================='); 
}


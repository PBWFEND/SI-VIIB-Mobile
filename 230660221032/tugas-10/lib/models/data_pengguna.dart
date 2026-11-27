/// Model 1: Data Penanggung Jawab (PJ)
class DataPengguna {
  const DataPengguna({
    required this.id,
    required this.nama,
    required this.email,
  });

  final int id; // Identifier utama yang akan dicocokkan dengan userId
  final String nama;
  final String email;

  /// Mengubah JSON dari /users menjadi objek DataPengguna dengan nilai default aman
  factory DataPengguna.fromJson(Map<String, dynamic> json) {
    return DataPengguna(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nama: json['name'] as String? ?? 'PJ Belum Ditentukan',
      email: json['email'] as String? ?? '-',
    );
  }
}
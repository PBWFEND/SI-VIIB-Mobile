
class DataPengguna {
  final int id;
  final String nama;
  final String email;
  final String username;

  const DataPengguna({
    required this.id,
    required this.nama,
    required this.email,
    required this.username,
  });

  factory DataPengguna.fromJson(Map<String, dynamic> json) {
    return DataPengguna(
      id: json['id'] as int? ?? 0,
      nama: json['name'] as String? ?? 'Tanpa Nama',
      email: json['email'] as String? ?? 'Tidak tersedia',
      username: json['username'] as String? ?? 'Tidak tersedia',
    );
  }
}
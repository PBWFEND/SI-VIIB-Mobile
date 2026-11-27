
class DataPengajuanRingkas {
  final int idPengajuan;
  final int idPengguna;
  final String namaPemohon;
  final String emailPemohon;
  final String judulPengajuan;
  final String deskripsi;
  final String status;

  const DataPengajuanRingkas({
    required this.idPengajuan,
    required this.idPengguna,
    required this.namaPemohon,
    required this.emailPemohon,
    required this.judulPengajuan,
    required this.deskripsi,
    required this.status,
  });
}
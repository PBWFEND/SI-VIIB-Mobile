import 'data_jadwal.dart';

/// Model 3: Hasil Penggabungan (Join) antara DataJadwal dan DataPengguna
class JadwalTerintegrasi {
  const JadwalTerintegrasi({
    required this.id,
    required this.userId,
    required this.judul,
    required this.divisi,
    required this.namaPenanggungJawab,
    required this.emailPenanggungJawab,
    required this.tanggal,
    required this.status,
    required this.catatan,
  });

  final int id;
  final int userId;
  final String judul;
  final String divisi;
  final String namaPenanggungJawab; // Diambil dari endpoint /users
  final String emailPenanggungJawab; // Diambil dari endpoint /users
  final String tanggal;
  final StatusJadwal status;
  final String catatan;

  /// Aturan proses bisnis: hanya jadwal berstatus 'Progres' yang siap disetujui menjadi 'Tayang'
  bool get bisaDisetujuiTayang => status == StatusJadwal.progres;

  JadwalTerintegrasi salinDenganStatus(StatusJadwal statusBaru) {
    return JadwalTerintegrasi(
      id: id,
      userId: userId,
      judul: judul,
      divisi: divisi,
      namaPenanggungJawab: namaPenanggungJawab,
      emailPenanggungJawab: emailPenanggungJawab,
      tanggal: tanggal,
      status: statusBaru,
      catatan: catatan,
    );
  }
}
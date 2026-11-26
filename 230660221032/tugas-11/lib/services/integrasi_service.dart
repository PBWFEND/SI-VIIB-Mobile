import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'file_naskah_service.dart';

enum StatusJadwal {
  progres('Progres'),
  tayang('Tayang'),
  terkendala('Terkendala');

  final String label;
  const StatusJadwal(this.label);
}

class JadwalTerintegrasi {
  final int id;
  final int userId;
  final String judul;
  final String divisi;
  final String tanggal;
  final String catatan;
  final String namaPenanggungJawab;
  final String emailPenanggungJawab;
  final StatusJadwal status;
  final InfoFileNaskah? fileNaskah;

  JadwalTerintegrasi({
    required this.id,
    required this.userId,
    required this.judul,
    required this.divisi,
    required this.tanggal,
    required this.catatan,
    required this.namaPenanggungJawab,
    required this.emailPenanggungJawab,
    required this.status,
    this.fileNaskah,
  });

  JadwalTerintegrasi salinDengan({
    StatusJadwal? status,
    InfoFileNaskah? fileNaskah,
  }) {
    return JadwalTerintegrasi(
      id: id,
      userId: userId,
      judul: judul,
      divisi: divisi,
      tanggal: tanggal,
      catatan: catatan,
      namaPenanggungJawab: namaPenanggungJawab,
      emailPenanggungJawab: emailPenanggungJawab,
      status: status ?? this.status,
      fileNaskah: fileNaskah ?? this.fileNaskah,
    );
  }
}

class IntegrasiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<JadwalTerintegrasi>> ambilJadwalTerintegrasi() async {
    try {
      final hasil = await Future.wait([
        http
            .get(Uri.parse('$_baseUrl/users'))
            .timeout(const Duration(seconds: 10)),
        http
            .get(Uri.parse('$_baseUrl/posts'))
            .timeout(const Duration(seconds: 10)),
      ]);

      final resUsers = hasil[0];
      final resPosts = hasil[1];

      if (resUsers.statusCode != 200 || resPosts.statusCode != 200) {
        throw Exception(
          'Gagal memuat data dari server (Status: ${resUsers.statusCode}/${resPosts.statusCode})',
        );
      }

      final List<dynamic> listUsers = jsonDecode(resUsers.body);
      final List<dynamic> listPosts = jsonDecode(resPosts.body);

      final Map<int, Map<String, dynamic>> mapUsers = {
        for (var u in listUsers)
          (u['id'] as num).toInt(): u as Map<String, dynamic>,
      };

      const daftarProgram = [
        {
          'judul': 'Redaksi Insight',
          'divisi': 'DIVISI REDAKSI',
          'tanggal': '20 Oktober 2026',
          'catatan': 'Tidak ada hambatan.',
          'status': StatusJadwal.progres,
        },
        {
          'judul': 'Unsap Trending',
          'divisi': 'DIVISI ENTERTAIN',
          'tanggal': '24 Oktober 2026',
          'catatan': 'Tahap Editing.',
          'status': StatusJadwal.progres,
        },
        {
          'judul': 'Minggu Opini',
          'divisi': 'DIVISI SIARAN',
          'tanggal': '28 Oktober 2026',
          'catatan': 'Menunggu konfirmasi narasumber.',
          'status': StatusJadwal.terkendala,
        },
        {
          'judul': 'Zona Musik Kampus',
          'divisi': 'DIVISI MUSIK',
          'tanggal': '02 November 2026',
          'catatan': 'Playlist lagu sudah siap.',
          'status': StatusJadwal.progres,
        },
      ];

      return listPosts.take(4).toList().asMap().entries.map((entry) {
        final idx = entry.key;
        final map = entry.value as Map<String, dynamic>;
        final id = (map['id'] as num?)?.toInt() ?? (idx + 1);
        final userId = (map['userId'] as num?)?.toInt() ?? 1;
        final pj = mapUsers[userId];
        final template = daftarProgram[idx % daftarProgram.length];

        return JadwalTerintegrasi(
          id: id,
          userId: userId,
          judul: template['judul'] as String,
          divisi: template['divisi'] as String,
          tanggal: template['tanggal'] as String,
          catatan: template['catatan'] as String,
          namaPenanggungJawab: pj?['name'] as String? ?? 'PJ Belum Ditentukan',
          emailPenanggungJawab: pj?['email'] as String? ?? '-',
          status: template['status'] as StatusJadwal,
        );
      }).toList();
    } on TimeoutException {
      throw Exception('Koneksi timeout. Periksa jaringan internet Anda.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Validasi aturan proses bisnis:
  /// - Dari Terkendala harus ke Progres dulu
  /// - Untuk berubah menjadi Tayang, file naskah wajib dilampirkan
  static String? validasiPerubahanStatus(
    JadwalTerintegrasi jadwal,
    StatusJadwal statusBaru,
  ) {
    if (jadwal.status == StatusJadwal.terkendala &&
        statusBaru == StatusJadwal.tayang) {
      return 'Jadwal berstatus Terkendala harus diubah ke Progres terlebih dahulu.';
    }
    if (statusBaru == StatusJadwal.tayang && jadwal.fileNaskah == null) {
      return 'Gagal mengubah status: Lampirkan file naskah (PDF/DOC/DOCX) terlebih dahulu sebelum memilih Tayang.';
    }
    return null;
  }
}

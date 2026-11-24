import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// 1. MODEL DATA: DataJadwal untuk RadiAct
class DataJadwal {
  const DataJadwal({
    required this.id,
    required this.judul,
    required this.divisi,
    required this.tanggal,
    required this.status,
    required this.catatan,
  });

  final String id;
  final String judul;
  final String divisi;
  final String tanggal;
  final String status;
  final String catatan;

  static const List<String> daftarDivisi = [
    'DIVISI EDUKASI',
    'DIVISI ENTERTAIN',
    'DIVISI MARCOMM',
    'DIVISI REDAKSI',
  ];

  static String _kodeKeDivisi(int kode) {
    switch (kode % 4) {
      case 1:
        return 'DIVISI EDUKASI';
      case 2:
        return 'DIVISI ENTERTAIN';
      case 3:
        return 'DIVISI MARCOMM';
      default:
        return 'DIVISI REDAKSI';
    }
  }

  static int _divisiKeKode(String divisi) {
    switch (divisi.toUpperCase()) {
      case 'DIVISI EDUKASI':
        return 1;
      case 'DIVISI ENTERTAIN':
        return 2;
      case 'DIVISI MARCOMM':
        return 3;
      default:
        return 4;
    }
  }

  static String _kodeKeStatus(int id) {
    switch (id % 3) {
      case 1:
        return 'Tayang';
      case 2:
        return 'Progres';
      default:
        return 'Terkendala';
    }
  }

  /// Mengubah response JSON (Map) dari server menjadi objek DataJadwal
  factory DataJadwal.fromJson(Map<String, dynamic> json) {
    final int idAngka = (json['id'] as num?)?.toInt() ?? 0;
    final int kodeUser = (json['userId'] as num?)?.toInt() ?? 1;

    return DataJadwal(
      id: idAngka.toString(),
      judul: json['title'] as String? ?? 'Program Tanpa Judul',
      divisi: json['divisi'] as String? ?? _kodeKeDivisi(kodeUser),
      tanggal: json['tanggal'] as String? ?? '20 November 2026',
      status: json['status'] as String? ?? _kodeKeStatus(idAngka),
      catatan: json['body'] as String? ?? 'Tidak ada catatan.',
    );
  }

  /// Mengubah objek DataJadwal menjadi Map JSON untuk dikirim lewat HTTP POST
  Map<String, dynamic> toJson() {
    return {
      'title': judul,
      'body': catatan.isEmpty ? 'Tidak ada hambatan.' : catatan,
      'userId': _divisiKeKode(divisi),
      'divisi': divisi,
      'tanggal': tanggal,
      'status': status,
    };
  }

  @override
  String toString() => 'Jadwal $judul — $divisi ($tanggal)';
}

/// 2. LAPISAN SERVICE: Mengisolasi seluruh komunikasi HTTP (GET & POST)
class RadiActApiService {
  // Saat URL diubah tampilan akan error
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// HTTP GET: Mengambil daftar jadwal konten dari server
  static Future<List<DataJadwal>> ambilDaftarJadwal() async {
    final url = Uri.parse('$baseUrl/posts');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> dataMentah =
            jsonDecode(response.body) as List<dynamic>;
        return dataMentah
            .take(8)
            .map((item) => DataJadwal.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception(
          'Endpoint jadwal tidak ditemukan di server (HTTP 404).',
        );
      } else {
        throw Exception(
          'Gagal memuat data dari server (HTTP ${response.statusCode}).',
        );
      }
    } on TimeoutException {
      throw Exception(
        'Waktu tunggu habis (timeout 10 detik). Periksa koneksi internet Anda.',
      );
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  /// HTTP POST: Mengirim data jadwal baru ke server
  static Future<DataJadwal> kirimJadwalBaru(DataJadwal jadwalBaru) async {
    final url = Uri.parse('$baseUrl/posts');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(jadwalBaru.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final Map<String, dynamic> hasilJson =
            jsonDecode(response.body) as Map<String, dynamic>;
        return DataJadwal.fromJson(hasilJson);
      } else {
        throw Exception(
          'Gagal mengirim jadwal baru (HTTP ${response.statusCode}).',
        );
      }
    } on TimeoutException {
      throw Exception(
        'Pengiriman jadwal melebihi batas waktu (timeout 10 detik).',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengirim data: $e');
    }
  }
}

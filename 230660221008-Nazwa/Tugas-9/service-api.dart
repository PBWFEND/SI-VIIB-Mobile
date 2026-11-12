import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ============================================================================
// 1. MODEL DATA (Deserialisasi fromJson & Serialisasi toJson)
// ============================================================================
class LaporanFasilitas {
  final String id;
  final String fasilitas;
  final String kategori;
  final String kendala;
  final String status;
  final String pelapor;

  const LaporanFasilitas({
    required this.id,
    required this.fasilitas,
    required this.kategori,
    required this.kendala,
    required this.status,
    required this.pelapor,
  });

  /// Mengubah Map JSON dari server menjadi objek LaporanFasilitas (Null-Safe)
  factory LaporanFasilitas.fromJson(Map<String, dynamic> json) {
    return LaporanFasilitas(
      id: json['id']?.toString() ?? '0',
      fasilitas: (json['fasilitas'] ?? json['title']) as String? ??
          'Fasilitas Tanpa Nama',
      kategori: json['kategori'] as String? ?? 'Umum',
      kendala: (json['kendala'] ?? json['body']) as String? ??
          'Tidak ada rincian kendala.',
      status: json['status'] as String? ?? 'Menunggu',
      pelapor: json['pelapor'] as String? ?? 'Mahasiswa (Felix)',
    );
  }

  /// Mengubah objek LaporanFasilitas menjadi Map JSON untuk dikirim via POST
  Map<String, dynamic> toJson() {
    return {
      'fasilitas': fasilitas,
      'kategori': kategori,
      'kendala': kendala,
      'status': status,
      'pelapor': pelapor,
    };
  }

  @override
  String toString() {
    return 'LaporanFasilitas(id: $id, fasilitas: $fasilitas, status: $status)';
  }
}

// ============================================================================
// 2. LAPISAN SERVICE (Isolasi Interaksi HTTP GET & POST)
// ============================================================================
class PengaduanApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  /// Mengambil daftar pengaduan fasilitas dari server (HTTP GET)
  static Future<List<LaporanFasilitas>> ambilDaftarLaporan() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> dataMentah =
            jsonDecode(response.body) as List<dynamic>;

        return dataMentah
            .take(10)
            .map((item) =>
                LaporanFasilitas.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('Data pengaduan tidak ditemukan di server (HTTP 404).');
      } else {
        throw Exception(
            'Server mengembalikan kode error: HTTP ${response.statusCode}.');
      }
    } on TimeoutException {
      throw Exception(
          'Waktu tunggu habis (timeout). Periksa koneksi internet Anda.');
    } on http.ClientException {
      throw Exception(
          'Gagal terhubung ke server. Pastikan jaringan internet aktif.');
    } catch (e) {
      throw Exception('Terjadi kesalahan komunikasi data: $e');
    }
  }

  /// Mengirim laporan pengaduan baru ke server (HTTP POST)
  static Future<LaporanFasilitas> kirimLaporan(
      LaporanFasilitas laporanBaru) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(laporanBaru.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonBalasan =
            jsonDecode(response.body) as Map<String, dynamic>;
        return LaporanFasilitas.fromJson(jsonBalasan);
      } else {
        throw Exception(
            'Gagal mengirim laporan ke server (HTTP ${response.statusCode}).');
      }
    } on TimeoutException {
      throw Exception(
          'Pengiriman gagal karena waktu tunggu habis (timeout).');
    } on http.ClientException {
      throw Exception(
          'Tidak dapat menjangkau server. Periksa koneksi internet Anda.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengirim laporan: $e');
    }
  }
}
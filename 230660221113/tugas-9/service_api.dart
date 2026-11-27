import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'data_pengajuan.dart';

/// Service komunikasi REST API untuk fitur pengajuan FasKampus.
class PengajuanService {
  PengajuanService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration batasWaktu = Duration(seconds: 10);

  /// GET /posts: mengambil daftar data dari API simulasi.
  Future<List<DataPengajuan>> ambilDaftarPengajuan() async {
    final uri = Uri.parse('$baseUrl/posts');
    try {
      final response = await _client.get(uri).timeout(batasWaktu);
      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil data (HTTP ${response.statusCode}).');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('Respons daftar bukan berbentuk JSON array.');
      }
      return decoded
          .take(10)
          .map((item) => DataPengajuan.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList();
    } on TimeoutException {
      throw Exception('Permintaan melewati batas waktu 10 detik. Periksa koneksi internet.');
    } on FormatException {
      throw Exception('Format data dari server tidak sesuai.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  /// POST /posts: mengirim satu pengajuan baru ke API simulasi.
  Future<DataPengajuan> kirimPengajuan(DataPengajuan pengajuan) async {
    final uri = Uri.parse('$baseUrl/posts');
    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(pengajuan.toJson()),
          )
          .timeout(batasWaktu);

      if (response.statusCode != 201) {
        throw Exception('Gagal mengirim pengajuan (HTTP ${response.statusCode}).');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw const FormatException('Respons pengiriman bukan berbentuk JSON object.');
      }
      return DataPengajuan.fromJson(Map<String, dynamic>.from(decoded));
    } on TimeoutException {
      throw Exception('Pengiriman melewati batas waktu 10 detik. Silakan coba kembali.');
    } on FormatException {
      throw Exception('Format respons server tidak sesuai.');
    } on http.ClientException {
      throw Exception('Tidak dapat mengirim data. Periksa koneksi internet.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Terjadi kesalahan saat mengirim data: $e');
    }
  }

  void dispose() => _client.close();
}

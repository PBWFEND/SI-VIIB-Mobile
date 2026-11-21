import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/pengajuan_models.dart';

class IntegrasiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeoutDuration = Duration(seconds: 10);

  static Future<List<DataPengguna>> _ambilDaftarPengguna() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/users'))
        .timeout(_timeoutDuration);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((item) => DataPengguna.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 404) {
      throw Exception('Endpoint data pengguna tidak ditemukan (404).');
    } else {
      throw Exception('Gagal memuat data pengguna (HTTP ${response.statusCode}).');
    }
  }

  static Future<List<DataRuang>> _ambilDaftarRuang() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/comments?_limit=10'))
        .timeout(_timeoutDuration);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((item) => DataRuang.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal memuat master ruangan (HTTP ${response.statusCode}).');
    }
  }

  static Future<List<DataPengajuan>> _ambilDaftarPengajuan() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/posts?_limit=15'))
        .timeout(_timeoutDuration);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((item) => DataPengajuan.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal memuat daftar pengajuan (HTTP ${response.statusCode}).');
    }
  }

  static Future<List<DataPengajuanRingkas>> ambilPengajuanTerintegrasi() async {
    try {
      final hasil = await Future.wait([
        _ambilDaftarPengguna(),
        _ambilDaftarRuang(),
        _ambilDaftarPengajuan(),
      ]);

      final daftarPengguna = hasil[0] as List<DataPengguna>;
      final daftarRuang = hasil[1] as List<DataRuang>;
      final daftarPengajuan = hasil[2] as List<DataPengajuan>;

      final mapPengguna = {for (var u in daftarPengguna) u.id: u};
      final mapRuang = {for (var r in daftarRuang) r.id: r};

      return daftarPengajuan.map((pengajuan) {
        final pemohon = mapPengguna[pengajuan.userId];
        final ruang = mapRuang[pengajuan.roomId];

        return DataPengajuanRingkas(
          idPengajuan: pengajuan.id,
          namaPemohon: pemohon?.nama ?? 'Pengguna #${pengajuan.userId}',
          emailPemohon: pemohon?.email ?? '-',
          namaRuang: ruang?.namaRuang ?? 'Ruang #${pengajuan.roomId}',
          keperluan: pengajuan.keperluan,
          status: pengajuan.status,
        );
      }).toList();
    } on TimeoutException {
      throw Exception('Koneksi habis waktu (timeout). Periksa jaringan internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Pastikan perangkat terhubung.');
    } on FormatException {
      throw Exception('Format data dari server tidak sesuai.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
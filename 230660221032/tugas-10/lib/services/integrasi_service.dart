import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/data_jadwal.dart';
import '../models/data_pengguna.dart';
import '../models/jadwal_terintegrasi.dart';

/// Service Layer: Mengunci komunikasi HTTP ke 2 endpoint,
/// penggabungan data (Future.wait), dan aturan proses bisnis RadiAct.
class IntegrasiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _batasWaktu = Duration(seconds: 10);

  /// 1. Endpoint Pertama: Mengambil data Penanggung Jawab (PJ) dari /users
  static Future<List<DataPengguna>> ambilDaftarPengguna() async {
    final url = Uri.parse('$baseUrl/users');

    try {
      final response = await http.get(url).timeout(_batasWaktu);

      if (response.statusCode == 200) {
        final List<dynamic> dataJson =
            jsonDecode(response.body) as List<dynamic>;
        return dataJson
            .map((item) => DataPengguna.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint data penanggung jawab tidak ditemukan (404).');
      } else {
        throw Exception(
          'Gagal memuat data penanggung jawab (HTTP ${response.statusCode}).',
        );
      }
    } on TimeoutException {
      throw Exception('Waktu tunggu habis saat mengambil data pengguna.');
    } catch (e) {
      throw Exception('Koneksi ke layanan pengguna gagal: $e');
    }
  }

  /// 2. Endpoint Kedua: Mengambil data Jadwal Konten dari /posts
  static Future<List<DataJadwal>> ambilDaftarJadwal() async {
    final url = Uri.parse('$baseUrl/posts');

    try {
      final response = await http.get(url).timeout(_batasWaktu);

      if (response.statusCode == 200) {
        final List<dynamic> dataJson =
            jsonDecode(response.body) as List<dynamic>;
        return dataJson
            .take(10)
            .map((item) => DataJadwal.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint data jadwal tidak ditemukan (404).');
      } else {
        throw Exception(
          'Gagal memuat data jadwal (HTTP ${response.statusCode}).',
        );
      }
    } on TimeoutException {
      throw Exception('Waktu tunggu habis saat mengambil data jadwal.');
    } catch (e) {
      throw Exception('Koneksi ke layanan jadwal gagal: $e');
    }
  }

  /// 3. Penggabungan Data (Future.wait + Join berdasarkan userId)
  static Future<List<JadwalTerintegrasi>> ambilJadwalTerintegrasi() async {
    // Menjalankan 2 request secara paralel karena tidak saling bergantung
    final hasil = await Future.wait([
      ambilDaftarPengguna(),
      ambilDaftarJadwal(),
    ]);

    final daftarPengguna = hasil[0] as List<DataPengguna>;
    final daftarJadwal = hasil[1] as List<DataJadwal>;

    // Memetakan daftar pengguna berdasarkan id agar pencocokan userId cepat
    final Map<int, DataPengguna> petaPengguna = {
      for (final pengguna in daftarPengguna) pengguna.id: pengguna,
    };

    // Menggabungkan setiap jadwal dengan nama dan email Penanggung Jawab-nya
    return daftarJadwal.map((jadwal) {
      final pj = petaPengguna[jadwal.userId];
      return JadwalTerintegrasi(
        id: jadwal.id,
        userId: jadwal.userId,
        judul: jadwal.judul,
        divisi: jadwal.divisi,
        namaPenanggungJawab: pj?.nama ?? 'PJ Tidak Terdaftar (ID #${jadwal.userId})',
        emailPenanggungJawab: pj?.email ?? '-',
        tanggal: jadwal.tanggal,
        status: jadwal.status,
        catatan: jadwal.catatan,
      );
    }).toList();
  }

  /// 4. Aturan Proses Bisnis: Validasi transisi status program siaran
  static String? validasiPerubahanStatus(
    StatusJadwal statusLama,
    StatusJadwal statusBaru,
  ) {
    if (statusLama == StatusJadwal.terkendala &&
        statusBaru == StatusJadwal.tayang) {
      return 'Aturan Proses: Program "Terkendala" harus diubah ke "Progres" terlebih dahulu sebelum dapat ditayangkan.';
    }
    return null; // Valid, perubahan diizinkan
  }
}
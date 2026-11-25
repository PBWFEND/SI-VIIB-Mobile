// Tugas 10: Integrasi Data dan Proses Bisnis — Service Layer
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — penggabungan request paralel Future.wait dan pemetaan relasi userId

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model_kantin.dart';

class IntegrasiKantinService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Endpoint 1: Mengambil daftar pemesan mahasiswa
  static Future<List<DataPemesan>> ambilDaftarPemesan() async {
    final url = Uri.parse('$_baseUrl/users');
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> listJson = jsonDecode(response.body) as List<dynamic>;
      return listJson
          .map((item) => DataPemesan.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 404) {
      throw Exception('Endpoint data pemesan tidak ditemukan (404).');
    } else {
      throw Exception('Gagal memuat data pemesan (HTTP ${response.statusCode}).');
    }
  }

  /// Endpoint 2: Mengambil daftar pesanan kantin
  static Future<List<DataPesanan>> ambilDaftarPesanan() async {
    final url = Uri.parse('$_baseUrl/posts');
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> listJson = jsonDecode(response.body) as List<dynamic>;
      return listJson
          .take(15)
          .map((item) => DataPesanan.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 404) {
      throw Exception('Endpoint data pesanan tidak ditemukan (404).');
    } else {
      throw Exception('Gagal memuat data pesanan (HTTP ${response.statusCode}).');
    }
  }

  /// Menggabungkan data dari kedua endpoint menggunakan Future.wait berdasarkan userId
  static Future<List<PesananTerintegrasi>> ambilPesananTerintegrasi() async {
    try {
      // Menjalankan kedua request independen secara bersamaan
      final hasil = await Future.wait([
        ambilDaftarPemesan(),
        ambilDaftarPesanan(),
      ]);

      final daftarPemesan = hasil[0] as List<DataPemesan>;
      final daftarPesanan = hasil[1] as List<DataPesanan>;

      // Membuat peta pencarian pemesan berdasarkan id agar lookup O(1)
      final Map<int, DataPemesan> petaPemesan = {
        for (final pemesan in daftarPemesan) pemesan.id: pemesan,
      };

      // Menggabungkan pesanan dengan nama pemesan berdasarkan userId
      return daftarPesanan.map((pesanan) {
        final pemesan = petaPemesan[pesanan.userId];
        return PesananTerintegrasi(
          idPesanan: pesanan.id,
          namaPemesan: pemesan?.nama ?? 'Pemesan Tidak Dikenal (ID ${pesanan.userId})',
          emailPemesan: pemesan?.email ?? '-',
          namaMenu: pesanan.namaMenu,
          catatan: pesanan.catatan,
          status: pesanan.status,
        );
      }).toList();
    } on TimeoutException {
      throw Exception('Koneksi timeout: server tidak merespons dalam 10 detik.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Aturan proses bisnis: memajukan tahapan status pesanan berikutnya
  static StatusPesanan prosesTahapBerikutnya(StatusPesanan saatIni) {
    switch (saatIni) {
      case StatusPesanan.menunggu:
        return StatusPesanan.diproses;
      case StatusPesanan.diproses:
        return StatusPesanan.siapDiambil;
      case StatusPesanan.siapDiambil:
        return StatusPesanan.menunggu;
    }
  }
}
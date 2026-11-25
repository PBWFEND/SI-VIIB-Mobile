// Tugas 9: Integrasi REST API (Service Layer & Model) — Pemrograman Aplikasi Bergerak
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — pemetaan JSON ke factory constructor fromJson dan isolasi lapisan service HTTP

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Model data pesanan yang dipetakan dari & ke format JSON REST API
class PesananApi {
  const PesananApi({
    required this.id,
    required this.namaMenu,
    required this.rincianPesanan,
    required this.userId,
  });

  final int id;
  final String namaMenu;
  final String rincianPesanan;
  final int userId;

  /// Mengonversi Map JSON dari response API menjadi objek PesananApi secara aman (null-safe)
  factory PesananApi.fromJson(Map<String, dynamic> json) {
    return PesananApi(
      id: json['id'] as int? ?? 0,
      namaMenu: json['title'] as String? ?? 'Menu Tanpa Nama',
      rincianPesanan: json['body'] as String? ?? 'Tidak ada rincian pesanan',
      userId: json['userId'] as int? ?? 1,
    );
  }

  /// Mengonversi objek PesananApi menjadi Map JSON untuk dikirim melalui HTTP POST
  Map<String, dynamic> toJson() {
    return {
      'title': namaMenu,
      'body': rincianPesanan,
      'userId': userId,
    };
  }
}

/// Lapisan Service — mengisolasi seluruh request HTTP GET & POST dari widget UI
class KantinApiService {
  // Ubah URL ini menjadi salah (misal tambah '/salah') saat mengambil screenshot-error.png
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Mengambil daftar pesanan/menu dari server menggunakan HTTP GET
  static Future<List<PesananApi>> ambilDaftarPesanan() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> dataJson = jsonDecode(response.body) as List<dynamic>;
        return dataJson
            .take(10) // Mengambil 10 entri teratas agar tampilan daftar ringkas
            .map((item) => PesananApi.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint pesanan tidak ditemukan di server (HTTP 404).');
      } else {
        throw Exception('Server gagal memuat data (HTTP ${response.statusCode}).');
      }
    } on TimeoutException {
      throw Exception('Waktu koneksi habis (timeout). Periksa jaringan internet Anda.');
    } catch (e) {
      throw Exception('Gagal terhubung ke server kantin: $e');
    }
  }

  /// Mengirim data pesanan baru ke server menggunakan HTTP POST
  static Future<PesananApi> kirimPesananBaru({
    required String namaMenu,
    required String rincianPesanan,
  }) async {
    final url = Uri.parse(baseUrl);
    final payload = {
      'title': namaMenu,
      'body': rincianPesanan,
      'userId': 1,
    };

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> hasilJson =
            jsonDecode(response.body) as Map<String, dynamic>;
        return PesananApi.fromJson(hasilJson);
      } else {
        throw Exception('Gagal mengirim pesanan baru (HTTP ${response.statusCode}).');
      }
    } on TimeoutException {
      throw Exception('Waktu pengiriman habis (timeout). Silakan coba lagi.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengirim pesanan: $e');
    }
  }
}
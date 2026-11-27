
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/data_pengguna.dart';
import '../models/data_pengajuan.dart';
import '../models/data_pengajuan_ringkas.dart';

class IntegrasiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;

  IntegrasiService({http.Client? client})
      : _client = client ?? http.Client();

  // Mengambil data pengguna dari endpoint /users.
  Future<List<DataPengguna>> ambilDataPengguna() async {
    final url = Uri.parse('$_baseUrl/users');

    try {
      final response = await _client
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil data pengguna. '
          'Kode: ${response.statusCode}',
        );
      }

      final List<dynamic> hasilJson = jsonDecode(response.body);

      return hasilJson
          .map(
            (data) => DataPengguna.fromJson(
              data as Map<String, dynamic>,
            ),
          )
          .toList();
    } on TimeoutException {
      throw Exception('Permintaan data pengguna melewati batas waktu.');
    } on FormatException {
      throw Exception('Format data pengguna dari server tidak valid.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server pengguna.');
    }
  }

  // Mengambil data pengajuan simulasi dari endpoint /posts.
  Future<List<DataPengajuan>> ambilDataPengajuan() async {
    final url = Uri.parse('$_baseUrl/posts');

    try {
      final response = await _client
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil data pengajuan. '
          'Kode: ${response.statusCode}',
        );
      }

      final List<dynamic> hasilJson = jsonDecode(response.body);

      return hasilJson
          .map(
            (data) => DataPengajuan.fromJson(
              data as Map<String, dynamic>,
            ),
          )
          .toList();
    } on TimeoutException {
      throw Exception('Permintaan data pengajuan melewati batas waktu.');
    } on FormatException {
      throw Exception('Format data pengajuan dari server tidak valid.');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server pengajuan.');
    }
  }

  // Mengambil dan menggabungkan data dari dua endpoint.
  Future<List<DataPengajuanRingkas>> ambilDataTerintegrasi() async {
    try {
      // Kedua request tidak saling bergantung sehingga dijalankan bersamaan.
      final hasil = await Future.wait([
        ambilDataPengguna(),
        ambilDataPengajuan(),
      ]);

      final daftarPengguna = hasil[0] as List<DataPengguna>;
      final daftarPengajuan = hasil[1] as List<DataPengajuan>;

      // Membuat pencarian pengguna berdasarkan ID.
      final Map<int, DataPengguna> penggunaBerdasarkanId = {
        for (final pengguna in daftarPengguna)
          pengguna.id: pengguna,
      };

      final List<DataPengajuanRingkas> dataTerintegrasi = [];

      // Menghubungkan userId pengajuan dengan id pengguna.
      for (final pengajuan in daftarPengajuan) {
        final pengguna =
            penggunaBerdasarkanId[pengajuan.userId];

        // Lewati pengajuan jika pengguna tidak ditemukan.
        if (pengguna == null) {
          continue;
        }

        dataTerintegrasi.add(
          DataPengajuanRingkas(
            idPengajuan: pengajuan.id,
            idPengguna: pengguna.id,
            namaPemohon: pengguna.nama,
            emailPemohon: pengguna.email,
            judulPengajuan: pengajuan.judul,
            deskripsi: pengajuan.deskripsi,
            status: pengajuan.status,
          ),
        );
      }

      return dataTerintegrasi;
    } catch (e) {
      throw Exception('Gagal mengintegrasikan data: $e');
    }
  }

  // Menutup koneksi HTTP ketika service tidak digunakan.
  void dispose() {
    _client.close();
  }
}
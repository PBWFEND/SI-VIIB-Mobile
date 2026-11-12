import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Model satu anggota dalam pengajuan SIPORA.
class AnggotaPengajuanApi {
  final String nama;
  final String nimNpm;

  const AnggotaPengajuanApi({required this.nama, required this.nimNpm});

  factory AnggotaPengajuanApi.fromJson(Map<String, dynamic> json) {
    return AnggotaPengajuanApi(
      nama: _nilaiTeks(json['nama'], nilaiDefault: 'Nama tidak tersedia'),
      nimNpm: _nilaiTeks(json['nimNpm'], nilaiDefault: '-'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'nama': nama, 'nimNpm': nimNpm};
  }
}

/// Model data pengajuan yang diterima dan dikirim melalui REST API.
class PengajuanApi {
  final String? id;
  final String jenisPengajuan;
  final String jenisPelaksanaan;
  final List<AnggotaPengajuanApi> anggota;
  final String semester;
  final String programStudi;
  final String whatsapp;
  final String tempat;
  final String alamat;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String topik;
  final bool untukMataKuliah;
  final String mataKuliah;
  final String status;
  final DateTime? dibuatPada;

  const PengajuanApi({
    this.id,
    required this.jenisPengajuan,
    this.jenisPelaksanaan = 'Individu',
    this.anggota = const [],
    this.semester = '-',
    this.programStudi = '-',
    this.whatsapp = '-',
    this.tempat = '-',
    this.alamat = '-',
    this.tanggalMulai = '-',
    this.tanggalSelesai = '-',
    this.topik = '-',
    this.untukMataKuliah = false,
    this.mataKuliah = '',
    this.status = 'Diproses',
    this.dibuatPada,
  });

  /// Membaca data JSON dari REST API.
  ///
  /// Bentuk respons koleksi:
  /// {
  ///   "id": "1",
  ///   "name": "Pengajuan Observasi - Nama Mahasiswa",
  ///   "data": {
  ///     "jenisPengajuan": "Observasi",
  ///     ...
  ///   },
  ///   "createdAt": "2026-11-12T10:00:00.000Z"
  /// }
  factory PengajuanApi.fromJson(Map<String, dynamic> json) {
    final dataMentah = json['data'];
    final Map<String, dynamic> data;

    if (dataMentah is Map) {
      data = Map<String, dynamic>.from(dataMentah);
    } else {
      // Tetap toleran jika API mengirim atribut langsung di root JSON.
      data = json;
    }

    final anggotaMentah = data['anggota'];
    final daftarAnggota = <AnggotaPengajuanApi>[];

    if (anggotaMentah is List) {
      for (final item in anggotaMentah) {
        if (item is Map) {
          daftarAnggota.add(
            AnggotaPengajuanApi.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return PengajuanApi(
      id: json['id']?.toString(),
      jenisPengajuan: _nilaiTeks(
        data['jenisPengajuan'],
        nilaiDefault: 'Pengajuan Surat',
      ),
      jenisPelaksanaan: _nilaiTeks(
        data['jenisPelaksanaan'],
        nilaiDefault: 'Individu',
      ),
      anggota: daftarAnggota,
      semester: _nilaiTeks(data['semester'], nilaiDefault: '-'),
      programStudi: _nilaiTeks(data['programStudi'], nilaiDefault: '-'),
      whatsapp: _nilaiTeks(data['whatsapp'], nilaiDefault: '-'),
      tempat: _nilaiTeks(data['tempat'], nilaiDefault: '-'),
      alamat: _nilaiTeks(data['alamat'], nilaiDefault: '-'),
      tanggalMulai: _nilaiTeks(data['tanggalMulai'], nilaiDefault: '-'),
      tanggalSelesai: _nilaiTeks(data['tanggalSelesai'], nilaiDefault: '-'),
      topik: _nilaiTeks(data['topik'], nilaiDefault: '-'),
      untukMataKuliah: _nilaiBoolean(data['untukMataKuliah']),
      mataKuliah: _nilaiTeks(data['mataKuliah'], nilaiDefault: ''),
      status: _nilaiTeks(data['status'], nilaiDefault: 'Diproses'),
      dibuatPada: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }

  /// Membentuk objek PengajuanApi dari hasil FormInteraksiPage.
  factory PengajuanApi.dariFormulir(Map<String, dynamic> formulir) {
    final anggotaMentah = formulir['anggota'];
    final daftarAnggota = <AnggotaPengajuanApi>[];

    if (anggotaMentah is List) {
      for (final item in anggotaMentah) {
        if (item is Map) {
          final anggota = Map<String, dynamic>.from(item);

          daftarAnggota.add(
            AnggotaPengajuanApi(
              nama: _nilaiTeks(
                anggota['nama'],
                nilaiDefault: 'Nama tidak tersedia',
              ),
              nimNpm: _nilaiTeks(anggota['nimNpm'], nilaiDefault: '-'),
            ),
          );
        }
      }
    }

    return PengajuanApi(
      jenisPengajuan: _nilaiTeks(
        formulir['jenisPengajuan'],
        nilaiDefault: 'Pengajuan Surat',
      ),
      jenisPelaksanaan: _nilaiTeks(
        formulir['jenisPelaksanaan'],
        nilaiDefault: 'Individu',
      ),
      anggota: daftarAnggota,
      semester: _nilaiTeks(formulir['semester'], nilaiDefault: '-'),
      programStudi: _nilaiTeks(formulir['programStudi'], nilaiDefault: '-'),
      whatsapp: _nilaiTeks(formulir['whatsapp'], nilaiDefault: '-'),
      tempat: _nilaiTeks(formulir['tempat'], nilaiDefault: '-'),
      alamat: _nilaiTeks(formulir['alamat'], nilaiDefault: '-'),
      tanggalMulai: _formatTanggal(formulir['tanggalMulai']),
      tanggalSelesai: _formatTanggal(formulir['tanggalSelesai']),
      topik: _nilaiTeks(formulir['topik'], nilaiDefault: '-'),
      untukMataKuliah: _nilaiBoolean(formulir['untukMataKuliah']),
      mataKuliah: _nilaiTeks(formulir['mataKuliah'], nilaiDefault: ''),
      status: 'Diproses',
    );
  }

  /// Mengubah objek menjadi body JSON untuk request POST.
  ///
  /// RESTful API Dev menerima bentuk:
  /// {
  ///   "name": "...",
  ///   "data": { ... }
  /// }
  Map<String, dynamic> toJson() {
    final namaMahasiswa = anggota.isNotEmpty ? anggota.first.nama : 'Mahasiswa';

    return {
      'name': 'Pengajuan $jenisPengajuan - $namaMahasiswa',
      'data': {
        'jenisPengajuan': jenisPengajuan,
        'jenisPelaksanaan': jenisPelaksanaan,
        'anggota': anggota.map((item) => item.toJson()).toList(),
        'semester': semester,
        'programStudi': programStudi,
        'whatsapp': whatsapp,
        'tempat': tempat,
        'alamat': alamat,
        'tanggalMulai': tanggalMulai,
        'tanggalSelesai': tanggalSelesai,
        'topik': topik,
        'untukMataKuliah': untukMataKuliah,
        'mataKuliah': mataKuliah,
        'status': status,
      },
    };
  }

  String get namaMahasiswa {
    if (anggota.isEmpty) return 'Mahasiswa';
    return anggota.first.nama;
  }

  int get jumlahAnggota => anggota.length;
}

/// Exception khusus untuk kesalahan komunikasi REST API.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Service untuk GET dan POST data pengajuan SIPORA.
class PengajuanApiService {
  static const String _baseUrl = 'https://api.restful-api.dev';
  static const String _namaKoleksi = 'pengajuan-sipora';

  /// API key dibaca saat aplikasi dijalankan.
  ///
  /// Jalankan dengan:
  /// flutter run -d chrome --dart-define=SIPORA_API_KEY=API_KEY_KAMU
  ///
  /// Jangan gunakan API key layanan uji ini untuk backend produksi.
  static const String _apiKey = String.fromEnvironment('SIPORA_API_KEY');

  static const Duration _timeout = Duration(seconds: 15);

  Uri get _endpoint => Uri.parse('$_baseUrl/collections/$_namaKoleksi/objects');

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
    'x-api-key': _apiKey,
  };

  void _pastikanApiKeyTersedia() {
    if (_apiKey.trim().isEmpty) {
      throw const ApiException(
        'API key belum diatur. Jalankan aplikasi dengan '
        '--dart-define=SIPORA_API_KEY=API_KEY_KAMU.',
      );
    }
  }

  /// GET: mengambil daftar pengajuan dari koleksi SIPORA.
  Future<List<PengajuanApi>> ambilDaftarPengajuan() async {
    _pastikanApiKeyTersedia();

    try {
      final response = await http
          .get(_endpoint, headers: _headers)
          .timeout(_timeout);

      // Koleksi baru dibuat otomatis ketika data pertama kali di-POST.
      // Jika koleksi belum tersedia, tampilkan kondisi data kosong.
      if (response.statusCode == 404) {
        return [];
      }

      if (response.statusCode != 200) {
        throw ApiException(
          _pesanKesalahanServer(response, tindakan: 'mengambil data'),
          statusCode: response.statusCode,
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw const FormatException(
          'Format daftar pengajuan dari server tidak sesuai.',
        );
      }

      final daftar = <PengajuanApi>[];

      for (final item in decoded) {
        if (item is! Map) {
          throw const FormatException(
            'Salah satu data pengajuan memiliki format yang tidak valid.',
          );
        }

        daftar.add(PengajuanApi.fromJson(Map<String, dynamic>.from(item)));
      }

      // Data terbaru ditampilkan lebih dahulu.
      daftar.sort((a, b) {
        final tanggalA = a.dibuatPada;
        final tanggalB = b.dibuatPada;

        if (tanggalA == null && tanggalB == null) return 0;
        if (tanggalA == null) return 1;
        if (tanggalB == null) return -1;

        return tanggalB.compareTo(tanggalA);
      });

      return daftar;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'Koneksi terlalu lama. Periksa internet dan coba kembali.',
      );
    } on FormatException {
      throw const ApiException(
        'Data dari server tidak dapat dibaca karena format JSON tidak sesuai.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet.',
      );
    } catch (error) {
      throw ApiException('Terjadi kesalahan saat mengambil data: $error');
    }
  }

  /// POST: mengirim pengajuan baru ke koleksi SIPORA.
  Future<PengajuanApi> kirimPengajuan(PengajuanApi pengajuan) async {
    _pastikanApiKeyTersedia();

    try {
      final response = await http
          .post(
            _endpoint,
            headers: _headers,
            body: jsonEncode(pengajuan.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          _pesanKesalahanServer(response, tindakan: 'mengirim pengajuan'),
          statusCode: response.statusCode,
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw const FormatException(
          'Respons pengiriman pengajuan tidak memiliki format objek JSON.',
        );
      }

      return PengajuanApi.fromJson(Map<String, dynamic>.from(decoded));
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'Pengiriman membutuhkan waktu terlalu lama. Silakan coba kembali.',
      );
    } on FormatException {
      throw const ApiException(
        'Respons server tidak dapat dibaca karena format JSON tidak sesuai.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Tidak dapat mengirim data ke server. Periksa koneksi internet.',
      );
    } catch (error) {
      throw ApiException('Terjadi kesalahan saat mengirim pengajuan: $error');
    }
  }

  String _pesanKesalahanServer(
    http.Response response, {
    required String tindakan,
  }) {
    String detail = '';

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map) {
        detail = _nilaiTeks(
          decoded['message'] ?? decoded['error'],
          nilaiDefault: '',
        );
      } else if (decoded is String) {
        detail = decoded;
      }
    } catch (_) {
      detail = '';
    }

    final pesanDasar =
        'Gagal $tindakan. '
        'Kode server: ${response.statusCode}.';

    if (detail.isEmpty) return pesanDasar;

    return '$pesanDasar $detail';
  }
}

/// Mengubah nilai apa pun menjadi teks dengan aman.
String _nilaiTeks(dynamic nilai, {required String nilaiDefault}) {
  if (nilai == null) return nilaiDefault;

  final hasil = nilai.toString().trim();

  if (hasil.isEmpty || hasil.toLowerCase() == 'null') {
    return nilaiDefault;
  }

  return hasil;
}

/// Membaca nilai boolean dari JSON atau data formulir.
bool _nilaiBoolean(dynamic nilai) {
  if (nilai is bool) return nilai;
  if (nilai is num) return nilai != 0;

  if (nilai is String) {
    final teks = nilai.toLowerCase().trim();
    return teks == 'true' || teks == '1' || teks == 'ya';
  }

  return false;
}

/// Mengubah DateTime dari formulir menjadi yyyy-MM-dd.
String _formatTanggal(dynamic nilai) {
  if (nilai is DateTime) {
    final hari = nilai.day.toString().padLeft(2, '0');
    final bulan = nilai.month.toString().padLeft(2, '0');

    return '${nilai.year}-$bulan-$hari';
  }

  if (nilai is String && nilai.trim().isNotEmpty) {
    final tanggal = DateTime.tryParse(nilai);

    if (tanggal == null) return nilai;

    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');

    return '${tanggal.year}-$bulan-$hari';
  }

  return '-';
}

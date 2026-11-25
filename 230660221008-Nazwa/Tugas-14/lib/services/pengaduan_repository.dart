import '../models/pengaduan_model.dart';
import 'token_storage_service.dart';

class KeamananTransportException implements Exception {
  final String pesan;
  const KeamananTransportException(this.pesan);

  @override
  String toString() => pesan;
}

class OtorisasiSesiException implements Exception {
  final int statusCode;
  final String pesan;
  const OtorisasiSesiException({
    required this.statusCode,
    required this.pesan,
  });

  @override
  String toString() => pesan;
}

class KoneksiLayananException implements Exception {
  final String pesan;
  const KoneksiLayananException(this.pesan);

  @override
  String toString() => pesan;
}

class PengaduanRepository {
  PengaduanRepository({
    this.baseUrl = 'https://api-fasilitas.kampus.ac.id/v1',
    required this.tokenStorage,
    this.simulasiDelay = const Duration(milliseconds: 220),
    bool muatDataAwal = true,
  }) {
    _pastikanHttps(baseUrl);
    if (muatDataAwal) {
      _dataPengaduan.addAll(_buatDataAwal());
    }
  }

  final String baseUrl;
  final TokenStorage tokenStorage;
  final Duration simulasiDelay;
  final List auditLogAman = [];
  final List _dataPengaduan = [];
  int _urutanTiket = 1003;
  bool simulasiGagalMuat = false;

  static void _pastikanHttps(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme.toLowerCase() != 'https') {
      throw const KeamananTransportException(
        'Koneksi ditolak: Endpoint wajib menggunakan HTTPS.',
      );
    }
  }

  static List _buatDataAwal() {
    final now = DateTime.now();
    final tanggalHariIni =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return [
      Pengaduan(
        id: 'TKT-1001',
        nim: '230660221008',
        email: 'nazwa@kampus.ac.id',
        lokasi: 'Lab Komputer 1 - Lantai 2',
        tanggalKejadian: tanggalHariIni,
        deskripsi:
            'Proyektor LCD utama tidak menampilkan gambar saat dihubungkan ke HDMI.',
        status: StatusPengajuan.diproses,
        namaLampiran: 'proyektor_lab1.jpg',
      ),
      Pengaduan(
        id: 'TKT-1002',
        nim: '230660221014',
        email: 'mahasiswa@kampus.ac.id',
        lokasi: 'Perpustakaan Pusat - Ruang Baca',
        tanggalKejadian: tanggalHariIni,
        deskripsi:
            'Dua unit pendingin ruangan sisi timur tidak dingin sejak pagi hari.',
        status: StatusPengajuan.menunggu,
      ),
      Pengaduan(
        id: 'TKT-1003',
        nim: '230660221021',
        email: 'andi@kampus.ac.id',
        lokasi: 'Gedung Kuliah B - Ruang B204',
        tanggalKejadian: tanggalHariIni,
        deskripsi:
            'Engsel pintu ruang kelas longgar dan sulit dikunci setelah jam kuliah.',
        status: StatusPengajuan.selesai,
        namaLampiran: 'pintu_b204.png',
      ),
    ];
  }

  void _catatLogAman(String aktivitas) {
    final waktu = DateTime.now().toIso8601String();
    auditLogAman.add('[$waktu] $aktivitas');
  }

  Future buatSesiLogin({required String nim}) async {
    _pastikanHttps(baseUrl);
    final tokenSementara =
        'sesi_${DateTime.now().millisecondsSinceEpoch}_${nim.hashCode.abs()}';
    await tokenStorage.simpan(tokenSementara);
    _catatLogAman('POST /auth/login -> 200 OK (Token tersimpan aman)');
  }

  Future logout() async {
    await tokenStorage.hapus();
    _catatLogAman('POST /auth/logout -> Token sesi dihapus');
  }

  Future ambilSemuaPengaduan() async {
    _pastikanHttps(baseUrl);
    await Future.delayed(simulasiDelay);
    if (simulasiGagalMuat) {
      _catatLogAman('GET /pengaduan -> 503 Service Unavailable');
      throw const KoneksiLayananException(
        'Gagal memuat daftar pengaduan. Periksa koneksi jaringan lalu coba lagi.',
      );
    }
    _catatLogAman(
      'GET $baseUrl/pengaduan -> 200 OK (${_dataPengaduan.length} tiket)',
    );
    return List.unmodifiable(_dataPengaduan);
  }

  Pengaduan? cariBerdasarkanId(String id) {
    for (final item in _dataPengaduan) {
      if (item is Pengaduan && item.id == id) {
        return item;
      }
    }
    return null;
  }

  Future tambahPengaduan({
    required String nim,
    required String email,
    required String lokasi,
    required String tanggalKejadian,
    required String deskripsi,
    String? namaLampiran,
  }) async {
    _pastikanHttps(baseUrl);

    final String? token = await tokenStorage.baca();
    if (token == null || token.isEmpty) {
      _catatLogAman('POST /pengaduan -> 401 Unauthorized');
      throw const OtorisasiSesiException(
        statusCode: 401,
        pesan:
            'Sesi login telah berakhir (401). Tekan tombol Login Sesi di bagian atas sebelum mengirim.',
      );
    }

    await Future.delayed(simulasiDelay);
    _urutanTiket += 1;
    final pengaduanBaru = Pengaduan(
      id: 'TKT-$_urutanTiket',
      nim: nim.trim(),
      email: email.trim().toLowerCase(),
      lokasi: lokasi.trim(),
      tanggalKejadian: tanggalKejadian.trim(),
      deskripsi: deskripsi.trim(),
      status: StatusPengajuan.menunggu,
      namaLampiran: namaLampiran,
    );

    _dataPengaduan.insert(0, pengaduanBaru);
    _catatLogAman(
      'POST $baseUrl/pengaduan -> 201 Created | Header: Authorization: Bearer [REDACTED] | ID: ${pengaduanBaru.id}',
    );
    return pengaduanBaru;
  }

  Future ubahStatus({
    required String id,
    required StatusPengajuan statusBaru,
  }) async {
    _pastikanHttps(baseUrl);
    await Future.delayed(const Duration(milliseconds: 120));
    final index = _dataPengaduan.indexWhere(
      (item) => item is Pengaduan && item.id == id,
    );
    if (index == -1) {
      throw const KoneksiLayananException('Data pengaduan tidak ditemukan.');
    }
    final lama = _dataPengaduan[index] as Pengaduan;
    final diperbarui = lama.copyWith(status: statusBaru);
    _dataPengaduan[index] = diperbarui;
    _catatLogAman(
      'PATCH $baseUrl/pengaduan/$id -> 200 OK (Status: ${statusBaru.label})',
    );
    return diperbarui;
  }

  Future hapusPengaduan(String id) async {
    _pastikanHttps(baseUrl);
    await Future.delayed(const Duration(milliseconds: 120));
    _dataPengaduan.removeWhere((item) => item is Pengaduan && item.id == id);
    _catatLogAman('DELETE $baseUrl/pengaduan/$id -> 200 OK');
  }
}

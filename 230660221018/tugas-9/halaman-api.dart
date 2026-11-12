import 'package:flutter/material.dart';

import 'form-interaksi.dart';
import 'service-api.dart';

class HalamanApiPage extends StatefulWidget {
  const HalamanApiPage({super.key});

  @override
  State<HalamanApiPage> createState() => _HalamanApiPageState();
}

class _HalamanApiPageState extends State<HalamanApiPage> {
  final PengajuanApiService _apiService = PengajuanApiService();

  final List<PengajuanApi> _daftarPengajuan = [];

  bool _isLoading = true;
  bool _isSending = false;

  String? _errorMessage;

  static const Color _warnaUtama = Color(0xFF2457C5);
  static const Color _warnaLatar = Color(0xFFF5F7FC);

  @override
  void initState() {
    super.initState();
    _muatPengajuan();
  }

  // ============================================================
  // MENGAMBIL DATA DARI API (GET)
  // ============================================================

  Future<void> _muatPengajuan({bool tampilkanLoading = true}) async {
    if (tampilkanLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      final hasil = await _apiService.ambilDaftarPengajuan();

      if (!mounted) return;

      setState(() {
        _daftarPengajuan
          ..clear()
          ..addAll(hasil);

        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = _pesanError(error);
      });
    } finally {
      if (mounted && tampilkanLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // MEMBUKA FORMULIR PENGAJUAN
  // ============================================================

  Future<void> _bukaFormulir() async {
    if (_isSending) return;

    final hasilForm = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => FormInteraksiPage()),
    );

    if (!mounted || hasilForm == null) return;

    await _kirimPengajuan(hasilForm);
  }

  // ============================================================
  // MENGIRIM DATA KE API (POST)
  // ============================================================

  Future<void> _kirimPengajuan(Map<String, dynamic> hasilForm) async {
    setState(() {
      _isSending = true;
    });

    try {
      // Mengubah hasil formulir menjadi model PengajuanApi.
      final dataBaru = PengajuanApi.dariFormulir(hasilForm);

      // Mengirim data ke REST API.
      final hasil = await _apiService.kirimPengajuan(dataBaru);

      if (!mounted) return;

      // Memasukkan data yang berhasil dikirim ke daftar.
      setState(() {
        _daftarPengajuan.insert(0, hasil);
        _errorMessage = null;
      });

      _tampilkanPesan('Pengajuan berhasil dikirim.', berhasil: true);
    } catch (error) {
      if (!mounted) return;

      _tampilkanPesan(
        'Pengajuan belum berhasil dikirim. ${_pesanError(error)}',
        berhasil: false,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  // ============================================================
  // PESAN DAN FORMAT DATA
  // ============================================================

  String _pesanError(Object error) {
    final pesan = error.toString().trim();

    if (pesan.isEmpty) {
      return 'Terjadi kesalahan saat menghubungi server.';
    }

    return pesan;
  }

  String _teks(Object? nilai, {String pengganti = '-'}) {
    if (nilai == null) return pengganti;

    final hasil = nilai.toString().trim();

    return hasil.isEmpty ? pengganti : hasil;
  }

  String _formatTanggal(Object? nilai) {
    if (nilai == null) return 'Belum ditentukan';

    DateTime? tanggal;

    if (nilai is DateTime) {
      tanggal = nilai;
    } else {
      tanggal = DateTime.tryParse(nilai.toString());
    }

    if (tanggal == null) return 'Belum ditentukan';

    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');

    return '$hari/$bulan/${tanggal.year}';
  }

  String _formatRentangTanggal(Object? mulai, Object? selesai) {
    final tanggalMulai = _formatTanggal(mulai);
    final tanggalSelesai = _formatTanggal(selesai);

    if (tanggalMulai == 'Belum ditentukan' &&
        tanggalSelesai == 'Belum ditentukan') {
      return 'Jadwal belum ditentukan';
    }

    if (tanggalMulai == tanggalSelesai) {
      return tanggalMulai;
    }

    return '$tanggalMulai - $tanggalSelesai';
  }

  void _tampilkanPesan(String pesan, {required bool berhasil}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(pesan),
          behavior: SnackBarBehavior.floating,
          backgroundColor: berhasil
              ? const Color(0xFF18794E)
              : const Color(0xFFB42318),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  // ============================================================
  // TAMPILAN UTAMA
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _warnaLatar,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'SIPORA',
          style: TextStyle(
            color: Color(0xFF1B2B4B),
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Muat ulang data',
            onPressed: _isLoading ? null : () => _muatPengajuan(),
            icon: const Icon(Icons.refresh_rounded, color: _warnaUtama),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                Expanded(child: _buildKonten()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER HALAMAN
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LAYANAN AKADEMIK',
                      style: TextStyle(
                        color: _warnaUtama,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Pengajuan Surat',
                      style: TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kelola dan pantau pengajuan surat '
                      'observasi maupun riset akademik.',
                      style: TextStyle(
                        color: Colors.blueGrey.shade600,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F0FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: _warnaUtama,
                  size: 29,
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),

          // Tombol membuka formulir.
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: _isSending ? null : _bukaFormulir,
              style: FilledButton.styleFrom(
                backgroundColor: _warnaUtama,
                disabledBackgroundColor: Colors.blueGrey.shade200,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: _isSending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.add_rounded, size: 21),
              label: Text(
                _isSending ? 'Mengirim Pengajuan...' : 'Buat Pengajuan Baru',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KONTEN DATA API
  // ============================================================

  Widget _buildKonten() {
    if (_isLoading) {
      return _buildLoading();
    }

    if (_errorMessage != null && _daftarPengajuan.isEmpty) {
      return _buildError();
    }

    final tampilkanError = _errorMessage != null;
    final daftarKosong = _daftarPengajuan.isEmpty;

    final jumlahData = daftarKosong ? 1 : _daftarPengajuan.length;

    final jumlahItem = 1 + (tampilkanError ? 1 : 0) + jumlahData;

    return RefreshIndicator(
      color: _warnaUtama,
      onRefresh: () => _muatPengajuan(tampilkanLoading: false),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: jumlahItem,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildJudulDaftar();
          }

          if (tampilkanError && index == 1) {
            return _buildErrorBanner();
          }

          final indexData = index - 1 - (tampilkanError ? 1 : 0);

          if (daftarKosong) {
            return _buildKosong();
          }

          return _buildKartuPengajuan(_daftarPengajuan[indexData]);
        },
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 38,
            height: 38,
            child: CircularProgressIndicator(
              color: _warnaUtama,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Memuat data pengajuan...',
            style: TextStyle(
              color: Color(0xFF344563),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Mohon tunggu sebentar.',
            style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR SAAT MEMUAT DATA
  // ============================================================

  Widget _buildError() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE7EAF0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_outlined,
                  color: Color(0xFFB42318),
                  size: 31,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Data Belum Dapat Dimuat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF172B4D),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'Terjadi kendala saat menghubungkan '
                'aplikasi dengan server.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey.shade600,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFB42318),
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: FilledButton.icon(
                  onPressed: () => _muatPengajuan(),
                  style: FilledButton.styleFrom(
                    backgroundColor: _warnaUtama,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(
                    'Coba Lagi',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ERROR SAAT REFRESH
  // ============================================================

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F1),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFF5C5BF)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFB42318),
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pembaruan data gagal. '
              '${_errorMessage ?? ''}',
              style: const TextStyle(
                color: Color(0xFF912018),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // JUDUL DAFTAR PENGAJUAN
  // ============================================================

  Widget _buildJudulDaftar() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 14),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Daftar Pengajuan',
              style: TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F0FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_daftarPengajuan.length} Pengajuan',
              style: const TextStyle(
                color: _warnaUtama,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KONDISI DATA KOSONG
  // ============================================================

  Widget _buildKosong() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF3FA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.folder_open_outlined,
              color: Color(0xFF718096),
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Pengajuan',
            style: TextStyle(
              color: Color(0xFF172B4D),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daftar pengajuan masih kosong. '
            'Silakan buat pengajuan baru untuk memulai.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey.shade600,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 19),
          OutlinedButton.icon(
            onPressed: _isSending ? null : _bukaFormulir,
            style: OutlinedButton.styleFrom(
              foregroundColor: _warnaUtama,
              side: const BorderSide(color: _warnaUtama),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Buat Pengajuan',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KARTU DATA PENGAJUAN
  // ============================================================

  Widget _buildKartuPengajuan(PengajuanApi data) {
    final jenis = _teks(data.jenisPengajuan, pengganti: 'Pengajuan Surat');

    final topik = _teks(data.topik, pengganti: 'Topik belum diisi');

    final namaMahasiswa = _teks(data.namaMahasiswa, pengganti: 'Mahasiswa');

    final programStudi = _teks(
      data.programStudi,
      pengganti: 'Program studi belum diisi',
    );

    final tempat = _teks(data.tempat, pengganti: 'Tempat belum diisi');

    final status = _teks(data.status, pengganti: 'Diproses');

    final jumlahAnggota = data.jumlahAnggota;

    final tanggal = _formatRentangTanggal(
      data.tanggalMulai,
      data.tanggalSelesai,
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE7EAF0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF172B4D).withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jenis surat dan status.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  jenis,
                  style: const TextStyle(
                    color: _warnaUtama,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildStatus(status),
            ],
          ),

          const SizedBox(height: 11),

          // Topik pengajuan.
          Text(
            topik,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF172B4D),
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 14),

          const Divider(height: 1, color: Color(0xFFEDF0F5)),

          const SizedBox(height: 13),

          _buildInfoRow(Icons.person_outline_rounded, namaMahasiswa),

          const SizedBox(height: 9),

          _buildInfoRow(Icons.school_outlined, programStudi),

          const SizedBox(height: 9),

          _buildInfoRow(Icons.location_on_outlined, tempat),

          const SizedBox(height: 9),

          _buildInfoRow(Icons.calendar_today_outlined, tanggal),

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: Text(
                  'ID: ${_teks(data.id)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.blueGrey.shade500,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.groups_outlined,
                size: 15,
                color: Color(0xFF718096),
              ),
              const SizedBox(width: 5),
              Text(
                '$jumlahAnggota Anggota',
                style: TextStyle(
                  color: Colors.blueGrey.shade600,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMASI TAMBAHAN PADA KARTU
  // ============================================================

  Widget _buildInfoRow(IconData ikon, String teks) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(ikon, size: 16, color: const Color(0xFF718096)),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            teks,
            style: TextStyle(
              color: Colors.blueGrey.shade700,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LABEL STATUS PENGAJUAN
  // ============================================================

  Widget _buildStatus(String status) {
    final statusLower = status.toLowerCase();

    Color warnaLatar;
    Color warnaTeks;

    if (statusLower.contains('selesai')) {
      warnaLatar = const Color(0xFFE7F6ED);
      warnaTeks = const Color(0xFF18794E);
    } else if (statusLower.contains('disetujui')) {
      warnaLatar = const Color(0xFFE9F0FF);
      warnaTeks = const Color(0xFF2457C5);
    } else if (statusLower.contains('ditolak')) {
      warnaLatar = const Color(0xFFFFEEEE);
      warnaTeks = const Color(0xFFB42318);
    } else {
      warnaLatar = const Color(0xFFFFF5E5);
      warnaTeks = const Color(0xFF9A6700);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: warnaTeks,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

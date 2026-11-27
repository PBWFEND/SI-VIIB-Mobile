
import 'package:flutter/material.dart';

import 'models/data_pengajuan_ringkas.dart';
import 'services/integrasi_service.dart';

class HalamanIntegrasi extends StatefulWidget {
  const HalamanIntegrasi({super.key});

  @override
  State<HalamanIntegrasi> createState() => _HalamanIntegrasiState();
}

class _HalamanIntegrasiState extends State<HalamanIntegrasi> {
  final IntegrasiService _integrasiService = IntegrasiService();

  List<DataPengajuanRingkas> _daftarPengajuan = [];

  bool _sedangMemuat = true;
  String? _pesanError;

  static const Color merahAkademik = Color(0xFFB21F32);
  static const Color latar = Color(0xFFF7F7F9);

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  // Mengambil data hasil integrasi dari service.
  Future<void> _muatData() async {
    setState(() {
      _sedangMemuat = true;
      _pesanError = null;
    });

    try {
      final hasil = await _integrasiService.ambilDataTerintegrasi();

      if (!mounted) return;

      setState(() {
        _daftarPengajuan = hasil;
        _sedangMemuat = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _pesanError = e.toString().replaceFirst('Exception: ', '');
        _sedangMemuat = false;
      });
    }
  }

  @override
  void dispose() {
    _integrasiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: latar,
      appBar: AppBar(
        title: const Text(
          'Integrasi Data Pengajuan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: merahAkademik,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _sedangMemuat ? null : _muatData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang Data',
          ),
        ],
      ),
      body: _bangunKonten(),
    );
  }

  // Menentukan tampilan berdasarkan kondisi data.
  Widget _bangunKonten() {
    if (_sedangMemuat) {
      return _tampilanLoading();
    }

    if (_pesanError != null) {
      return _tampilanError();
    }

    if (_daftarPengajuan.isEmpty) {
      return _tampilanKosong();
    }

    return _tampilanData();
  }

  // Tampilan ketika data sedang dimuat.
  Widget _tampilanLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: merahAkademik,
          ),
          SizedBox(height: 16),
          Text(
            'Sedang mengambil dan menggabungkan data...',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Tampilan ketika terjadi kesalahan.
  Widget _tampilanError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _pesanError ?? 'Terjadi kesalahan.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _muatData,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: merahAkademik,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan ketika API berhasil tetapi tidak ada data.
  Widget _tampilanKosong() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Data Pengajuan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Data pengajuan belum tersedia.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _muatData,
            icon: const Icon(Icons.refresh),
            label: const Text('Muat Ulang'),
          ),
        ],
      ),
    );
  }

  // Tampilan ketika data berhasil diperoleh.
  Widget _tampilanData() {
    return RefreshIndicator(
      onRefresh: _muatData,
      color: merahAkademik,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _kartuRingkasan(),
          const SizedBox(height: 20),
          const Text(
            'Daftar Pengajuan Terintegrasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._daftarPengajuan.map(
            (pengajuan) => _kartuPengajuan(pengajuan),
          ),
        ],
      ),
    );
  }

  // Kartu jumlah data pengajuan.
  Widget _kartuRingkasan() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: merahAkademik,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.assignment,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Pengajuan Terintegrasi',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_daftarPengajuan.length} Pengajuan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kartu informasi setiap pengajuan.
  Widget _kartuPengajuan(DataPengajuanRingkas pengajuan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  color: merahAkademik,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pengajuan.judulPengajuan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _barisInformasi(
              Icons.person_outline,
              'Pemohon',
              pengajuan.namaPemohon,
            ),
            const SizedBox(height: 8),
            _barisInformasi(
              Icons.email_outlined,
              'Email',
              pengajuan.emailPemohon,
            ),
            const SizedBox(height: 8),
            _barisInformasi(
              Icons.numbers,
              'ID Pengajuan',
              pengajuan.idPengajuan.toString(),
            ),
            const SizedBox(height: 8),
            _barisInformasi(
              Icons.description_outlined,
              'Deskripsi',
              pengajuan.deskripsi,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pengajuan.status.toUpperCase(),
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan informasi dalam satu baris.
  Widget _barisInformasi(
    IconData ikon,
    String label,
    String nilai,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          ikon,
          size: 19,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 85,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(': '),
        Expanded(
          child: Text(nilai),
        ),
      ],
    );
  }
}
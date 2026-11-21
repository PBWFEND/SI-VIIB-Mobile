import 'package:flutter/material.dart';
import 'models/pengajuan_models.dart';
import 'services/integrasi_service.dart';

void main() {
  runApp(const AplikasiIntegrasiLab());
}

class AplikasiIntegrasiLab extends StatelessWidget {
  const AplikasiIntegrasiLab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pengajuan Laboratorium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E3A8A), // Biru Navy Akademik
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
        useMaterial3: true,
      ),
      home: const HalamanDaftarTerintegrasi(),
    );
  }
}

class HalamanDaftarTerintegrasi extends StatefulWidget {
  const HalamanDaftarTerintegrasi({super.key});

  @override
  State<HalamanDaftarTerintegrasi> createState() =>
      _HalamanDaftarTerintegrasiState();
}

class _HalamanDaftarTerintegrasiState extends State<HalamanDaftarTerintegrasi> {
  bool _sedangMemuat = true;
  String? _pesanError;
  List<DataPengajuanRingkas> _semuaData = [];
  StatusPengajuan? _filterStatus;

  @override
  void initState() {
    super.initState();
    _muatDataIntegrasi();
  }

  Future<void> _muatDataIntegrasi() async {
    setState(() {
      _sedangMemuat = true;
      _pesanError = null;
    });

    try {
      final hasil = await IntegrasiService.ambilPengajuanTerintegrasi();
      setState(() {
        _semuaData = hasil;
        _sedangMemuat = false;
      });
    } catch (e) {
      setState(() {
        _pesanError = e.toString().replaceAll('Exception: ', '');
        _sedangMemuat = false;
      });
    }
  }

  List<DataPengajuanRingkas> get _dataTersaring {
    if (_filterStatus == null) return _semuaData;
    return _semuaData.where((item) => item.status == _filterStatus).toList();
  }

  int _hitungStatus(StatusPengajuan status) {
    return _semuaData.where((item) => item.status == status).length;
  }

  Color _warnaUtamaStatus(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.disetujui:
        return const Color(0xFF15803D);
      case StatusPengajuan.ditolak:
        return const Color(0xFFB91C1C);
      case StatusPengajuan.menunggu:
        return const Color(0xFFB45309);
    }
  }

  Color _warnaLatarStatus(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.disetujui:
        return const Color(0xFFDCFCE7);
      case StatusPengajuan.ditolak:
        return const Color(0xFFFEE2E2);
      case StatusPengajuan.menunggu:
        return const Color(0xFFFEF3C7);
    }
  }

  IconData _ikonStatus(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.disetujui:
        return Icons.check_circle_rounded;
      case StatusPengajuan.ditolak:
        return Icons.cancel_rounded;
      case StatusPengajuan.menunggu:
        return Icons.access_time_filled_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.science_rounded, size: 24),
            SizedBox(width: 10),
            Text(
              'Sistem Peminjaman Laboratorium',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Perbarui Data',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _sedangMemuat ? null : _muatDataIntegrasi,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            children: [
              // Banner Ringkasan Statistik
              if (!_sedangMemuat && _pesanError == null) _bangunBannerRingkasan(),

              // Bar Filter Status
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _bangunChipFilter('Semua (${_semuaData.length})', null),
                    _bangunChipFilter(
                      'Menunggu (${_hitungStatus(StatusPengajuan.menunggu)})',
                      StatusPengajuan.menunggu,
                    ),
                    _bangunChipFilter(
                      'Disetujui (${_hitungStatus(StatusPengajuan.disetujui)})',
                      StatusPengajuan.disetujui,
                    ),
                    _bangunChipFilter(
                      'Ditolak (${_hitungStatus(StatusPengajuan.ditolak)})',
                      StatusPengajuan.ditolak,
                    ),
                  ],
                ),
              ),

              Expanded(child: _bangunKontenUtama()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bangunBannerRingkasan() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.hub_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Integrasi Data Layanan Lab Terpadu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Data pemohon, jadwal ruangan, dan status verifikasi digabungkan secara otomatis.',
                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunChipFilter(String label, StatusPengajuan? targetStatus) {
    final bool terpilih = _filterStatus == targetStatus;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: terpilih ? FontWeight.w600 : FontWeight.normal,
          color: terpilih ? Colors.white : const Color(0xFF1E293B),
        ),
      ),
      selected: terpilih,
      selectedColor: const Color(0xFF1E3A8A),
      backgroundColor: Colors.white,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: terpilih ? const Color(0xFF1E3A8A) : Colors.grey.shade300,
        ),
      ),
      onSelected: (_) => setState(() => _filterStatus = targetStatus),
    );
  }

  Widget _bangunKontenUtama() {
    // 1. Kondisi Loading
    if (_sedangMemuat) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF1E3A8A)),
            SizedBox(height: 16),
            Text(
              'Memuat dan menggabungkan data pengajuan...',
              style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
            ),
          ],
        ),
      );
    }

    // 2. Kondisi Error Request
    if (_pesanError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off_rounded, size: 56, color: Colors.red.shade400),
                const SizedBox(height: 12),
                const Text(
                  'Gagal Memuat Data',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  _pesanError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                  ),
                  onPressed: _muatDataIntegrasi,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3. Kondisi Data Kosong
    final daftarTampil = _dataTersaring;
    if (daftarTampil.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_off_rounded, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Belum ada pengajuan pada kategori ini.',
              style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _muatDataIntegrasi,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Muat Ulang'),
            ),
          ],
        ),
      );
    }

    // 4. Kondisi Data Berhasil Dimuat (Sukses)
    return RefreshIndicator(
      onRefresh: _muatDataIntegrasi,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        itemCount: daftarTampil.length,
        itemBuilder: (context, index) {
          final item = daftarTampil[index];
          final warnaStatus = _warnaUtamaStatus(item.status);
          final inisial = item.namaPemohon.isNotEmpty
              ? item.namaPemohon[0].toUpperCase()
              : 'M';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: warnaStatus, width: 5),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris Atas: Avatar, Nama Pemohon, Email, dan Badge Status
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFDBEAFE),
                          child: Text(
                            inisial,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.namaPemohon,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                item.emailPemohon,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _warnaLatarStatus(item.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _ikonStatus(item.status),
                                size: 14,
                                color: warnaStatus,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                item.labelStatus,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: warnaStatus,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                    ),
                    // Informasi Ruangan
                    Row(
                      children: [
                        const Icon(
                          Icons.meeting_room_rounded,
                          size: 16,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.namaRuang,
                            style: const TextStyle(
                              color: Color(0xFF1D4ED8),
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Informasi Keperluan
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.keperluan,
                            style: const TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
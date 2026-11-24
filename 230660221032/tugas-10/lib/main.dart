import 'package:flutter/material.dart';

import 'models/data_jadwal.dart';
import 'models/jadwal_terintegrasi.dart';
import 'services/integrasi_service.dart';

void main() {
  runApp(const RadiActIntegrasiApp());
}

/// Aplikasi RadiAct - Integrasi Data Multi-Endpoint dan Proses Bisnis
class RadiActIntegrasiApp extends StatelessWidget {
  const RadiActIntegrasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadiAct - Integrasi Proses Bisnis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD700),
          primary: const Color(0xFFFFD700),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 238, 7),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),
        ),
      ),
      home: const HalamanIntegrasiJadwal(),
    );
  }
}

class HalamanIntegrasiJadwal extends StatefulWidget {
  const HalamanIntegrasiJadwal({super.key});

  @override
  State<HalamanIntegrasiJadwal> createState() => _HalamanIntegrasiJadwalState();
}

class _HalamanIntegrasiJadwalState extends State<HalamanIntegrasiJadwal> {
  bool _sedangMemuat = true;
  String? _pesanError;
  List<JadwalTerintegrasi> _semuaJadwal = [];
  StatusJadwal? _filterStatus; // null = tampilkan semua

  @override
  void initState() {
    super.initState();
    _muatDataTerintegrasi();
  }

  /// Memanggil Service Integrasi (menggabungkan /users dan /posts)
  Future<void> _muatDataTerintegrasi() async {
    setState(() {
      _sedangMemuat = true;
      _pesanError = null;
    });

    try {
      final hasil = await IntegrasiService.ambilJadwalTerintegrasi();
      if (!mounted) return;
      setState(() {
        _semuaJadwal = hasil;
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

  /// Menerapkan perubahan status sesuai aturan proses bisnis di IntegrasiService
  void _prosesUbahStatus(JadwalTerintegrasi jadwal, StatusJadwal statusBaru) {
    final pesanTolak = IntegrasiService.validasiPerubahanStatus(
      jadwal.status,
      statusBaru,
    );

    if (pesanTolak != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pesanTolak),
          backgroundColor: Colors.red.shade800,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() {
      final idx = _semuaJadwal.indexWhere((item) => item.id == jadwal.id);
      if (idx != -1) {
        _semuaJadwal[idx] = jadwal.salinDenganStatus(statusBaru);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Status "${jadwal.judul}" diperbarui menjadi ${statusBaru.label}.',
        ),
        backgroundColor: Colors.amber.shade900,
      ),
    );
  }

  void _bukaDialogStatus(JadwalTerintegrasi jadwal) {
    showDialog(
      context: context,
      builder: (context) {
        StatusJadwal pilihan = jadwal.status;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Perbarui Status Proses'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Program: ${jadwal.judul}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'PJ: ${jadwal.namaPenanggungJawab}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  ...StatusJadwal.values.map((st) {
                    return RadioListTile<StatusJadwal>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(st.label),
                      value: st,
                      groupValue: pilihan,
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => pilihan = val);
                        }
                      },
                    );
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _prosesUbahStatus(jadwal, pilihan);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final daftarTampil = _filterStatus == null
        ? _semuaJadwal
        : _semuaJadwal.where((j) => j.status == _filterStatus).toList();

    final totalSemua = _semuaJadwal.length;
    final totalProgres = _semuaJadwal
        .where((j) => j.status == StatusJadwal.progres)
        .length;
    final totalTayang = _semuaJadwal
        .where((j) => j.status == StatusJadwal.tayang)
        .length;
    final totalTerkendala = _semuaJadwal
        .where((j) => j.status == StatusJadwal.terkendala)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RadiAct • Integrasi Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang Data Gabungan',
            onPressed: _sedangMemuat ? null : _muatDataTerintegrasi,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 4),
            child: Text(
              'Hallo Deyna! Jadwal & Penanggung Jawab Divisi',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Data digabungkan dari endpoint /posts & /users via userId',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 12),
          // Kartu Ringkasan Statistik
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _KotakRingkasan(label: 'Total', jumlah: totalSemua),
                const SizedBox(width: 8),
                _KotakRingkasan(label: 'Progres', jumlah: totalProgres),
                const SizedBox(width: 8),
                _KotakRingkasan(label: 'Tayang', jumlah: totalTayang),
                const SizedBox(width: 8),
                _KotakRingkasan(label: 'Terkendala', jumlah: totalTerkendala),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Filter Status Proses Bisnis
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _ChipFilter(
                  label: 'Semua',
                  terpilih: _filterStatus == null,
                  onTap: () => setState(() => _filterStatus = null),
                ),
                const SizedBox(width: 8),
                ...StatusJadwal.values.map((st) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _ChipFilter(
                      label: st.label,
                      terpilih: _filterStatus == st,
                      onTap: () => setState(() => _filterStatus = st),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Area Konten Utama: Loading, Error, Kosong, atau Data Sukses
          Expanded(child: _bangunKontenUtama(daftarTampil)),
        ],
      ),
    );
  }

  Widget _bangunKontenUtama(List<JadwalTerintegrasi> daftarTampil) {
    // 1. State Loading
    if (_sedangMemuat) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.black),
            SizedBox(height: 14),
            Text(
              'Menggabungkan data jadwal & penanggung jawab...',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    // 2. State Error + Tombol Coba Lagi
    if (_pesanError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 56,
                color: Colors.red.shade700,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal Memuat Data Integrasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                _pesanError!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.red.shade800),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _muatDataTerintegrasi,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.amber,
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. State Data Kosong
    if (daftarTampil.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade500),
            const SizedBox(height: 10),
            const Text(
              'Tidak Ada Data Jadwal',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _filterStatus == null
                  ? 'Daftar jadwal dari server saat ini kosong.'
                  : 'Tidak ada program dengan status "${_filterStatus!.label}".',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    // 4. State Data Berhasil Dimuat
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: _muatDataTerintegrasi,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        itemCount: daftarTampil.length,
        itemBuilder: (context, index) {
          final item = daftarTampil[index];
          return _KartuJadwalTerintegrasi(
            jadwal: item,
            onUbahStatus: () => _bukaDialogStatus(item),
          );
        },
      ),
    );
  }
}

class _KotakRingkasan extends StatelessWidget {
  const _KotakRingkasan({required this.label, required this.jumlah});

  final String label;
  final int jumlah;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(
              '$jumlah',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipFilter extends StatelessWidget {
  const _ChipFilter({
    required this.label,
    required this.terpilih,
    required this.onTap,
  });

  final String label;
  final bool terpilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: terpilih ? Colors.amber : Colors.black87,
        ),
      ),
      selected: terpilih,
      selectedColor: Colors.black,
      backgroundColor: Colors.white,
      onSelected: (_) => onTap(),
    );
  }
}

class _KartuJadwalTerintegrasi extends StatelessWidget {
  const _KartuJadwalTerintegrasi({
    required this.jadwal,
    required this.onUbahStatus,
  });

  final JadwalTerintegrasi jadwal;
  final VoidCallback onUbahStatus;

  @override
  Widget build(BuildContext context) {
    Color warnaBg;
    Color warnaTeks;
    switch (jadwal.status) {
      case StatusJadwal.tayang:
        warnaBg = Colors.green.shade100;
        warnaTeks = Colors.green.shade900;
      case StatusJadwal.terkendala:
        warnaBg = Colors.red.shade100;
        warnaTeks = Colors.red.shade900;
      case StatusJadwal.progres:
        warnaBg = Colors.blue.shade100;
        warnaTeks = Colors.blue.shade900;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${jadwal.divisi} • ${jadwal.tanggal}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: warnaBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  jadwal.status.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: warnaTeks,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            jadwal.judul,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          // Kotak Informasi Hasil Penggabungan dari Endpoint /users
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline, size: 18, color: Colors.black87),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PJ: ${jadwal.namaPenanggungJawab} (userId: ${jadwal.userId})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        jadwal.emailPenanggungJawab,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                jadwal.bisaDisetujuiTayang
                    ? 'Siap disetujui tayang'
                    : 'Status: ${jadwal.status.label}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              SizedBox(
                height: 30,
                child: OutlinedButton.icon(
                  onPressed: onUbahStatus,
                  icon: const Icon(Icons.sync_alt, size: 14),
                  label: const Text(
                    'Ubah Status',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
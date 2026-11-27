import 'package:flutter/material.dart';
import 'services/file_naskah_service.dart';
import 'services/integrasi_service.dart';

void main() {
  runApp(const RadiActIntegrasiApp());
}

class RadiActIntegrasiApp extends StatelessWidget {
  const RadiActIntegrasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadiAct - UNSAP Radio',
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
  final FileNaskahService _fileNaskahService = FileNaskahService();

  bool _sedangMemuat = true;
  String? _pesanError;
  List<JadwalTerintegrasi> _semuaJadwal = [];
  StatusJadwal? _filterStatus;

  // State lifecycle fitur perangkat (File Naskah)
  int? _idJadwalMemilihFile;
  String? _pesanStatusFile;
  bool _apakahErrorFile = false;
  JadwalTerintegrasi? _jadwalTerakhirGagalFile;

  @override
  void initState() {
    super.initState();
    _muatDataTerintegrasi();
  }

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

  Future<void> _lampirkanFileNaskah(JadwalTerintegrasi jadwal) async {
    setState(() {
      _idJadwalMemilihFile = jadwal.id;
      _pesanStatusFile = null;
      _apakahErrorFile = false;
      _jadwalTerakhirGagalFile = null;
    });

    try {
      final InfoFileNaskah? fileBaru =
          await _fileNaskahService.pilihFileNaskah();

      if (!mounted) return;

      if (fileBaru == null) {
        setState(() {
          _idJadwalMemilihFile = null;
          _apakahErrorFile = false;
          _pesanStatusFile =
              'Pemilihan file dibatalkan. Data lampiran sebelumnya tetap dipertahankan.';
        });
        return;
      }

      setState(() {
        final idx = _semuaJadwal.indexWhere((item) => item.id == jadwal.id);
        if (idx != -1) {
          _semuaJadwal[idx] = jadwal.salinDengan(fileNaskah: fileBaru);
        }
        _idJadwalMemilihFile = null;
        _apakahErrorFile = false;
        _pesanStatusFile =
            'Naskah "${fileBaru.namaFile}" (${fileBaru.ukuranTerbaca}) berhasil dilampirkan pada "${jadwal.judul}".';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _idJadwalMemilihFile = null;
        _apakahErrorFile = true;
        _jadwalTerakhirGagalFile = jadwal;
        _pesanStatusFile = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _prosesUbahStatus(JadwalTerintegrasi jadwal, StatusJadwal statusBaru) {
    final pesanTolak = IntegrasiService.validasiPerubahanStatus(
      jadwal,
      statusBaru,
    );

    if (pesanTolak != null) {
      setState(() {
        _apakahErrorFile = true;
        _jadwalTerakhirGagalFile = jadwal;
        _pesanStatusFile = pesanTolak;
      });
      return;
    }

    setState(() {
      final idx = _semuaJadwal.indexWhere((item) => item.id == jadwal.id);
      if (idx != -1) {
        _semuaJadwal[idx] = jadwal.salinDengan(status: statusBaru);
      }
      _apakahErrorFile = false;
      _pesanStatusFile =
          'Status "${jadwal.judul}" berhasil diubah menjadi ${statusBaru.label}.';
    });
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
                  if (jadwal.fileNaskah == null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '*Catatan: Lampirkan file naskah dulu agar bisa memilih status Tayang.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  RadioGroup<StatusJadwal>(
                    groupValue: pilihan,
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => pilihan = val);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: StatusJadwal.values.map((st) {
                        return RadioListTile<StatusJadwal>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(st.label),
                          value: st,
                        );
                      }).toList(),
                    ),
                  ),
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
    final totalProgres =
        _semuaJadwal.where((j) => j.status == StatusJadwal.progres).length;
    final totalTayang =
        _semuaJadwal.where((j) => j.status == StatusJadwal.tayang).length;
    final totalTerkendala =
        _semuaJadwal.where((j) => j.status == StatusJadwal.terkendala).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RadiAct'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang Data',
            onPressed: _sedangMemuat ? null : _muatDataTerintegrasi,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_pesanStatusFile != null) _bangunBannerStatusFile(),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Text(
              'Hallo Deyna! Selamat Datang.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Text(
              'Ringkasan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _KotakRingkasan(label: 'Total Program', jumlah: totalSemua),
                const SizedBox(width: 10),
                _KotakRingkasan(label: 'Progres', jumlah: totalProgres),
                const SizedBox(width: 10),
                _KotakRingkasan(label: 'Tayang', jumlah: totalTayang),
                const SizedBox(width: 10),
                _KotakRingkasan(label: 'Terkendala', jumlah: totalTerkendala),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Jadwal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _ChipFilter(
                        label: 'Semua',
                        terpilih: _filterStatus == null,
                        onTap: () => setState(() => _filterStatus = null),
                      ),
                      const SizedBox(width: 6),
                      ...StatusJadwal.values.map((st) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 6),
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
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _bangunKontenUtama(daftarTampil)),
        ],
      ),
    );
  }

  Widget _bangunBannerStatusFile() {
    return Container(
      width: double.infinity,
      color: _apakahErrorFile ? Colors.red.shade50 : Colors.amber.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            _apakahErrorFile ? Icons.warning_amber_rounded : Icons.info_outline,
            color: _apakahErrorFile ? Colors.red.shade800 : Colors.black87,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _pesanStatusFile!,
              style: TextStyle(
                color: _apakahErrorFile ? Colors.red.shade900 : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_apakahErrorFile && _jadwalTerakhirGagalFile != null)
            TextButton(
              onPressed: () => _lampirkanFileNaskah(_jadwalTerakhirGagalFile!),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() => _pesanStatusFile = null),
          ),
        ],
      ),
    );
  }

  Widget _bangunKontenUtama(List<JadwalTerintegrasi> daftarTampil) {
    if (_sedangMemuat) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.black),
            SizedBox(height: 14),
            Text(
              'Memuat jadwal & data penanggung jawab...',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

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
                'Gagal Memuat Data',
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

    if (daftarTampil.isEmpty) {
      return const Center(
        child: Text('Tidak ada jadwal pada kategori status ini.'),
      );
    }

    return RefreshIndicator(
      color: Colors.black,
      onRefresh: _muatDataTerintegrasi,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        itemCount: daftarTampil.length,
        itemBuilder: (context, index) {
          final item = daftarTampil[index];
          return _KartuJadwal2Kolom(
            jadwal: item,
            sedangMemilihFile: _idJadwalMemilihFile == item.id,
            onLampirkanFile: () => _lampirkanFileNaskah(item),
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(
              '$jumlah',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
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
          fontSize: 11,
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

class _KartuJadwal2Kolom extends StatelessWidget {
  const _KartuJadwal2Kolom({
    required this.jadwal,
    required this.sedangMemilihFile,
    required this.onLampirkanFile,
    required this.onUbahStatus,
  });

  final JadwalTerintegrasi jadwal;
  final bool sedangMemilihFile;
  final VoidCallback onLampirkanFile;
  final VoidCallback onUbahStatus;

  @override
  Widget build(BuildContext context) {
    Color warnaBg;
    Color warnaTeks;
    switch (jadwal.status) {
      case StatusJadwal.tayang:
        warnaBg = Colors.green.shade100;
        warnaTeks = Colors.green.shade800;
      case StatusJadwal.terkendala:
        warnaBg = Colors.red.shade100;
        warnaTeks = Colors.red.shade800;
      case StatusJadwal.progres:
        warnaBg = Colors.blue.shade100;
        warnaTeks = Colors.blue.shade800;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kolom Kiri: Tanggal, Judul Program, Divisi, PJ
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    jadwal.tanggal,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  jadwal.judul,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  jadwal.divisi,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'PJ: ${jadwal.namaPenanggungJawab}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Kolom Kanan: Badge Status, Kotak Catatan, Lampiran Naskah, Tombol Aksi
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
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
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    jadwal.catatan,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: jadwal.fileNaskah != null
                        ? Colors.green.shade50
                        : Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: jadwal.fileNaskah != null
                          ? Colors.green.shade300
                          : Colors.amber.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        jadwal.fileNaskah != null
                            ? Icons.description
                            : Icons.upload_file,
                        size: 16,
                        color: jadwal.fileNaskah != null
                            ? Colors.green.shade800
                            : Colors.black87,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          jadwal.fileNaskah != null
                              ? '${jadwal.fileNaskah!.namaFile} (${jadwal.fileNaskah!.ukuranTerbaca})'
                              : 'Belum ada naskah (PDF/DOC/DOCX, maks 2 MB)',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.end,
                  children: [
                    SizedBox(
                      height: 30,
                      child: OutlinedButton.icon(
                        onPressed: sedangMemilihFile ? null : onLampirkanFile,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange.shade800,
                          side: BorderSide(color: Colors.orange.shade600),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: sedangMemilihFile
                            ? const SizedBox(
                                width: 12,
                                height: 12,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.attach_file, size: 14),
                        label: Text(
                          sedangMemilihFile
                              ? 'Membuka...'
                              : (jadwal.fileNaskah == null
                                  ? 'Lampirkan Naskah'
                                  : 'Ganti Naskah'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: OutlinedButton(
                        onPressed: onUbahStatus,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: const BorderSide(color: Colors.black54),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Ubah Status',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

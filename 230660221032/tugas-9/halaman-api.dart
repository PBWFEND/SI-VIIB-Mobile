import 'package:flutter/material.dart';

import 'service-api.dart';

void main() {
  runApp(const RadiActApp());
}

/// Aplikasi Utama RadiAct dengan Peta Route Bernama
class RadiActApp extends StatelessWidget {
  const RadiActApp({super.key});

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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HalamanUtama(),
        '/tambah': (context) => const FormTambahJadwal(),
        '/detail': (context) => const DetailJadwal(),
      },
    );
  }
}

/// STATE & LAYAR UTAMA (Terintegrasi REST API GET & POST)
class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  // Tiga state utama untuk pengelolaan data dari REST API
  bool _sedangMemuat = true;
  String? _pesanError;
  List<DataJadwal> _daftarJadwal = [];

  @override
  void initState() {
    super.initState();
    _muatDataDariApi();
  }

  /// READ (GET) — Mengambil daftar jadwal dari server melalui RadiActApiService
  Future<void> _muatDataDariApi() async {
    setState(() {
      _sedangMemuat = true;
      _pesanError = null;
    });

    try {
      final hasil = await RadiActApiService.ambilDaftarJadwal();
      if (!mounted) return;
      setState(() {
        _daftarJadwal = hasil;
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

  /// CREATE (POST) — Menambahkan data hasil response POST ke state daftar
  void _tambahJadwalKeDaftar(DataJadwal baru) {
    setState(() {
      _daftarJadwal.insert(0, baru);
    });
  }

  /// UPDATE — Mengubah Status Data Berdasarkan ID pada tampilan lokal
  void _ubahStatusJadwal(String id, String statusBaru) {
    setState(() {
      final index = _daftarJadwal.indexWhere((j) => j.id == id);
      if (index != -1) {
        final lama = _daftarJadwal[index];
        _daftarJadwal[index] = DataJadwal(
          id: lama.id,
          judul: lama.judul,
          divisi: lama.divisi,
          tanggal: lama.tanggal,
          status: statusBaru,
          catatan: lama.catatan,
        );
      }
    });
  }

  /// DELETE — Menghapus Data Berdasarkan ID pada tampilan lokal
  void _hapusJadwal(String id) {
    setState(() {
      _daftarJadwal.removeWhere((j) => j.id == id);
    });
  }

  /// Dialog Konfirmasi Sebelum Hapus Data
  Future<void> _konfirmasiHapus(DataJadwal jadwal) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jadwal Konten?'),
        content: Text('Jadwal "${jadwal.judul}" akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      _hapusJadwal(jadwal.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Jadwal "${jadwal.judul}" telah dihapus.'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    }
  }

  /// Dialog Ubah Status (Update)
  void _dialogUbahStatus(DataJadwal jadwal) {
    showDialog(
      context: context,
      builder: (context) {
        String statusPilihan = jadwal.status;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Ubah Status "${jadwal.judul}"'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['Progres', 'Tayang', 'Terkendala'].map((st) {
                  return RadioListTile<String>(
                    title: Text(st),
                    value: st,
                    groupValue: statusPilihan,
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => statusPilihan = val);
                      }
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    _ubahStatusJadwal(jadwal.id, statusPilihan);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Status "${jadwal.judul}" diperbarui menjadi $statusPilihan.',
                        ),
                        backgroundColor: Colors.amber.shade900,
                      ),
                    );
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
    final textTheme = Theme.of(context).textTheme;

    // Perhitungan ringkasan statistik dinamis dari data API
    final totalProgram = _daftarJadwal.length;
    final totalProgres = _daftarJadwal
        .where((j) => j.status == 'Progres')
        .length;
    final totalTayang = _daftarJadwal.where((j) => j.status == 'Tayang').length;
    final totalTerkendala = _daftarJadwal
        .where((j) => j.status == 'Terkendala')
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RadiAct'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang dari Server',
            onPressed: _sedangMemuat ? null : _muatDataDariApi,
          ),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Sapaan User
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              'Hallo Deyna! Selamat Datang.',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Section Ringkasan Statistik
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ringkasan',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _ItemBadgeRingkasan(
                      label: 'Total Program',
                      jumlah: totalProgram,
                    ),
                    const SizedBox(width: 8),
                    _ItemBadgeRingkasan(label: 'Progres', jumlah: totalProgres),
                    const SizedBox(width: 8),
                    _ItemBadgeRingkasan(label: 'Tayang', jumlah: totalTayang),
                    const SizedBox(width: 8),
                    _ItemBadgeRingkasan(
                      label: 'Terkendala',
                      jumlah: totalTerkendala,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Daftar Jadwal (REST API)',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Area Konten Utama menangani 3 State: Loading, Error (+ Coba Lagi), dan Sukses
          Expanded(child: _bangunAreaDaftarJadwal()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (_sedangMemuat || _pesanError != null)
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final hasil = await Navigator.pushNamed(context, '/tambah');
                if (hasil is DataJadwal) {
                  _tambahJadwalKeDaftar(hasil);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Jadwal "${hasil.judul}" berhasil dikirim ke server!',
                        ),
                        backgroundColor: Colors.amber.shade900,
                      ),
                    );
                  }
                }
              },
              backgroundColor: Colors.black,
              foregroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, size: 28),
            ),
    );
  }

  /// Widget Pengelola 3 Kondisi Antarmuka (Loading, Error, Sukses)
  Widget _bangunAreaDaftarJadwal() {
    // 1. Kondisi Loading
    if (_sedangMemuat) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.black),
            SizedBox(height: 14),
            Text(
              'Memuat jadwal konten dari server...',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    // Kondisi Error + Tombol Coba Lagi
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
                'Gagal Memuat Jadwal',
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
                onPressed: _muatDataDariApi,
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

    // Kondisi Kosong
    if (_daftarJadwal.isEmpty) {
      return const KeadaanKosong();
    }

    // Kondisi Sukses (ListView.builder)
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: _muatDataDariApi,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
        itemCount: _daftarJadwal.length,
        itemBuilder: (context, index) {
          final jadwal = _daftarJadwal[index];
          return KartuJadwal(
            jadwal: jadwal,
            onEdit: () => _dialogUbahStatus(jadwal),
            onHapus: () => _konfirmasiHapus(jadwal),
          );
        },
      ),
    );
  }
}

/// Widget Badge Ringkasan Bulat
class _ItemBadgeRingkasan extends StatelessWidget {
  const _ItemBadgeRingkasan({required this.label, required this.jumlah});

  final String label;
  final int jumlah;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              '$jumlah',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget Kartu Jadwal Konten
class KartuJadwal extends StatelessWidget {
  const KartuJadwal({
    super.key,
    required this.jadwal,
    required this.onEdit,
    required this.onHapus,
  });

  final DataJadwal jadwal;
  final VoidCallback onEdit;
  final VoidCallback onHapus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Theme.of(context).colorScheme.primaryContainer,
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: jadwal);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        jadwal.tanggal,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ChipStatus(status: jadwal.status),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jadwal.judul,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jadwal.divisi,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          jadwal.catatan.isEmpty ? '-' : jadwal.catatan,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 28,
                      child: OutlinedButton(
                        onPressed: onEdit,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          side: BorderSide(color: Colors.amber.shade800),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 28,
                      child: OutlinedButton(
                        onPressed: onHapus,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          side: BorderSide(color: Colors.red.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Hapus',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red.shade700,
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
        ),
      ),
    );
  }
}

/// Widget ChipStatus dengan Indikator Warna Visual
class ChipStatus extends StatelessWidget {
  const ChipStatus({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    if (status == 'Tayang') {
      bg = Colors.green.shade100;
      fg = Colors.green.shade900;
    } else if (status == 'Terkendala') {
      bg = Colors.red.shade100;
      fg = Colors.red.shade900;
    } else {
      bg = Colors.blue.shade100;
      fg = Colors.blue.shade900;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}

/// Keadaan Kosong (Empty State)
class KeadaanKosong extends StatelessWidget {
  const KeadaanKosong({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.radio_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Jadwal',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Jadwal konten belum tersedia di server.\nGunakan tombol + di bawah untuk membuat jadwal baru.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

/// FORM TAMBAH JADWAL (Mengirim Data Baru via HTTP POST)
class FormTambahJadwal extends StatefulWidget {
  const FormTambahJadwal({super.key});

  @override
  State<FormTambahJadwal> createState() => _FormTambahJadwalState();
}

class _FormTambahJadwalState extends State<FormTambahJadwal> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _catatanController = TextEditingController();

  String _divisiDipilih = DataJadwal.daftarDivisi.first;
  String _statusDipilih = 'Progres';
  bool _sedangMengirim = false;

  @override
  void dispose() {
    _judulController.dispose();
    _tanggalController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _kirim(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _sedangMengirim = true;
    });

    final drafJadwal = DataJadwal(
      id: '0',
      judul: _judulController.text.trim(),
      divisi: _divisiDipilih,
      tanggal: _tanggalController.text.trim(),
      status: _statusDipilih,
      catatan: _catatanController.text.trim(),
    );

    try {
      // Mengirim data baru ke server melalui HTTP POST
      final hasilPost = await RadiActApiService.kirimJadwalBaru(drafJadwal);
      if (!context.mounted) return;
      Navigator.pop(context, hasilPost);
    } catch (e) {
      if (!context.mounted) return;
      setState(() {
        _sedangMengirim = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Tambah Jadwal')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulController,
              enabled: !_sedangMengirim,
              decoration: const InputDecoration(
                labelText: 'Nama Program / Judul Konten',
                hintText: 'cth. Edufan Radio',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Judul konten wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _divisiDipilih,
              decoration: const InputDecoration(
                labelText: 'Divisi Pengampu',
                border: OutlineInputBorder(),
              ),
              items: DataJadwal.daftarDivisi.map((div) {
                return DropdownMenuItem(value: div, child: Text(div));
              }).toList(),
              onChanged: _sedangMengirim
                  ? null
                  : (val) {
                      if (val != null) {
                        setState(() => _divisiDipilih = val);
                      }
                    },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tanggalController,
              enabled: !_sedangMengirim,
              decoration: const InputDecoration(
                labelText: 'Tanggal Tayang',
                hintText: 'cth. 25 November 2026',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tanggal tayang wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _statusDipilih,
              decoration: const InputDecoration(
                labelText: 'Status Program',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Progres', child: Text('Progres')),
                DropdownMenuItem(value: 'Tayang', child: Text('Tayang')),
                DropdownMenuItem(
                  value: 'Terkendala',
                  child: Text('Terkendala'),
                ),
              ],
              onChanged: _sedangMengirim
                  ? null
                  : (val) {
                      if (val != null) {
                        setState(() => _statusDipilih = val);
                      }
                    },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _catatanController,
              enabled: !_sedangMengirim,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Catatan Konten (Opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol dinonaktifkan selama proses pengiriman POST berlangsung
            FilledButton.icon(
              onPressed: _sedangMengirim ? null : () => _kirim(context),
              icon: _sedangMengirim
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.amber,
                      ),
                    )
                  : const Icon(Icons.send_outlined),
              label: Text(
                _sedangMengirim ? 'Mengirim ke Server...' : 'Kirim Jadwal',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.black,
                foregroundColor: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// LAYAR DETAIL JADWAL
class DetailJadwal extends StatelessWidget {
  const DetailJadwal({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final jadwal = args is DataJadwal ? args : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Jadwal Konten')),
      body: jadwal == null
          ? const Center(child: Text('Data jadwal tidak tersedia.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              jadwal.tanggal,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ChipStatus(status: jadwal.status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        jadwal.judul,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jadwal.divisi,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Divider(height: 32),
                      const Text(
                        'Catatan Konten:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          jadwal.catatan.isEmpty ? '-' : jadwal.catatan,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Kembali'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

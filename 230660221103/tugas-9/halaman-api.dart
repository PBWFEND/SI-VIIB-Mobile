// Tugas 9: Integrasi REST API (Antarmuka Pengguna) — Pemrograman Aplikasi Bergerak
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — implementasi state loading, sukses, error dengan retry, dan form POST

import 'package:flutter/material.dart';
import 'service-api.dart';

void main() {
  runApp(const KantinRestApiApp());
}

class KantinRestApiApp extends StatelessWidget {
  const KantinRestApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital — REST API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HalamanPesananApi(),
    );
  }
}

class HalamanPesananApi extends StatefulWidget {
  const HalamanPesananApi({super.key});

  @override
  State<HalamanPesananApi> createState() => _HalamanPesananApiState();
}

class _HalamanPesananApiState extends State<HalamanPesananApi> {
  // Tiga flag state untuk komunikasi jaringan
  bool _sedangMemuat = false;
  String? _pesanError;
  List<PesananApi> _daftarPesanan = [];

  @override
  void initState() {
    super.initState();
    _muatDataDariServer();
  }

  /// Memanggil HTTP GET dari KantinApiService dan memperbarui 3 state UI
  Future<void> _muatDataDariServer() async {
    setState(() {
      _sedangMemuat = true;
      _pesanError = null;
    });

    try {
      final hasil = await KantinApiService.ambilDaftarPesanan();
      if (!mounted) return;
      setState(() {
        _daftarPesanan = hasil;
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

  /// Membuka modal/halaman form untuk mengirim data baru via HTTP POST
  Future<void> _bukaFormKirimPesanan() async {
    final pesananTerkirim = await Navigator.push<PesananApi>(
      context,
      MaterialPageRoute(
        builder: (context) => const HalamanFormPostPesanan(),
      ),
    );

    if (pesananTerkirim != null) {
      setState(() {
        _daftarPesanan.insert(0, pesananTerkirim);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pesanan "${pesananTerkirim.namaMenu}" berhasil dikirim ke server (ID: ${pesananTerkirim.id}).',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrean Kantin (REST API)'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            tooltip: 'Muat Ulang Data',
            onPressed: _sedangMemuat ? null : _muatDataDariServer,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _bangunKontenUtama(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormKirimPesanan,
        icon: const Icon(Icons.cloud_upload_outlined),
        label: const Text('Kirim Pesanan (POST)'),
      ),
    );
  }

  Widget _bangunKontenUtama(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 1. STATE LOADING
    if (_sedangMemuat) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Memuat data antrean dari server kantin...',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // 2. STATE ERROR + TOMBOL RETRY
    if (_pesanError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Gagal Memuat Data',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _pesanError!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _muatDataDariServer,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // Kondisi data kosong
    if (_daftarPesanan.isEmpty) {
      return const Center(
        child: Text('Belum ada data pesanan di server.'),
      );
    }

    // 3. STATE SUKSES
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Pesanan Terpusat (${_daftarPesanan.length})',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Data disinkronkan dari server melalui HTTP GET.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _daftarPesanan.length,
              itemBuilder: (context, index) {
                final item = _daftarPesanan[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        '#${item.id}',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    title: Text(
                      item.namaMenu,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        item.rincianPesanan,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Chip(
                      label: Text(
                        'Terkirim',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      backgroundColor: colorScheme.secondaryContainer,
                      side: BorderSide.none,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Layar Form Pengiriman Pesanan Baru via HTTP POST
class HalamanFormPostPesanan extends StatefulWidget {
  const HalamanFormPostPesanan({super.key});

  @override
  State<HalamanFormPostPesanan> createState() => _HalamanFormPostPesananState();
}

class _HalamanFormPostPesananState extends State<HalamanFormPostPesanan> {
  final _formKey = GlobalKey<FormState>();
  final _namaMenuController = TextEditingController();
  final _rincianController = TextEditingController();
  bool _sedangMengirim = false;

  @override
  void dispose() {
    _namaMenuController.dispose();
    _rincianController.dispose();
    super.dispose();
  }

  Future<void> _kirimKeServer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _sedangMengirim = true;
    });

    try {
      final hasilPost = await KantinApiService.kirimPesananBaru(
        namaMenu: _namaMenuController.text.trim(),
        rincianPesanan: _rincianController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, hasilPost);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sedangMengirim = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirim Pesanan Baru (HTTP POST)'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            TextFormField(
              controller: _namaMenuController,
              enabled: !_sedangMengirim,
              decoration: const InputDecoration(
                labelText: 'Nama Menu Pesanan',
                hintText: 'Contoh: Nasi Goreng Spesial Kampus',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama menu wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rincianController,
              enabled: !_sedangMengirim,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Rincian Pemesan, Porsi & Catatan',
                hintText: 'Contoh: Reina (230660221103) - 2 Porsi, Pedas Sedang',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Rincian pesanan wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            // Tombol dinonaktifkan selama _sedangMengirim == true untuk mencegah double-submit
            FilledButton.icon(
              onPressed: _sedangMengirim ? null : _kirimKeServer,
              icon: _sedangMengirim
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(
                _sedangMengirim ? 'Mengirim ke Server...' : 'Kirim Pesanan ke API',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _sedangMengirim ? null : () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}
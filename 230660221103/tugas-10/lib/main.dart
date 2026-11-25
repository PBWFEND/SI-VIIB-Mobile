// Tugas 10: Integrasi Data dan Proses Bisnis — Halaman Utama
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — penyusunan 4 kondisi state halaman dan filter proses bisnis

import 'package:flutter/material.dart';
import 'models/model_kantin.dart';
import 'services/integrasi_kantin_service.dart';

void main() {
  runApp(const KantinIntegrasiApp());
}

class KantinIntegrasiApp extends StatelessWidget {
  const KantinIntegrasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital — Integrasi Proses Bisnis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HalamanIntegrasiPesanan(),
    );
  }
}

class HalamanIntegrasiPesanan extends StatefulWidget {
  const HalamanIntegrasiPesanan({super.key});

  @override
  State<HalamanIntegrasiPesanan> createState() =>
      _HalamanIntegrasiPesananState();
}

class _HalamanIntegrasiPesananState extends State<HalamanIntegrasiPesanan> {
  bool _sedangMemuat = true;
  String? _pesanError;
  List<PesananTerintegrasi> _semuaPesanan = [];
  StatusPesanan? _filterStatus;

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
      final hasil = await IntegrasiKantinService.ambilPesananTerintegrasi();
      if (!mounted) return;
      setState(() {
        _semuaPesanan = hasil;
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

  void _ubahStatusProses(int idPesanan) {
    setState(() {
      final index =
          _semuaPesanan.indexWhere((item) => item.idPesanan == idPesanan);
      if (index != -1) {
        final lama = _semuaPesanan[index];
        final statusBaru =
            IntegrasiKantinService.prosesTahapBerikutnya(lama.status);
        _semuaPesanan[index] = lama.salinDenganStatus(statusBaru);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status proses pesanan berhasil diperbarui.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<PesananTerintegrasi> get _daftarTampil {
    if (_filterStatus == null) {
      return _semuaPesanan;
    }
    return _semuaPesanan
        .where((item) => item.status == _filterStatus)
        .toList();
  }

  Color _warnaChip(ColorScheme scheme, StatusPesanan status) {
    switch (status) {
      case StatusPesanan.menunggu:
        return scheme.tertiaryContainer;
      case StatusPesanan.diproses:
        return scheme.primaryContainer;
      case StatusPesanan.siapDiambil:
        return scheme.secondaryContainer;
    }
  }

  Color _warnaTeksChip(ColorScheme scheme, StatusPesanan status) {
    switch (status) {
      case StatusPesanan.menunggu:
        return scheme.onTertiaryContainer;
      case StatusPesanan.diproses:
        return scheme.onPrimaryContainer;
      case StatusPesanan.siapDiambil:
        return scheme.onSecondaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrasi Pesanan & Pemesan'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            tooltip: 'Segarkan Data',
            onPressed: _sedangMemuat ? null : _muatDataTerintegrasi,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _bangunKonten(context),
    );
  }

  Widget _bangunKonten(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 1. State Loading
    if (_sedangMemuat) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Menggabungkan data pemesan dan pesanan...'),
          ],
        ),
      );
    }

    // 2. State Error + Tombol Coba Lagi
    if (_pesanError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 64, color: colorScheme.error),
              const SizedBox(height: 12),
              Text(
                'Integrasi Data Gagal',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(_pesanError!, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _muatDataTerintegrasi,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final daftar = _daftarTampil;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter status proses bisnis
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Semua'),
                  selected: _filterStatus == null,
                  onSelected: (_) => setState(() => _filterStatus = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Menunggu'),
                  selected: _filterStatus == StatusPesanan.menunggu,
                  onSelected: (_) => setState(
                    () => _filterStatus = StatusPesanan.menunggu,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Sedang Dimasak'),
                  selected: _filterStatus == StatusPesanan.diproses,
                  onSelected: (_) => setState(
                    () => _filterStatus = StatusPesanan.diproses,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Siap Diambil'),
                  selected: _filterStatus == StatusPesanan.siapDiambil,
                  onSelected: (_) => setState(
                    () => _filterStatus = StatusPesanan.siapDiambil,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 3. State Data Kosong vs 4. State Sukses
          Expanded(
            child: daftar.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 56,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tidak ada pesanan pada kategori status ini.',
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: daftar.length,
                    itemBuilder: (context, index) {
                      final item = daftar[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        colorScheme.primaryContainer,
                                    child: Text('#${item.idPesanan}'),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.namaPemesan,
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.emailPemesan,
                                          style: textTheme.bodySmall?.copyWith(
                                            color:
                                                colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      labelStatusPesanan(item.status),
                                      style: textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: _warnaTeksChip(
                                          colorScheme,
                                          item.status,
                                        ),
                                      ),
                                    ),
                                    backgroundColor:
                                        _warnaChip(colorScheme, item.status),
                                    side: BorderSide.none,
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                              Text(
                                'Menu: ${item.namaMenu}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rincian: ${item.catatan}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () =>
                                      _ubahStatusProses(item.idPesanan),
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('Proses Tahap Berikutnya'),
                                ),
                              ),
                            ],
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
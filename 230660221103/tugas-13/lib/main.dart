// Tugas 13: Testing, Debugging, dan Perbaikan — Kode Utama
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — perbaikan pencegahan double-submit (_sedangMenyimpan) dan struktur widget test

import 'package:flutter/material.dart';

void main() {
  runApp(const KantinTestingApp());
}

class ItemPesanan {
  const ItemPesanan({
    required this.id,
    required this.namaPemesan,
    required this.namaMenu,
    required this.jumlahPorsi,
  });

  final String id;
  final String namaPemesan;
  final String namaMenu;
  final int jumlahPorsi;
}

class ValidatorPesanan {
  static String? validasiNama(String? value) {
    final teks = value?.trim() ?? '';
    if (teks.isEmpty) {
      return 'Nama pemesan wajib diisi';
    }
    if (teks.length > 60) {
      return 'Nama pemesan maksimal 60 karakter';
    }
    return null;
  }

  static String? validasiMenu(String? value) {
    final teks = value?.trim() ?? '';
    if (teks.isEmpty) {
      return 'Nama menu wajib diisi';
    }
    return null;
  }

  static String? validasiPorsi(String? value) {
    final teks = value?.trim() ?? '';
    if (teks.isEmpty) {
      return 'Jumlah porsi wajib diisi';
    }
    final angka = int.tryParse(teks);
    if (angka == null || angka < 1 || angka > 50) {
      return 'Jumlah porsi harus antara 1 sampai 50';
    }
    return null;
  }
}

class KantinTestingApp extends StatelessWidget {
  const KantinTestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital — Testing & Bug Fix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HalamanPemesananTeruji(),
    );
  }
}

class HalamanPemesananTeruji extends StatefulWidget {
  const HalamanPemesananTeruji({super.key});

  @override
  State<HalamanPemesananTeruji> createState() => _HalamanPemesananTerujiState();
}

class _HalamanPemesananTerujiState extends State<HalamanPemesananTeruji> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _menuController = TextEditingController();
  final _porsiController = TextEditingController();

  final List<ItemPesanan> _daftarPesanan = [];
  bool _sedangMenyimpan = false;
  int _urutanId = 1;

  @override
  void dispose() {
    _namaController.dispose();
    _menuController.dispose();
    _porsiController.dispose();
    super.dispose();
  }

  /// Perbaikan BUG-01: Mencegah eksekusi ganda saat tombol Simpan ditekan cepat dua kali
  Future<void> _simpanPesanan() async {
    if (_sedangMenyimpan) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _sedangMenyimpan = true;
    });

    // Simulasi jeda pemrosesan transaksi 300ms
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    final pesananBaru = ItemPesanan(
      id: 'ORD-${_urutanId++}',
      namaPemesan: _namaController.text.trim(),
      namaMenu: _menuController.text.trim(),
      jumlahPorsi: int.parse(_porsiController.text.trim()),
    );

    setState(() {
      _daftarPesanan.add(pesananBaru);
      _namaController.clear();
      _menuController.clear();
      _porsiController.clear();
      _sedangMenyimpan = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesanan ${pesananBaru.namaMenu} berhasil disimpan'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Menghapus pesanan berdasarkan id unik (bukan indeks posisi)
  void _hapusPesanan(String id) {
    setState(() {
      _daftarPesanan.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Kampus Digital'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('input_nama'),
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pemesan',
                      border: OutlineInputBorder(),
                    ),
                    validator: ValidatorPesanan.validasiNama,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    key: const Key('input_menu'),
                    controller: _menuController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Menu',
                      border: OutlineInputBorder(),
                    ),
                    validator: ValidatorPesanan.validasiMenu,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    key: const Key('input_porsi'),
                    controller: _porsiController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah Porsi',
                      border: OutlineInputBorder(),
                    ),
                    validator: ValidatorPesanan.validasiPorsi,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const Key('tombol_simpan'),
                      onPressed: _sedangMenyimpan ? null : _simpanPesanan,
                      child: Text(
                        _sedangMenyimpan ? 'Menyimpan...' : 'Simpan Pesanan',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Daftar Pesanan (${_daftarPesanan.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _daftarPesanan.isEmpty
                  ? const Center(
                      child: Text('Belum ada pesanan tercatat'),
                    )
                  : ListView.builder(
                      itemCount: _daftarPesanan.length,
                      itemBuilder: (context, index) {
                        final item = _daftarPesanan[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text('${item.namaMenu} (${item.jumlahPorsi}x)'),
                            subtitle: Text('Pemesan: ${item.namaPemesan}'),
                            trailing: IconButton(
                              key: Key('hapus_${item.id}'),
                              tooltip: 'Hapus Pesanan',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _hapusPesanan(item.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
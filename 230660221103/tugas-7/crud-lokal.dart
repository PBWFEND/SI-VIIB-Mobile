// Tugas 7: MVP Awal dengan Data Lokal — Pemrograman Aplikasi Bergerak
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — penyusunan model DataPesanan dan operasi CRUD berbasis id dengan setState

import 'package:flutter/material.dart';

void main() {
  runApp(const KantinMvpApp());
}

/// Model data entitas utama aplikasi Kantin Kampus Digital
class DataPesanan {
  const DataPesanan({
    required this.id,
    required this.namaPemesan,
    required this.namaMenu,
    required this.jumlahPorsi,
    required this.catatan,
    required this.status,
  });

  final String id;
  final String namaPemesan;
  final String namaMenu;
  final int jumlahPorsi;
  final String catatan;
  final String status;

  @override
  String toString() =>
      'Pesanan #$id: $namaMenu ($jumlahPorsi porsi) - $namaPemesan [$status]';
}

class KantinMvpApp extends StatelessWidget {
  const KantinMvpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital — MVP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HalamanDaftarPesanan(),
    );
  }
}

/// Layar Daftar Pesanan (StatefulWidget dengan state CRUD lokal)
class HalamanDaftarPesanan extends StatefulWidget {
  const HalamanDaftarPesanan({super.key});

  @override
  State<HalamanDaftarPesanan> createState() => _HalamanDaftarPesananState();
}

class _HalamanDaftarPesananState extends State<HalamanDaftarPesanan> {
  // State daftar pesanan (in-memory)
  final List<DataPesanan> _daftarPesanan = [
    const DataPesanan(
      id: '1730000001',
      namaPemesan: 'Reina Anatasya',
      namaMenu: 'Nasi Goreng Spesial Kampus',
      jumlahPorsi: 1,
      catatan: 'Pedas sedang',
      status: 'menunggu',
    ),
    const DataPesanan(
      id: '1730000002',
      namaPemesan: 'Dinda Putri',
      namaMenu: 'Ayam Geprek Sambal Matah',
      jumlahPorsi: 2,
      catatan: 'Sambal dipisah',
      status: 'siap diambil',
    ),
  ];

  // CREATE: Menambah data pesanan baru ke state daftar
  Future<void> _bukaFormTambahPesanan() async {
    final pesananBaru = await Navigator.push<DataPesanan>(
      context,
      MaterialPageRoute(
        builder: (context) => const HalamanFormTambahPesanan(),
      ),
    );

    if (pesananBaru != null) {
      setState(() {
        _daftarPesanan.add(pesananBaru);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pesanan "${pesananBaru.namaMenu}" berhasil ditambahkan.'),
        ),
      );
    }
  }

  // UPDATE: Mengubah status pesanan berdasarkan id menggunakan penggantian objek
  void _ubahStatusPesanan(String id, String statusBaru) {
    setState(() {
      final index = _daftarPesanan.indexWhere((item) => item.id == id);
      if (index != -1) {
        final lama = _daftarPesanan[index];
        _daftarPesanan[index] = DataPesanan(
          id: lama.id,
          namaPemesan: lama.namaPemesan,
          namaMenu: lama.namaMenu,
          jumlahPorsi: lama.jumlahPorsi,
          catatan: lama.catatan,
          status: statusBaru,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status pesanan diperbarui menjadi "$statusBaru".'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // DELETE: Konfirmasi AlertDialog sebelum menghapus data berdasarkan id
  Future<void> _konfirmasiHapusPesanan(DataPesanan pesanan) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pesanan?'),
        content: Text(
          'Pesanan "${pesanan.namaMenu}" (${pesanan.jumlahPorsi} porsi) atas nama ${pesanan.namaPemesan} akan dihapus dari daftar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      setState(() {
        _daftarPesanan.removeWhere((item) => item.id == pesanan.id);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pesanan "${pesanan.namaMenu}" telah dihapus.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan Kantin'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Antrean Pesanan Aktif (${_daftarPesanan.length})',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Kelola pesanan masuk: perbarui status atau batalkan pesanan.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            // READ: Menampilkan daftar dari state menggunakan ListView.builder
            Expanded(
              child: _daftarPesanan.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada pesanan tercatat',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tekan tombol Tambah Pesanan untuk membuat pesanan baru.',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _daftarPesanan.length,
                      itemBuilder: (context, index) {
                        final pesanan = _daftarPesanan[index];
                        final bool isSiap = pesanan.status == 'siap diambil';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: isSiap
                                        ? colorScheme.secondaryContainer
                                        : colorScheme.primaryContainer,
                                    child: Icon(
                                      isSiap
                                          ? Icons.check_circle_outline
                                          : Icons.hourglass_top,
                                      color: isSiap
                                          ? colorScheme.secondary
                                          : colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(
                                    '${pesanan.namaMenu} (${pesanan.jumlahPorsi}x)',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Pemesan: ${pesanan.namaPemesan}\nCatatan: ${pesanan.catatan}',
                                  ),
                                  trailing: Chip(
                                    label: Text(
                                      isSiap ? 'Siap Diambil' : 'Menunggu',
                                      style: textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSiap
                                            ? colorScheme.onSecondaryContainer
                                            : colorScheme.onTertiaryContainer,
                                      ),
                                    ),
                                    backgroundColor: isSiap
                                        ? colorScheme.secondaryContainer
                                        : colorScheme.tertiaryContainer,
                                    side: BorderSide.none,
                                  ),
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Tombol Update Status
                                    TextButton.icon(
                                      onPressed: () {
                                        final statusTujuan = isSiap
                                            ? 'menunggu'
                                            : 'siap diambil';
                                        _ubahStatusPesanan(
                                          pesanan.id,
                                          statusTujuan,
                                        );
                                      },
                                      icon: const Icon(Icons.sync, size: 18),
                                      label: Text(
                                        isSiap
                                            ? 'Tandai Menunggu'
                                            : 'Tandai Siap Diambil',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Tombol Delete dengan Konfirmasi
                                    TextButton.icon(
                                      onPressed: () =>
                                          _konfirmasiHapusPesanan(pesanan),
                                      icon: Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: colorScheme.error,
                                      ),
                                      label: Text(
                                        'Hapus',
                                        style: TextStyle(
                                          color: colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormTambahPesanan,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pesanan'),
      ),
    );
  }
}

/// Layar Form Tambah Pesanan (mengembalikan objek DataPesanan saat valid)
class HalamanFormTambahPesanan extends StatefulWidget {
  const HalamanFormTambahPesanan({super.key});

  @override
  State<HalamanFormTambahPesanan> createState() =>
      _HalamanFormTambahPesananState();
}

class _HalamanFormTambahPesananState extends State<HalamanFormTambahPesanan> {
  final _formKey = GlobalKey<FormState>();
  final _namaPemesanController = TextEditingController();
  final _namaMenuController = TextEditingController();
  final _jumlahPorsiController = TextEditingController();
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    _namaPemesanController.dispose();
    _namaMenuController.dispose();
    _jumlahPorsiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _simpanData() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final catatanTeks = _catatanController.text.trim();
    final pesananBaru = DataPesanan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      namaPemesan: _namaPemesanController.text.trim(),
      namaMenu: _namaMenuController.text.trim(),
      jumlahPorsi: int.parse(_jumlahPorsiController.text.trim()),
      catatan: catatanTeks.isEmpty ? '-' : catatanTeks,
      status: 'menunggu',
    );

    Navigator.pop(context, pesananBaru);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pesanan Baru'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            TextFormField(
              controller: _namaPemesanController,
              decoration: const InputDecoration(
                labelText: 'Nama Pemesan / NIM',
                hintText: 'Contoh: Reina Anatasya',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama pemesan wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _namaMenuController,
              decoration: const InputDecoration(
                labelText: 'Nama Menu',
                hintText: 'Contoh: Soto Ayam Lamongan',
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
              controller: _jumlahPorsiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Porsi',
                hintText: 'Contoh: 2',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Jumlah porsi wajib diisi.';
                }
                final angka = int.tryParse(value.trim());
                if (angka == null || angka <= 0) {
                  return 'Masukkan jumlah porsi valid (minimal 1).';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _catatanController,
              decoration: const InputDecoration(
                labelText: 'Catatan Tambahan (Opsional)',
                hintText: 'Contoh: Tanpa seledri',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpanData,
              icon: const Icon(Icons.save),
              label: const Text('Simpan ke Daftar Pesanan'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}
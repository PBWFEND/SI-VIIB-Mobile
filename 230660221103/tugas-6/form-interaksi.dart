```dart
// Tugas 6: Navigation Flow dan Interaksi — Pemrograman Aplikasi Bergerak
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — penyusunan route bernama, pemeriksaan tipe arguments, dan siklus dispose TextEditingController

import 'package:flutter/material.dart';

void main() {
  runApp(const KantinNavigasiApp());
}

/// Model sederhana untuk pengiriman data antarlayar (read-only pada detail)
class DataMenu {
  final String nama;
  final String stan;
  final String harga;
  final String deskripsi;
  final bool tersedia;

  const DataMenu({
    required this.nama,
    required this.stan,
    required this.harga,
    required this.deskripsi,
    required this.tersedia,
  });
}

class KantinNavigasiApp extends StatelessWidget {
  const KantinNavigasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      // Pendaftaran peta route bernama secara terpusat
      initialRoute: '/',
      routes: {
        '/': (context) => const HalamanUtamaKatalog(),
        '/detail': (context) => const HalamanDetailMenu(),
        '/pesan': (context) => const HalamanFormPemesanan(),
      },
    );
  }
}

/// 1. LAYAR UTAMA (Route: '/')
class HalamanUtamaKatalog extends StatelessWidget {
  const HalamanUtamaKatalog({super.key});

  final List<DataMenu> daftarMenu = const [
    DataMenu(
      nama: 'Nasi Goreng Spesial Kampus',
      stan: 'Stan Bu Siti',
      harga: 'Rp 15.000',
      deskripsi: 'Nasi goreng bumbu rempah dengan telur mata sapi, suwiran ayam, dan kerupuk.',
      tersedia: true,
    ),
    DataMenu(
      nama: 'Ayam Geprek Sambal Matah',
      stan: 'Stan Pak Budi',
      harga: 'Rp 14.000',
      deskripsi: 'Ayam krispi geprek disajikan dengan nasi hangat dan sambal matah segar.',
      tersedia: true,
    ),
    DataMenu(
      nama: 'Soto Ayam Lamongan',
      stan: 'Stan Cak Har',
      harga: 'Rp 13.000',
      deskripsi: 'Kuah kaldu kuning gurih dengan taburan koya, soun, dan irisan ayam.',
      tersedia: false,
    ),
    DataMenu(
      nama: 'Mie Ayam Bakso Urat',
      stan: 'Stan Mas Joko',
      harga: 'Rp 12.000',
      deskripsi: 'Mie kenyal racikan sendiri dengan topping ayam kecap dan 2 butir bakso urat.',
      tersedia: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
            Text(
              'Katalog Menu Hari Ini',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Ketuk kartu menu untuk melihat detail atau tekan tombol pesan.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: daftarMenu.length,
                itemBuilder: (context, index) {
                  final menu = daftarMenu[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: menu.tersedia
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.restaurant_menu,
                          color: menu.tersedia
                              ? colorScheme.primary
                              : colorScheme.outline,
                        ),
                      ),
                      title: Text(
                        menu.nama,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text('${menu.stan} • ${menu.harga}'),
                      trailing: Chip(
                        label: Text(
                          menu.tersedia ? 'Tersedia' : 'Habis',
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: menu.tersedia
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onErrorContainer,
                          ),
                        ),
                        backgroundColor: menu.tersedia
                            ? colorScheme.secondaryContainer
                            : colorScheme.errorContainer,
                        side: BorderSide.none,
                      ),
                      // Navigasi maju sambil mengirim arguments DataMenu
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: menu,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Navigasi maju ke form pemesanan
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/pesan');
        },
        icon: const Icon(Icons.edit_note),
        label: const Text('Buat Pesanan'),
      ),
    );
  }
}

/// 2. LAYAR DETAIL MENU (Route: '/detail' — Read-Only)
class HalamanDetailMenu extends StatelessWidget {
  const HalamanDetailMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Membaca arguments dengan pemeriksaan tipe eksplisit (is) dan cabang null
    final args = ModalRoute.of(context)?.settings.arguments;
    final menu = args is DataMenu ? args : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Menu'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: menu == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 56, color: colorScheme.error),
                    const SizedBox(height: 12),
                    const Text('Data menu tidak ditemukan atau tidak tersedia.'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kembali ke Katalog'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  menu.nama,
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  menu.tersedia ? 'Tersedia' : 'Habis',
                                  style: textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: menu.tersedia
                                        ? colorScheme.onSecondaryContainer
                                        : colorScheme.onErrorContainer,
                                  ),
                                ),
                                backgroundColor: menu.tersedia
                                    ? colorScheme.secondaryContainer
                                    : colorScheme.errorContainer,
                                side: BorderSide.none,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Lokasi: ${menu.stan}',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Harga: ${menu.harga}',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Divider(height: 24),
                          Text(
                            'Deskripsi Menu:',
                            style: textTheme.labelLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            menu.deskripsi,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Jalan kembali eksplisit untuk layar dalam
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Kembali ke Daftar Menu'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// 3. LAYAR FORM PEMESANAN (Route: '/pesan' — StatefulWidget + Validasi + Dispose)
class HalamanFormPemesanan extends StatefulWidget {
  const HalamanFormPemesanan({super.key});

  @override
  State<HalamanFormPemesanan> createState() => _HalamanFormPemesananState();
}

class _HalamanFormPemesananState extends State<HalamanFormPemesanan> {
  final _formKey = GlobalKey<FormState>();
  final _namaPemesanController = TextEditingController();
  final _namaMenuController = TextEditingController();
  final _jumlahPorsiController = TextEditingController();
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan seluruh controller saat layar ditutup untuk mencegah kebocoran memori
    _namaPemesanController.dispose();
    _namaMenuController.dispose();
    _jumlahPorsiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _kirimPesanan(BuildContext context) {
    // 1. Validasi seluruh field terlebih dahulu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Baca nilai input yang sudah tervalidasi
    final pemesan = _namaPemesanController.text.trim();
    final menu = _namaMenuController.text.trim();
    final porsi = _jumlahPorsiController.text.trim();

    // 3. Tampilkan feedback SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pesanan "$menu" ($porsi porsi) atas nama $pemesan dikirim (simulasi).',
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    // 4. Kembali ke layar utama
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pemesanan Kantin'),
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
                hintText: 'Contoh: Reina (230660221103)',
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
                labelText: 'Nama Menu yang Dipesan',
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
              controller: _jumlahPorsiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Porsi',
                hintText: 'Contoh: 1',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Jumlah porsi wajib diisi.';
                }
                final angka = int.tryParse(value.trim());
                if (angka == null || angka <= 0) {
                  return 'Masukkan angka jumlah porsi yang valid (minimal 1).';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _catatanController,
              decoration: const InputDecoration(
                labelText: 'Catatan Tambahan (Opsional)',
                hintText: 'Contoh: Tidak pedas / bungkus',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _kirimPesanan(context),
              icon: const Icon(Icons.send),
              label: const Text('Kirim Pesanan'),
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
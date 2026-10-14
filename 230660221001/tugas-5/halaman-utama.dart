import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Penjualan Beras BSM',
      debugShowCheckedModeBanner: false,
      // Tema terpusat — warna benih hijau sesuai identitas produk pertanian
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HalamanKatalogBeras(),
    );
  }
}

class HalamanKatalogBeras extends StatelessWidget {
  const HalamanKatalogBeras({super.key});

  /// Ubah menjadi true untuk menguji keadaan kosong.
  static const bool katalogKosong = false;

  static const List<Map<String, String>> daftarBeras = [
    {
      'nama': 'Beras Pandan Wangi',
      'kualitas': 'Premium',
      'harga': '15000',
      'stok': '120',
      'status': 'tersedia',
    },
    {
      'nama': 'Beras Ramos Premium',
      'kualitas': 'Premium',
      'harga': '14000',
      'stok': '85',
      'status': 'tersedia',
    },
    {
      'nama': 'Beras Rojo Lele',
      'kualitas': 'Medium',
      'harga': '13000',
      'stok': '0',
      'status': 'habis',
    },
    {
      'nama': 'Beras IR64',
      'kualitas': 'Medium',
      'harga': '12000',
      'stok': '200',
      'status': 'tersedia',
    },
    {
      'nama': 'Beras Dedak Halus',
      'kualitas': 'Ekonomis',
      'harga': '8000',
      'stok': '50',
      'status': 'tersedia',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final tampilkanKeadaanKosong = daftarBeras.isEmpty || katalogKosong;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk Beras BSM'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const RingkasanKatalog(),
          const SizedBox(height: 8),
          Expanded(
            child: tampilkanKeadaanKosong
                ? const KeadaanKosong()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemCount: daftarBeras.length,
                    itemBuilder: (context, index) {
                      final beras = daftarBeras[index];
                      return KartuBeras(beras: beras);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasi ke keranjang — dibangun pada Pertemuan 6
        },
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text('Lihat Keranjang'),
      ),
    );
  }
}

/// Area ringkasan atas — hierarki visual: judul tebal, keterangan redup.
class RingkasanKatalog extends StatelessWidget {
  const RingkasanKatalog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat Datang di Pabrik BSM', style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Pilih beras berkualitas untuk kebutuhan keluarga Anda.',
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu item katalog: Card + ListTile + status berwarna.
class KartuBeras extends StatelessWidget {
  const KartuBeras({super.key, required this.beras});

  final Map<String, String> beras;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.rice_bowl_outlined),
        title: Text(
          beras['nama'] ?? '-',
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          '${beras['kualitas'] ?? '-'} • Rp ${beras['harga'] ?? '-'}/kg',
          style: textTheme.bodySmall,
        ),
        trailing: ChipStatus(
          status: beras['status'] ?? 'tersedia',
          stok: beras['stok'] ?? '0',
        ),
      ),
    );
  }
}

/// Status stok sebagai Chip berwarna — warna dari tema, bukan hardcoded.
class ChipStatus extends StatelessWidget {
  const ChipStatus({super.key, required this.status, required this.stok});

  final String status;
  final String stok;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (Color latar, Color teks) = status == 'tersedia'
        ? (colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer)
        : (colorScheme.errorContainer, colorScheme.onErrorContainer);
    return Chip(
      label: Text(status == 'tersedia' ? 'Stok: $stok' : 'Habis'),
      backgroundColor: latar,
      labelStyle: TextStyle(color: teks, fontWeight: FontWeight.w600),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Keadaan kosong — katalog tidak boleh tampil sebagai layar putih.
class KeadaanKosong extends StatelessWidget {
  const KeadaanKosong({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 56,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text('Belum ada produk beras', style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Katalog sedang kosong. Silakan coba lagi nanti.',
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
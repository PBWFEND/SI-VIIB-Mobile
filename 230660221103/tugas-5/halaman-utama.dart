```dart
// Tugas 5: Prototype UI/UX — Pemrograman Aplikasi Bergerak
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — implementasi tema terpusat ColorScheme.fromSeed dan status Chip berbasis tema

import 'package:flutter/material.dart';

void main() {
  runApp(const KantinDigitalApp());
}

class KantinDigitalApp extends StatelessWidget {
  const KantinDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital',
      debugShowCheckedModeBanner: false,
      // Tema terpusat menggunakan ColorScheme.fromSeed & Material 3
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: HalamanUtamaKatalog(),
    );
  }
}

class HalamanUtamaKatalog extends StatelessWidget {
  HalamanUtamaKatalog({super.key});

  // Data statis katalog menu (dikosongkan menjadi [] bila ingin menguji keadaan kosong)
  final daftarMenu = [
    {
      'nama': 'Nasi Goreng Spesial Kampus',
      'stan': 'Stan Bu Siti • Rp 15.000',
      'tersedia': true,
    },
    {
      'nama': 'Ayam Geprek Sambal Matah',
      'stan': 'Stan Pak Budi • Rp 14.000',
      'tersedia': true,
    },
    {
      'nama': 'Soto Ayam Lamongan',
      'stan': 'Stan Cak Har • Rp 13.000',
      'tersedia': false,
    },
    {
      'nama': 'Mie Ayam Bakso Urat',
      'stan': 'Stan Mas Joko • Rp 12.000',
      'tersedia': true,
    },
    {
      'nama': 'Es Teh Manis Jumbo',
      'stan': 'Stan Minuman Segar • Rp 4.000',
      'tersedia': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Mengambil skema warna & gaya teks dari Theme terpusat
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
            // Area Ringkasan / Sapaan Atas (Hierarki Visual Jelas)
            Text(
              'Katalog Menu Hari Ini',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pesan lebih awal di sela kuliah agar bebas antre.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Area Daftar Menu atau Keadaan Kosong (Empty State)
            Expanded(
              child: daftarMenu.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.no_meals_outlined,
                            size: 64,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada menu tersedia saat ini',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Silakan periksa kembali beberapa saat lagi.',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: daftarMenu.length,
                      itemBuilder: (context, index) {
                        final menu = daftarMenu[index];
                        final bool isTersedia = menu['tersedia'] as bool;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          elevation: 0.5,
                          color: colorScheme.surfaceContainerLow,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: isTersedia
                                  ? colorScheme.primaryContainer
                                  : colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.restaurant_menu,
                                color: isTersedia
                                    ? colorScheme.primary
                                    : colorScheme.outline,
                              ),
                            ),
                            title: Text(
                              menu['nama'] as String,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                menu['stan'] as String,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            // Status berwarna menggunakan ternary & palet warna tema
                            trailing: Chip(
                              label: Text(
                                isTersedia ? 'Tersedia' : 'Habis',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isTersedia
                                      ? colorScheme.onSecondaryContainer
                                      : colorScheme.onErrorContainer,
                                ),
                              ),
                              backgroundColor: isTersedia
                                  ? colorScheme.secondaryContainer
                                  : colorScheme.errorContainer,
                              side: BorderSide.none,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // Aksi Utama (Target sentuh besar & mudah dijangkau ibu jari)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Feedback visual sementara sebelum Navigator dipelajari di Pertemuan 6
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Membuka keranjang pesanan...'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(Icons.shopping_bag_outlined),
        label: const Text('Lihat Keranjang'),
      ),
    );
  }
}
// Tugas 3: Halaman Aplikasi Sederhana — Pemrograman Aplikasi Bergerak
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — penyederhanaan deklarasi list tanpa generic angle brackets

import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKantinApp());
}

class AplikasiKantinApp extends StatelessWidget {
  const AplikasiKantinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: HalamanKatalogMenu(),
    );
  }
}

class HalamanKatalogMenu extends StatelessWidget {
  HalamanKatalogMenu({super.key});

  // Data statis 5 entri menu kantin (menggunakan final tanpa kurung sudut)
  final daftarMenu = [
    {
      'nama': 'Nasi Goreng Spesial Kampus',
      'stan': 'Stan Bu Siti',
      'harga': 'Rp 15.000',
      'tersedia': true,
    },
    {
      'nama': 'Ayam Geprek Sambal Matah',
      'stan': 'Stan Pak Budi',
      'harga': 'Rp 14.000',
      'tersedia': true,
    },
    {
      'nama': 'Soto Ayam Lamongan',
      'stan': 'Stan Cak Har',
      'harga': 'Rp 13.000',
      'tersedia': false,
    },
    {
      'nama': 'Mie Ayam Bakso Urat',
      'stan': 'Stan Mas Joko',
      'harga': 'Rp 12.000',
      'tersedia': true,
    },
    {
      'nama': 'Es Teh Manis Jumbo',
      'stan': 'Stan Minuman Segar',
      'harga': 'Rp 4.000',
      'tersedia': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Menu Kantin'),
        backgroundColor: Colors.orange.shade100,
        centerTitle: false,
      ),
      // Layout 1: Padding sebagai pembungkus utama konten halaman
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Layout 2: Column untuk menyusun bagian header dan daftar menu secara vertikal
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo, Reina Anatasya!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih menu makan siangmu sebelum antrean penuh:',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            // Layout 3: Expanded + ListView.builder untuk menampilkan daftar data secara efisien
            Expanded(
              child: ListView.builder(
                itemCount: daftarMenu.length,
                itemBuilder: (context, index) {
                  final menu = daftarMenu[index];
                  final bool isTersedia = menu['tersedia'] as bool;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      // Layout 4: Row untuk menyusun ikon, informasi menu, dan badge status secara horizontal
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.orange,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu['nama'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${menu['stan']} • ${menu['harga']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isTersedia
                                  ? Colors.green.shade100
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isTersedia ? 'Tersedia' : 'Habis',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isTersedia
                                    ? Colors.green.shade800
                                    : Colors.grey.shade700,
                              ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Keranjang'),
      ),
    );
  }
}
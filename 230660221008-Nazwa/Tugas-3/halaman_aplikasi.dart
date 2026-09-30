import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiPengaduan());
}

class AplikasiPengaduan extends StatelessWidget {
  const AplikasiPengaduan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengaduan Fasilitas',
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    // Di sinilah 4 data keluhan statis tersebut kita letakkan
    final daftarKeluhan = [
      {'nama': 'AC Ruang Kelas', 'kategori': 'Elektronik', 'status': 'Rusak'},
      {'nama': 'Proyektor Lab', 'kategori': 'Elektronik', 'status': 'Mati Total'},
      {'nama': 'Wi-Fi Perpustakaan', 'kategori': 'Jaringan', 'status': 'Lemah'},
      {'nama': 'Kursi Taman', 'kategori': 'Mebel', 'status': 'Patah'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Keluhan Fasilitas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding( 
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Laporan Masuk:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder( 
              itemCount: daftarKeluhan.length,
              itemBuilder: (context, index) {
                final keluhan = daftarKeluhan[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row( 
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              keluhan['nama']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text('Kategori: ${keluhan['kategori']}'),
                          ],
                        ),
                        Text(
                          keluhan['status']!,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
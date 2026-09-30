import 'package:flutter/material.dart';

void main() {
  runApp(const PresentGoApp());
}

class PresentGoApp extends StatelessWidget {
  const PresentGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PresentGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HalamanRiwayatAbsensi(),
    );
  }
}

class HalamanRiwayatAbsensi extends StatelessWidget {
  const HalamanRiwayatAbsensi({super.key});

  // 1.3 Data statis — minimal 4 entri, kunci konsisten di setiap entri
  final List<Map<String, String>> daftarAbsensi = const [
    {
      'nama': 'Rian Rianto',
      'tanggal': '24 Sep 2026',
      'jam': '08.02',
      'status': 'Tepat Waktu',
    },
    {
      'nama': 'Siti Aisyah',
      'tanggal': '24 Sep 2026',
      'jam': '08.16',
      'status': 'Terlambat',
    },
    {
      'nama': 'Budi Santoso',
      'tanggal': '24 Sep 2026',
      'jam': '07.55',
      'status': 'Tepat Waktu',
    },
    {
      'nama': 'Dewi Lestari',
      'tanggal': '24 Sep 2026',
      'jam': '-',
      'status': 'Izin',
    },
    {
      'nama': 'Andi Firmansyah',
      'tanggal': '24 Sep 2026',
      'jam': '08.05',
      'status': 'Tepat Waktu',
    },
  ];

  Color _warnaStatus(String status) {
    switch (status) {
      case 'Tepat Waktu':
        return Colors.green;
      case 'Terlambat':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Absensi Hari Ini')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row: ringkasan singkat di bagian atas halaman
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _RingkasanKartu(
                  label: 'Hadir',
                  jumlah: '4',
                  warna: Colors.green,
                ),
                _RingkasanKartu(
                  label: 'Izin',
                  jumlah: '1',
                  warna: Colors.blueGrey,
                ),
                _RingkasanKartu(
                  label: 'Terlambat',
                  jumlah: '1',
                  warna: Colors.orange,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Karyawan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ListView.builder dibungkus Expanded supaya tidak overflow
          Expanded(
            child: ListView.builder(
              itemCount: daftarAbsensi.length,
              itemBuilder: (context, index) {
                final item = daftarAbsensi[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _warnaStatus(item['status']!),
                        child: Text(item['nama']!.substring(0, 1)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['nama']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text('${item['tanggal']} • ${item['jam']}'),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _warnaStatus(item['status']!).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item['status']!,
                          style: TextStyle(
                            color: _warnaStatus(item['status']!),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Absen Sekarang'),
      ),
    );
  }
}

// Kartu ringkasan kecil dipakai di dalam Row
class _RingkasanKartu extends StatelessWidget {
  final String label;
  final String jumlah;
  final Color warna;

  const _RingkasanKartu({
    required this.label,
    required this.jumlah,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            jumlah,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: warna,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

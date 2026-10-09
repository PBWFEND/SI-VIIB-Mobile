import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiTravel());
}

class AplikasiTravel extends StatelessWidget {
  const AplikasiTravel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Booking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  final List<Map<String, String>> daftarPaket = const [
    {
      'nama': 'Paket Wisata Bali 3D2N',
      'kategori': 'Domestik',
      'status': 'Tersedia',
      'harga': 'Rp 2.500.000'
    },
    {
      'nama': 'Paket Tour Jogja Hemat',
      'kategori': 'Domestik',
      'status': 'Tersedia',
      'harga': 'Rp 1.200.000'
    },
    {
      'nama': 'Eksplor Labuan Bajo 4D3N',
      'kategori': 'Premium',
      'status': 'Penuh',
      'harga': 'Rp 5.800.000'
    },
    {
      'nama': 'City Tour Bandung 1D',
      'kategori': 'Singkat',
      'status': 'Tersedia',
      'harga': 'Rp 450.000'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan Travel & Tour'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Daftar Paket Wisata Pilihan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: daftarPaket.length,
              itemBuilder: (context, index) {
                final item = daftarPaket[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['nama']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: item['status'] == 'Tersedia'
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['status']!,
                                style: TextStyle(
                                  color: item['status'] == 'Tersedia'
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Kategori: ${item['kategori']}'),
                        Text(
                          'Harga: ${item['harga']}',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
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

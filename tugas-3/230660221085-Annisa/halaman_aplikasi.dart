import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistem Informasi Armada Mobil',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  // Data statis minimal 4 entri
  final List<Map<String, String>> daftarMobil = const [
    {'nama': 'Toyota Avanza', 'kategori': 'MPV', 'status': 'Tersedia'},
    {'nama': 'Honda Civic', 'kategori': 'Sedan', 'status': 'Dipinjam'},
    {'nama': 'Mitsubishi Pajero', 'kategori': 'SUV', 'status': 'Tersedia'},
    {'nama': 'Toyota Innova Zenix', 'kategori': 'MPV', 'status': 'Servis'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Armada Mobil'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Sapaan menggunakan Row
            Row(
              children: const [
                Icon(Icons.directions_car, size: 30, color: Colors.indigo),
                SizedBox(width: 10),
                Text(
                  'Daftar Kendaraan SI',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ListView wrapped dengan Expanded untuk mencegah RenderFlex overflow
            Expanded(
              child: ListView.builder(
                itemCount: daftarMobil.length,
                itemBuilder: (context, index) {
                  final mobil = daftarMobil[index];
                  final isTersedia = mobil['status'] == 'Tersedia';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isTersedia ? Colors.green.shade100 : Colors.orange.shade100,
                        child: Icon(
                          Icons.time_to_leave,
                          color: isTersedia ? Colors.green : Colors.orange,
                        ),
                      ),
                      title: Text(
                        mobil['nama']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Kategori: ${mobil['kategori']}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isTersedia ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isTersedia ? Colors.green : Colors.red,
                          ),
                        ),
                        child: Text(
                          mobil['status']!,
                          style: TextStyle(
                            color: isTersedia ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Widget Utama / URL (MaterialApp)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadiAct - Radio Activity',
      debugShowCheckedModeBanner: false,
      home: const HalamanAplikasi(),
    );
  }
}

// Widget Halaman Utama Aplikasi dan Scaffold
class HalamanAplikasi extends StatelessWidget {
  const HalamanAplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    // entri dataa statis (data jadwal konten unsap radio)
    final daftarKonten = [
      {
        'nama': 'Ruang Suara Spotify',
        'divisi': 'Div. Entertain',
        'tanggal': '13 September 2026',
        'status': 'Sudah Tayang',
      },
      {
        'nama': 'Redaksi Insight',
        'divisi': 'Div. Redaksi',
        'tanggal': '14 September 2026',
        'status': 'Sudah Tayang',
      },
      {
        'nama': 'EduFun Radio',
        'divisi': 'Div. Edukasi',
        'tanggal': '19 September 2026',
        'status': 'Terlambat - Proses Edit',
      },
      {
        'nama': 'Unsap Trending',
        'divisi': 'Div. Entertain',
        'tanggal': '26 September 2026',
        'status': 'Sudah Tayang',
      },
      {
        'nama': 'Visual of the Week',
        'divisi': 'Div. Marcomm',
        'tanggal': '3 Oktober 2026',
        'status': 'Sudah Tayang',
      },
      {
        'nama': 'Kuis Kilat',
        'divisi': 'Div. Edukasi',
        'tanggal': '10 Oktober 2026',
        'status': 'Siap Tayang',
      },
      {
        'nama': 'Ruang Kata',
        'divisi': 'Div. Redaksi',
        'tanggal': '12 Oktober 2026',
        'status': 'Draft',
      },
      {
        'nama': 'Music on Unsap',
        'divisi': 'Div. Entertain',
        'tanggal': '24 Oktober 2026',
        'status': 'Brainstorming',
      },
      {
        'nama': 'Poster Hari Sumpah Pemuda',
        'divisi': 'Div. Marcomm',
        'tanggal': '28 Oktober 2026',
        'status': 'Draft',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 252, 60),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Row(
          children: const [
            Icon(Icons.radio, color: Colors.black, size: 20),
            SizedBox(width: 5),
            Text(
              'RadiAct - Radio Activity',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      // Layout 1: Column
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Layout 2: Padding
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Hallo Creative Crew, Berikut Jadwal Upload Konten UKM Unsap Radio!',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          // Layout 3: ListView.builder
          Expanded(
            child: ListView.builder(
              itemCount: daftarKonten.length,
              itemBuilder: (context, index) {
                final item = daftarKonten[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6.0,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 10,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    title: Text(
                      item['nama']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Layout 4: Row
                    subtitle: Row(
                      children: [
                        Text(
                          item['divisi']!,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '- ${item['tanggal']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Text(
                      item['status']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 245, 55, 8),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

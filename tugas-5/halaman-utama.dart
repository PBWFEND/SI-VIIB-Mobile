import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peminjaman Ruang Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema terpusat ColorScheme.fromSeed + Material 3
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  // Data pengajuan peminjaman ruang lab
  // (Ubah list ini jadi [] untuk menguji tampilan kondisi kosong / empty state)
  final List<Map<String, String>> daftarPengajuan = const [
    {
      'ruang': 'Lab Komputer 1',
      'tanggal': '18 Okt 2026',
      'jam': '09:00 - 11:00',
      'status': 'Menunggu',
    },
    {
      'ruang': 'Lab Jaringan',
      'tanggal': '20 Okt 2026',
      'jam': '13:00 - 15:00',
      'status': 'Disetujui',
    },
    {
      'ruang': 'Lab Multimedia',
      'tanggal': '12 Okt 2026',
      'jam': '10:00 - 12:00',
      'status': 'Ditolak',
    },
  ];

  // Helper warna label status dengan kondisi ternary
  Color _getStatusColor(BuildContext context, String status) {
    final theme = Theme.of(context).colorScheme;
    if (status == 'Disetujui') return Colors.green;
    if (status == 'Ditolak') return theme.error;
    return Colors.orange; // Default: Menunggu
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengajuan Saya'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      // Kondisi Ternary untuk Keadaan Kosong (Empty State)
      body: daftarPengajuan.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_late_outlined,
                    size: 80,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada pengajuan peminjaman',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: daftarPengajuan.length,
              itemBuilder: (context, index) {
                final item = daftarPengajuan[index];
                final statusColor = _getStatusColor(context, item['status']!);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.computer,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      item['ruang']!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${item['tanggal']} | ${item['jam']}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: Chip(
                      label: Text(
                        item['status']!,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: statusColor.withOpacity(0.1),
                      side: BorderSide(color: statusColor),
                    ),
                  ),
                );
              },
            ),
      // Aksi Utama: FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Tanpa Navigator (Materi Pertemuan 6)
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajukan Peminjaman'),
      ),
    );
  }
}
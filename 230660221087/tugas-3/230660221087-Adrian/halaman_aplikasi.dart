import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKepegawaian());
}

class AplikasiKepegawaian extends StatelessWidget {
  const AplikasiKepegawaian({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Informasi Kepegawaian Puskesmas',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HalamanDasbor(),
    );
  }
}

class HalamanDasbor extends StatelessWidget {
  const HalamanDasbor({super.key});

  @override
  Widget build(BuildContext context) {
    // Data statis minimal 4 entri sesuai panduan
    final List<Map<String, String>> daftarPegawai = [
      {'nama': 'Dr. Ratna', 'jabatan': 'Dokter Umum', 'status': 'Hadir'},
      {'nama': 'Bidan Sari', 'jabatan': 'Bidan Desa', 'status': 'Dinas Luar'},
      {'nama': 'Perawat Budi', 'jabatan': 'Perawat UGD', 'status': 'Hadir'},
      {'nama': 'Staf Jono', 'jabatan': 'Administrasi', 'status': 'Cuti'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasbor Kepegawaian'),
        centerTitle: true,
      ),
      body: Column( // Layout 1: Column
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding( // Layout 2: Padding
            padding: const EdgeInsets.all(16.0),
            child: Row( // Layout 3: Row
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Status Kehadiran Hari Ini',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.date_range, color: Colors.teal),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder( // Layout 4: ListView.builder (terbungkus Expanded menghindari overflow)
              itemCount: daftarPegawai.length,
              itemBuilder: (context, index) {
                final pegawai = daftarPegawai[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _warnaStatus(pegawai['status']!),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(pegawai['nama']!),
                    subtitle: Text(pegawai['jabatan']!),
                    trailing: Text(
                      pegawai['status']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _warnaStatus(pegawai['status']!),
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
        backgroundColor: Colors.teal,
        child: const Icon(Icons.how_to_reg),
      ),
    );
  }

  // Fungsi helper (ternary/percabangan) untuk warna status
  Color _warnaStatus(String status) {
    if (status == 'Hadir') return Colors.green;
    if (status == 'Dinas Luar') return Colors.orange;
    return Colors.grey;
  }
}

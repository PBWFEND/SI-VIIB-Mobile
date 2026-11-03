import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKepegawaian());
}

class AplikasiKepegawaian extends StatelessWidget {
  const AplikasiKepegawaian({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puskesmas Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Penggunaan tema terpusat (Prinsip UI Mobile PAB)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HalamanRiwayatPegawai(),
    );
  }
}

class HalamanRiwayatPegawai extends StatelessWidget {
  const HalamanRiwayatPegawai({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy absensi. Ubah menjadi list kosong [] untuk menguji keadaan kosong (empty state)
    final List<Map<String, String>> daftarAbsensi = [
      {'tanggal': '17 Okt 2026', 'jam': '07:30', 'status': 'Hadir', 'lokasi': 'Puskesmas Induk'},
      {'tanggal': '16 Okt 2026', 'jam': '08:00', 'status': 'Dinas Luar', 'lokasi': 'Desa Sukamaju'},
      {'tanggal': '15 Okt 2026', 'jam': '07:45', 'status': 'Hadir', 'lokasi': 'Puskesmas Induk'},
      {'tanggal': '14 Okt 2026', 'jam': '-', 'status': 'Izin', 'lokasi': '-'},
    ];

    // Mengambil tema dari context agar tidak menaruh warna statis secara hardcode
    final ThemeData tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kehadiran'),
        backgroundColor: tema.colorScheme.primaryContainer,
      ),
      body: daftarAbsensi.isEmpty
          ? _buildKeadaanKosong(tema) // Menampilkan empty state jika data kosong
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: daftarAbsensi.length,
              itemBuilder: (context, index) {
                final absensi = daftarAbsensi[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: tema.colorScheme.primary,
                    ),
                    title: Text(
                      absensi['tanggal']!,
                      style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Jam: ${absensi['jam']} \nLokasi: ${absensi['lokasi']}'),
                    trailing: _buildStatusChip(absensi['status']!, tema),
                  ),
                );
              },
            ),
      // Aksi Utama: Tombol FAB extended yang sangat jelas target sentuhnya
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasi belum diimplementasikan di Pertemuan 5
        },
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Absen Sekarang'),
      ),
    );
  }

  // Widget khusus untuk merender Chip Status berwarna menggunakan ternary
  Widget _buildStatusChip(String status, ThemeData tema) {
    final Color warnaBg = status == 'Hadir'
        ? Colors.green.shade100
        : status == 'Dinas Luar'
            ? Colors.orange.shade100
            : Colors.grey.shade300;
            
    final Color warnaTeks = status == 'Hadir'
        ? Colors.green.shade900
        : status == 'Dinas Luar'
            ? Colors.orange.shade900
            : Colors.grey.shade800;

    return Chip(
      label: Text(
        status,
        style: tema.textTheme.labelSmall?.copyWith(
          color: warnaTeks,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: warnaBg,
      side: BorderSide.none,
    );
  }

  // Widget untuk menampilkan kondisi data kosong (empty state)
  Widget _buildKeadaanKosong(ThemeData tema) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: tema.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada riwayat absensi.',
            style: tema.textTheme.titleMedium?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tekan tombol "Absen Sekarang" untuk memulai.',
            style: tema.textTheme.bodyMedium?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAB — Tugas 3: Halaman Aplikasi Sederhana
// Domain   : Aplikasi Absensi Organisasi Mahasiswa
// Halaman  : Daftar Kegiatan & Sesi Absensi
// ============================================================================
// Bantuan: AI coding assistant — membantu menyusun struktur widget tree
//          (MaterialApp → Scaffold → Column → ListView.builder) dan
//          merapikan layout Row pada KartuKegiatan.
// ============================================================================
//
// Cara menjalankan:
//   Jalur 1 — DartPad (tanpa instalasi):
//     Buka https://dartpad.dev/?template=app, salin seluruh file ini,
//     tekan Run.
//   Jalur 2 — Flutter SDK:
//     Salin ke lib/main.dart project Flutter, lalu:
//       flutter run -d chrome
// ============================================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const AbsensiApp());
}

/// Aplikasi utama — MaterialApp mengatur judul dan halaman awal.
class AbsensiApp extends StatelessWidget {
  const AbsensiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi Organisasi Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HalamanDaftarKegiatan(),
    );
  }
}

/// Halaman utama — menampilkan daftar kegiatan organisasi beserta
/// status sesi absensinya.
class HalamanDaftarKegiatan extends StatelessWidget {
  const HalamanDaftarKegiatan({super.key});

  @override
  Widget build(BuildContext context) {
    // Data statis (minimal 4 entri). Kunci konsisten di setiap entri.
    // Pada pertemuan berikutnya, data ini berasal dari backend SI.
    final List<Map<String, String>> daftarKegiatan = [
      {
        'nama': 'Rapat Rutin Bulanan',
        'tanggal': '12 Okt 2026',
        'lokasi': 'Aula F',
        'status': 'Dibuka',
      },
      {
        'nama': 'Pelatihan Kepemimpinan',
        'tanggal': '15 Okt 2026',
        'lokasi': 'Ruang B.201',
        'status': 'Dibuka',
      },
      {
        'nama': 'Bakti Sosial Desa',
        'tanggal': '20 Okt 2026',
        'lokasi': 'Desa Sukamaju',
        'status': 'Ditutup',
      },
      {
        'nama': 'Evaluasi Program Kerja',
        'tanggal': '25 Okt 2026',
        'lokasi': 'Sekretariat Organisasi',
        'status': 'Belum Dibuka',
      },
      {
        'nama': 'Rapat Koordinasi Divisi',
        'tanggal': '28 Okt 2026',
        'lokasi': 'Ruang Rapat Lt. 2',
        'status': 'Dibuka',
      },
    ];

    return Scaffold(
      // ----------------------------------------------------------------
      // AppBar — bilah judul halaman
      // ----------------------------------------------------------------
      appBar: AppBar(
        title: const Text('Absensi Organisasi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
            onPressed: () {},
          ),
        ],
      ),

      // ----------------------------------------------------------------
      // Body — Column (layout 1) berisi header + daftar
      // ----------------------------------------------------------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Padding (layout 2) — memberi jarak pada header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Halo, Anggota!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Pilih kegiatan untuk melakukan check-in kehadiran.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          // ListView.builder (layout 3) — daftar kegiatan
          // Dibungkus Expanded agar tidak RenderFlex overflow.
          Expanded(
            child: ListView.builder(
              itemCount: daftarKegiatan.length,
              itemBuilder: (context, index) {
                final kegiatan = daftarKegiatan[index];
                return KartuKegiatan(
                  nama: kegiatan['nama']!,
                  tanggal: kegiatan['tanggal']!,
                  lokasi: kegiatan['lokasi']!,
                  status: kegiatan['status']!,
                );
              },
            ),
          ),
        ],
      ),

      // Tombol aksi mengambang — pada aplikasi nyata membuka form
      // tambah kegiatan (hak akses panitia).
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Tambah kegiatan',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Satu kartu kegiatan. Layout Row (layout 4) di dalam Card.
class KartuKegiatan extends StatelessWidget {
  const KartuKegiatan({
    super.key,
    required this.nama,
    required this.tanggal,
    required this.lokasi,
    required this.status,
  });

  final String nama;
  final String tanggal;
  final String lokasi;
  final String status;

  Color _warnaBackgroundStatus() {
    switch (status) {
      case 'Dibuka':
        return Colors.green.shade100;
      case 'Ditutup':
        return Colors.grey.shade300;
      default:
        return Colors.orange.shade100;
    }
  }

  Color _warnaTeksStatus() {
    switch (status) {
      case 'Dibuka':
        return Colors.green.shade800;
      case 'Ditutup':
        return Colors.grey.shade700;
      default:
        return Colors.orange.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon kiri
            const CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.event, color: Colors.white),
            ),
            const SizedBox(width: 12),

            // Kolom info kegiatan — dibungkus Expanded agar teks panjang
            // tidak overflow keluar kartu.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$tanggal • $lokasi',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Badge status sesi absensi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _warnaBackgroundStatus(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: _warnaTeksStatus(),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

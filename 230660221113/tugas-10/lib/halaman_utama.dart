
import 'package:flutter/material.dart';

import 'form_interaksi.dart';
import 'halaman_api.dart';
import 'halaman_integrasi.dart';

// Warna aplikasi FasKampus.
const Color merahAkademik = Color(0xFFB21F32);
const Color merahGelap = Color(0xFF821526);
const Color latarFasKampus = Color(0xFFF7F7F9);

// Halaman utama aplikasi FasKampus.
class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  // Daftar fasilitas kampus.
  static const List<Map<String, String>> fasilitas = [
    {
      'nama': 'Aula Kampus',
      'lokasi': 'Gedung Utama',
      'kapasitas': '100 orang',
      'deskripsi':
          'Cocok untuk seminar, rapat, dan kegiatan mahasiswa.',
      'status': 'Tersedia',
    },
    {
      'nama': 'Ruang Kelas',
      'lokasi': 'Gedung Perkuliahan',
      'kapasitas': '40 orang',
      'deskripsi':
          'Dapat digunakan untuk diskusi dan kegiatan akademik.',
      'status': 'Tersedia',
    },
    {
      'nama': 'Laboratorium',
      'lokasi': 'Gedung Laboratorium',
      'kapasitas': '30 orang',
      'deskripsi':
          'Fasilitas untuk praktikum dan kegiatan pembelajaran.',
      'status': 'Perlu Konfirmasi',
    },
  ];

  // Daftar fasilitas untuk FormInteraksi.
  static final List<Map<String, String>> daftarFasilitasForm =
      fasilitas.map((item) {
    return {
      'nama': item['nama'] ?? 'Fasilitas',
    };
  }).toList();

  // Navigasi menuju form pengajuan.
  void _bukaFormPengajuan(
    BuildContext context, {
    Map<String, String>? fasilitasDipilih,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FormInteraksi(
            daftarFasilitas: daftarFasilitasForm,
            fasilitasAwal: fasilitasDipilih == null
                ? null
                : {
                    'nama': fasilitasDipilih['nama'] ?? '',
                  },
            onSimpan: (pengajuan) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pengajuan ${pengajuan.namaFasilitas} berhasil dibuat.',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
            },
          );
        },
      ),
    );
  }

  // Navigasi menuju halaman REST API Tugas 9.
  void _bukaHalamanApi(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HalamanApi(),
      ),
    );
  }

  // Navigasi menuju halaman integrasi data Tugas 10.
  void _bukaHalamanIntegrasi(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HalamanIntegrasi(),
      ),
    );
  }

  // Informasi aplikasi.
  void _tampilkanInformasi(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'FasKampus',
      applicationVersion: 'Prototype',
      children: const [
        Text(
          'Aplikasi informasi dan pengajuan peminjaman '
          'fasilitas kampus.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: latarFasKampus,

      // AppBar aplikasi.
      appBar: AppBar(
        title: const Text(
          'FasKampus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: merahAkademik,
        foregroundColor: Colors.white,
        actions: [
          // Tombol REST API Tugas 9.
          IconButton(
            tooltip: 'Integrasi REST API',
            icon: const Icon(Icons.cloud_sync),
            onPressed: () => _bukaHalamanApi(context),
          ),

          // Tombol integrasi data Tugas 10.
          IconButton(
            tooltip: 'Integrasi Data Tugas 10',
            icon: const Icon(Icons.integration_instructions),
            onPressed: () => _bukaHalamanIntegrasi(context),
          ),

          // Tombol informasi aplikasi.
          IconButton(
            tooltip: 'Informasi aplikasi',
            icon: const Icon(Icons.info_outline),
            onPressed: () => _tampilkanInformasi(context),
          ),
        ],
      ),

      // Konten halaman utama.
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Text(
            'Fasilitas Kampus',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF242936),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Temukan fasilitas yang sesuai dengan kebutuhan kegiatanmu.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF777D89),
            ),
          ),

          const SizedBox(height: 16),

          // Kolom pencarian.
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari fasilitas...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ),
            onChanged: (value) {
              // Fitur pencarian dapat dikembangkan berikutnya.
            },
          ),

          const SizedBox(height: 20),

          // Menampilkan seluruh kartu fasilitas.
          ...fasilitas.map(
            (item) => _KartuFasilitas(
              fasilitas: item,
              onTap: () {
                _bukaFormPengajuan(
                  context,
                  fasilitasDipilih: item,
                );
              },
            ),
          ),
        ],
      ),

      // Tombol pengajuan peminjaman.
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: merahAkademik,
        foregroundColor: Colors.white,
        onPressed: () => _bukaFormPengajuan(context),
        icon: const Icon(Icons.add),
        label: const Text('Ajukan Peminjaman'),
      ),
    );
  }
}

// Widget kartu fasilitas kampus.
class _KartuFasilitas extends StatelessWidget {
  const _KartuFasilitas({
    required this.fasilitas,
    required this.onTap,
  });

  final Map<String, String> fasilitas;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = fasilitas['status'] ?? 'Tersedia';

    final Color warnaStatus;

    if (status == 'Tersedia') {
      warnaStatus = Colors.green;
    } else if (status == 'Perlu Konfirmasi') {
      warnaStatus = Colors.orange;
    } else {
      warnaStatus = theme.colorScheme.error;
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: const CircleAvatar(
          backgroundColor: Color(0xFFFBE9EC),
          foregroundColor: merahAkademik,
          child: Icon(Icons.meeting_room_outlined),
        ),

        title: Text(
          fasilitas['nama'] ?? 'Fasilitas',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fasilitas['lokasi'] ?? ''),

              const SizedBox(height: 4),

              Text(
                'Kapasitas: ${fasilitas['kapasitas'] ?? '-'}',
              ),

              const SizedBox(height: 8),

              Text(fasilitas['deskripsi'] ?? ''),

              const SizedBox(height: 10),

              // Label status fasilitas.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: warnaStatus.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: warnaStatus,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        trailing: const Icon(Icons.chevron_right),

        onTap: onTap,
      ),
    );
  }
}
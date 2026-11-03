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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // 1. Peta Route Bernama Terpusat
      initialRoute: '/',
      routes: {
        '/': (context) => const HalamanRiwayatPegawai(),
        '/form': (context) => const HalamanFormAbsensi(),
        '/detail': (context) => const HalamanDetailAbsensi(),
      },
    );
  }
}

// ==========================================
// LAYAR 1: RIWAYAT PEGAWAI (initialRoute)
// ==========================================
class HalamanRiwayatPegawai extends StatelessWidget {
  const HalamanRiwayatPegawai({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> daftarAbsensi = [
      {'tanggal': '21 Okt 2026', 'jam': '07:30', 'status': 'Hadir', 'lokasi': 'Puskesmas Induk', 'catatan': 'Tepat waktu'},
      {'tanggal': '20 Okt 2026', 'jam': '08:00', 'status': 'Dinas Luar', 'lokasi': 'Desa Sukamaju', 'catatan': 'Kunjungan pasien lansia'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kehadiran'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: daftarAbsensi.length,
        itemBuilder: (context, index) {
          final absensi = daftarAbsensi[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
              title: Text(absensi['tanggal']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Jam: ${absensi['jam']} \nLokasi: ${absensi['lokasi']}'),
              // 2. Navigasi Maju & Pengiriman Data arguments (read-only)
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: absensi,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/form');
        },
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Absen Sekarang'),
      ),
    );
  }
}

// ==========================================
// LAYAR 2: FORM ABSENSI (StatefulWidget)
// ==========================================
class HalamanFormAbsensi extends StatefulWidget {
  const HalamanFormAbsensi({super.key});

  @override
  State<HalamanFormAbsensi> createState() => _HalamanFormAbsensiState();
}

class _HalamanFormAbsensiState extends State<HalamanFormAbsensi> {
  // 3. FormKey dan Controller
  final _formKey = GlobalKey<FormState>();
  final _lokasiController = TextEditingController();
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan memori controller saat route di-pop
    _lokasiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _kirimAbsen() {
    // 4. Validasi Form
    if (!_formKey.currentState!.validate()) {
      return; 
    }
    
    // 5. Feedback Interaksi (SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Absensi di "${_lokasiController.text}" berhasil dikirim (simulasi).'),
        backgroundColor: Colors.teal.shade700,
      ),
    );
    
    // 6. Kembali ke layar sebelumnya (pop)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Absensi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _lokasiController,
              decoration: const InputDecoration(
                labelText: 'Titik Lokasi GPS',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              // Validator untuk lokasi
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lokasi GPS tidak boleh kosong, periksa sinyal.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _catatanController,
              decoration: const InputDecoration(
                labelText: 'Catatan / Keterangan Dinas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Harap isi keterangan kegiatan absensi Anda.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _kirimAbsen,
              icon: const Icon(Icons.send),
              label: const Text('Kirim Data Absensi'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// LAYAR 3: DETAIL ABSENSI (StatelessWidget)
// ==========================================
class HalamanDetailAbsensi extends StatelessWidget {
  const HalamanDetailAbsensi({super.key});

  @override
  Widget build(BuildContext context) {
    // 7. Menerima Data dengan Pemeriksaan Tipe & Cabang null
    final args = ModalRoute.of(context)?.settings.arguments;
    final data = args is Map<String, String> ? args : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Rincian Absensi')),
      body: data == null
          ? const Center(child: Text('Data absensi tidak tersedia atau rusak.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tanggal: ${data['tanggal']}', style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Jam Masuk'),
                    subtitle: Text(data['jam'] ?? '-'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.map),
                    title: const Text('Lokasi Pelaporan'),
                    subtitle: Text(data['lokasi'] ?? '-'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Status / Catatan'),
                    subtitle: Text('${data['status']} - ${data['catatan']}'),
                  ),
                ],
              ),
            ),
    );
  }
}

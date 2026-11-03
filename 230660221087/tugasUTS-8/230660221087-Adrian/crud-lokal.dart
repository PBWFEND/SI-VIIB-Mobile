import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKepegawaian());
}

// ==========================================
// 1. MODEL DATA
// ==========================================
class DataAbsensi {
  const DataAbsensi({
    required this.id,
    required this.lokasi,
    required this.catatan,
    required this.tanggal,
    required this.jam,
    required this.status,
  });

  final String id;
  final String lokasi;
  final String catatan;
  final String tanggal;
  final String jam;
  final String status;

  @override
  String toString() => 'Absen $tanggal $jam - $lokasi ($status)';
}

// ==========================================
// ROOT APP
// ==========================================
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HalamanDaftarAbsensi(),
        '/form': (context) => const HalamanFormAbsensi(),
      },
    );
  }
}

// ==========================================
// 2. STATEFUL WIDGET UNTUK READ, UPDATE, DELETE
// ==========================================
class HalamanDaftarAbsensi extends StatefulWidget {
  const HalamanDaftarAbsensi({super.key});

  @override
  State<HalamanDaftarAbsensi> createState() => _HalamanDaftarAbsensiState();
}

class _HalamanDaftarAbsensiState extends State<HalamanDaftarAbsensi> {
  // STATE: In-memory List
  final List<DataAbsensi> _daftarAbsensi = [];

  // CREATE (Menerima data dari Navigator.pop form)
  Future<void> _tambahData() async {
    final hasil = await Navigator.pushNamed(context, '/form');
    if (hasil != null && hasil is DataAbsensi) {
      setState(() {
        _daftarAbsensi.add(hasil);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan.')),
      );
    }
  }

  // UPDATE (Mengganti objek lama dengan objek baru berdasarkan id)
  void _ubahStatus(String id) {
    setState(() {
      final index = _daftarAbsensi.indexWhere((p) => p.id == id);
      if (index != -1) {
        final lama = _daftarAbsensi[index];
        // Toggle status
        final statusBaru = lama.status == 'Menunggu' ? 'Divalidasi' : 'Menunggu';
        _daftarAbsensi[index] = DataAbsensi(
          id: lama.id,
          lokasi: lama.lokasi,
          catatan: lama.catatan,
          tanggal: lama.tanggal,
          jam: lama.jam,
          status: statusBaru,
        );
      }
    });
  }

  // DELETE (Konfirmasi lalu removeWhere berdasarkan id)
  Future<void> _konfirmasiHapus(DataAbsensi absensi) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Absensi?'),
        content: Text('Catatan absensi di ${absensi.lokasi} akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      setState(() {
        _daftarAbsensi.removeWhere((p) => p.id == absensi.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kehadiran (CRUD)'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      // READ (Menampilkan data)
      body: _daftarAbsensi.isEmpty
          ? const Center(child: Text('Belum ada data absensi.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _daftarAbsensi.length,
              itemBuilder: (context, index) {
                final absensi = _daftarAbsensi[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    title: Text('${absensi.tanggal} - ${absensi.jam}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Lokasi: ${absensi.lokasi}\nStatus: ${absensi.status}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                          tooltip: 'Ubah Status',
                          onPressed: () => _ubahStatus(absensi.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          tooltip: 'Hapus',
                          onPressed: () => _konfirmasiHapus(absensi),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahData,
        icon: const Icon(Icons.add),
        label: const Text('Absen'),
      ),
    );
  }
}

// ==========================================
// 3. FORM CREATE (StatefulWidget)
// ==========================================
class HalamanFormAbsensi extends StatefulWidget {
  const HalamanFormAbsensi({super.key});

  @override
  State<HalamanFormAbsensi> createState() => _HalamanFormAbsensiState();
}

class _HalamanFormAbsensiState extends State<HalamanFormAbsensi> {
  final _formKey = GlobalKey<FormState>();
  final _lokasiController = TextEditingController();
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    _lokasiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _kirim() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final sekarang = DateTime.now();
    
    // Pembuatan Objek Model Baru
    final dataBaru = DataAbsensi(
      id: sekarang.millisecondsSinceEpoch.toString(), // ID Unik
      lokasi: _lokasiController.text.trim(),
      catatan: _catatanController.text.trim(),
      tanggal: '${sekarang.day}/${sekarang.month}/${sekarang.year}', // Tgl Sistem
      jam: '${sekarang.hour}:${sekarang.minute.toString().padLeft(2, '0')}', // Jam Sistem
      status: 'Menunggu',
    );

    // Kirim data kembali ke layar sebelumnya melalui pop
    Navigator.pop(context, dataBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Absensi Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _lokasiController,
              decoration: const InputDecoration(labelText: 'Lokasi GPS (Simulasi)', border: OutlineInputBorder()),
              validator: (value) => value == null || value.trim().isEmpty ? 'Lokasi wajib diisi.' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _catatanController,
              decoration: const InputDecoration(labelText: 'Catatan', border: OutlineInputBorder()),
              validator: (value) => value == null || value.trim().isEmpty ? 'Catatan wajib diisi.' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _kirim,
              child: const Text('Simpan Data Absen'),
            )
          ],
        ),
      ),
    );
  }
}

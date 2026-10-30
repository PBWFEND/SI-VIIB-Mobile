import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengaduan Fasilitas Kampus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HalamanUtama(),
    );
  }
}

// 1. MODEL DATA ( immutable dengan id unik & toString )
class LaporanFasilitas {
  final String id;
  final String fasilitas;
  final String kategori;
  final String kendala;
  final String status;
  final String pelapor;

  const LaporanFasilitas({
    required this.id,
    required this.fasilitas,
    required this.kategori,
    required this.kendala,
    required this.status,
    required this.pelapor,
  });

  @override
  String toString() {
    return 'LaporanFasilitas(id: $id, fasilitas: $fasilitas, status: $status)';
  }
}

// 2. LAYAR UTAMA ( StatefulWidget Pengelola CRUD )
class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  // State data lokal in-memory
  final List<LaporanFasilitas> _daftarLaporan = [
    LaporanFasilitas(
      id: '101',
      fasilitas: 'Proyektor Ruang 301',
      kategori: 'Elektronik',
      kendala: 'Lampu proyektor redup dan bergaris merah',
      status: 'Diproses',
      pelapor: 'Felix',
    ),
    LaporanFasilitas(
      id: '102',
      fasilitas: 'AC Lab Komputer 2',
      kategori: 'Pendingin Ruangan',
      kendala: 'AC mengeluarkan suara bising dan tidak dingin',
      status: 'Menunggu',
      pelapor: 'Felix',
    ),
    LaporanFasilitas(
      id: '103',
      fasilitas: 'Kursi Kuliah R.204',
      kategori: 'Mebel',
      kendala: 'Papan alas tulis patah dan lepas',
      status: 'Selesai',
      pelapor: 'Felix',
    ),
  ];

  // CREATE: Tambah Laporan
  void _tambahLaporan(LaporanFasilitas laporanBaru) {
    setState(() {
      _daftarLaporan.add(laporanBaru);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Laporan "${laporanBaru.fasilitas}" berhasil ditambahkan.'),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  // UPDATE: Ubah Status Laporan
  void _ubahStatus(String id, String statusBaru) {
    setState(() {
      final index = _daftarLaporan.indexWhere((l) => l.id == id);
      if (index != -1) {
        final lama = _daftarLaporan[index];
        _daftarLaporan[index] = LaporanFasilitas(
          id: lama.id,
          fasilitas: lama.fasilitas,
          kategori: lama.kategori,
          kendala: lama.kendala,
          status: statusBaru,
          pelapor: lama.pelapor,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status laporan berhasil diperbarui menjadi $statusBaru.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // DELETE: Hapus Laporan dengan Konfirmasi AlertDialog
  void _hapusLaporan(String id) {
    setState(() {
      _daftarLaporan.removeWhere((l) => l.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan berhasil dihapus.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _konfirmasiHapus(LaporanFasilitas laporan) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus laporan "${laporan.fasilitas}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      _hapusLaporan(laporan.id);
    }
  }

  // Modal Dialog Ubah Status (Fitur Update)
  void _tampilkanDialogStatus(LaporanFasilitas laporan) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ubah Status: ${laporan.fasilitas}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Menunggu'),
                leading: const Icon(Icons.timer_outlined, color: Colors.red),
                onTap: () {
                  Navigator.pop(context);
                  _ubahStatus(laporan.id, 'Menunggu');
                },
              ),
              ListTile(
                title: const Text('Diproses'),
                leading: const Icon(Icons.build_outlined, color: Colors.orange),
                onTap: () {
                  Navigator.pop(context);
                  _ubahStatus(laporan.id, 'Diproses');
                },
              ),
              ListTile(
                title: const Text('Selesai'),
                leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                onTap: () {
                  Navigator.pop(context);
                  _ubahStatus(laporan.id, 'Selesai');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaduan Fasilitas Kampus'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: _daftarLaporan.isEmpty
          ? const Center(child: Text('Belum ada laporan kerusakan.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _daftarLaporan.length,
              itemBuilder: (context, index) {
                final laporan = _daftarLaporan[index];

                Color statusColor;
                if (laporan.status == 'Selesai') {
                  statusColor = Colors.green;
                } else if (laporan.status == 'Diproses') {
                  statusColor = Colors.orange;
                } else {
                  statusColor = Colors.red;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      laporan.fasilitas,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kategori: ${laporan.kategori} • Pelapor: ${laporan.pelapor}'),
                        Text('Kendala: ${laporan.kendala}',
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _tampilkanDialogStatus(laporan),
                          child: Chip(
                            label: Text(
                              laporan.status,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                            backgroundColor: statusColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _konfirmasiHapus(laporan),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final hasil = await Navigator.push<LaporanFasilitas>(
            context,
            MaterialPageRoute(builder: (context) => const FormPengaduanLokal()),
          );
          if (hasil != null) {
            _tambahLaporan(hasil);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Lapor Kerusakan'),
      ),
    );
  }
}

// 3. FORM TAMBAH DATA ( Form & Validation )
class FormPengaduanLokal extends StatefulWidget {
  const FormPengaduanLokal({super.key});

  @override
  State<FormPengaduanLokal> createState() => _FormPengaduanLokalState();
}

class _FormPengaduanLokalState extends State<FormPengaduanLokal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fasilitasController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _kendalaController = TextEditingController();

  @override
  void dispose() {
    _fasilitasController.dispose();
    _kategoriController.dispose();
    _kendalaController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final laporanBaru = LaporanFasilitas(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fasilitas: _fasilitasController.text.trim(),
        kategori: _kategoriController.text.trim(),
        kendala: _kendalaController.text.trim(),
        status: 'Menunggu',
        pelapor: 'Felix',
      );
      Navigator.pop(context, laporanBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Laporan Baru'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fasilitasController,
                decoration: const InputDecoration(
                  labelText: 'Nama Fasilitas',
                  hintText: 'Contoh: Proyektor R.301',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Nama fasilitas wajib diisi.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  hintText: 'Contoh: Elektronik / Mebel / Sanitasi',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Kategori wajib diisi.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kendalaController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Detail Kendala Kerusakan',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Detail kendala wajib diisi.' : null,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Laporan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
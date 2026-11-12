import 'package:flutter/material.dart';
import 'service-api.dart';

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
      home: const HalamanApiPengaduan(),
    );
  }
}

// ============================================================================
// HALAMAN UTAMA (Menangani 3 State: Loading, Sukses, Error + Retry)
// ============================================================================
class HalamanApiPengaduan extends StatefulWidget {
  const HalamanApiPengaduan({super.key});

  @override
  State<HalamanApiPengaduan> createState() => _HalamanApiPengaduanState();
}

class _HalamanApiPengaduanState extends State<HalamanApiPengaduan> {
  bool _sedangMemuat = true;
  String? _pesanError;
  List<LaporanFasilitas> _daftarLaporan = [];

  @override
  void initState() {
    super.initState();
    _muatDataDariApi();
  }

  Future<void> _muatDataDariApi() async {
    setState(() {
      _sedangMemuat = true;
      _pesanError = null;
    });

    try {
      final hasil = await PengaduanApiService.ambilDaftarLaporan();
      if (!mounted) return;
      setState(() {
        _daftarLaporan = hasil;
        _sedangMemuat = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _pesanError = e.toString().replaceFirst('Exception: ', '');
        _sedangMemuat = false;
      });
    }
  }

  Future<void> _bukaFormPengaduan() async {
    final laporanTerkirim = await showModalBottomSheet<LaporanFasilitas>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const FormPengaduanApiSheet(),
    );

    if (laporanTerkirim != null && mounted) {
      setState(() {
        _daftarLaporan.insert(0, laporanTerkirim);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Laporan "${laporanTerkirim.fasilitas}" berhasil dikirim ke server (ID: ${laporanTerkirim.id}).'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaduan Fasilitas Kampus'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            tooltip: 'Muat Ulang Data',
            icon: const Icon(Icons.refresh),
            onPressed: _sedangMemuat ? null : _muatDataDariApi,
          ),
        ],
      ),
      body: _bangunKontenUtama(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormPengaduan,
        icon: const Icon(Icons.add_comment),
        label: const Text('Lapor Kerusakan'),
      ),
    );
  }

  Widget _bangunKontenUtama() {
    // 1. STATE LOADING
    if (_sedangMemuat) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Memuat daftar laporan fasilitas dari server...',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    // 2. STATE ERROR + TOMBOL COBA LAGI (RETRY)
    if (_pesanError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Gagal Memuat Data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _pesanError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _muatDataDariApi,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. STATE SUKSES (ListView.builder)
    if (_daftarLaporan.isEmpty) {
      return const Center(child: Text('Belum ada laporan pengaduan masuk.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
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
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        laporan.fasilitas,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(
                        laporan.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: statusColor,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'ID #${laporan.id} • Kategori: ${laporan.kategori}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  laporan.kendala,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13.5),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 15, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Pelapor: ${laporan.pelapor}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// FORM INPUT PENGADUAN BARU (HTTP POST + TOMBOL DINONAKTIFKAN SAAT KIRIM)
// ============================================================================
class FormPengaduanApiSheet extends StatefulWidget {
  const FormPengaduanApiSheet({super.key});

  @override
  State<FormPengaduanApiSheet> createState() => _FormPengaduanApiSheetState();
}

class _FormPengaduanApiSheetState extends State<FormPengaduanApiSheet> {
  final _formKey = GlobalKey<FormState>();
  final _fasilitasController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _kendalaController = TextEditingController();

  bool _sedangMengirim = false;

  @override
  void dispose() {
    _fasilitasController.dispose();
    _kategoriController.dispose();
    _kendalaController.dispose();
    super.dispose();
  }

  Future<void> _submitLaporan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sedangMengirim = true;
    });

    final drafLaporan = LaporanFasilitas(
      id: '0',
      fasilitas: _fasilitasController.text.trim(),
      kategori: _kategoriController.text.trim(),
      kendala: _kendalaController.text.trim(),
      status: 'Menunggu',
      pelapor: 'Felix',
    );

    try {
      final hasilServer = await PengaduanApiService.kirimLaporan(drafLaporan);
      if (!mounted) return;
      Navigator.pop(context, hasilServer);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sedangMengirim = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Kirim Laporan Fasilitas Baru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fasilitasController,
                enabled: !_sedangMengirim,
                decoration: const InputDecoration(
                  labelText: 'Nama Fasilitas',
                  hintText: 'Contoh: Proyektor Ruang 301',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Nama fasilitas wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kategoriController,
                enabled: !_sedangMengirim,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  hintText: 'Contoh: Elektronik / Mebel / Sanitasi',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Kategori wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kendalaController,
                enabled: !_sedangMengirim,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Detail Kendala Kerusakan',
                  hintText: 'Jelaskan kondisi kerusakan fasilitas...',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Detail kendala wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _sedangMengirim ? null : _submitLaporan,
                icon: _sedangMengirim
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _sedangMengirim ? 'Mengirim ke Server...' : 'Kirim Laporan',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
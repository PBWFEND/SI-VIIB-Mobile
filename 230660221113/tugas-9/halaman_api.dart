
import 'package:flutter/material.dart';

import 'data_pengajuan.dart';
import 'service_api.dart';

class HalamanApi extends StatefulWidget {
  const HalamanApi({super.key});

  @override
  State<HalamanApi> createState() => _HalamanApiState();
}

class _HalamanApiState extends State<HalamanApi> {
  static const Color merah = Color(0xFFB21F32);

  final PengajuanService _service = PengajuanService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _tanggalController =
      TextEditingController(text: '2026-11-26');
  final TextEditingController _jamMulaiController =
      TextEditingController(text: '08:00');
  final TextEditingController _jamSelesaiController =
      TextEditingController(text: '10:00');
  final TextEditingController _tujuanController = TextEditingController();

  final List<String> _fasilitas = const [
    'Aula Kampus',
    'Ruang Kelas',
    'Laboratorium',
    'Proyektor',
    'Sound System',
    'Mikrofon',
    'Meja',
    'Kursi',
  ];

  String _fasilitasTerpilih = 'Aula Kampus';

  List<DataPengajuan> _daftar = [];

  bool _sedangMemuat = true;
  bool _sedangMengirim = false;
  String? _pesanError;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  @override
  void dispose() {
    _service.dispose();
    _tanggalController.dispose();
    _jamMulaiController.dispose();
    _jamSelesaiController.dispose();
    _tujuanController.dispose();
    super.dispose();
  }

  // GET: Mengambil daftar pengajuan dari server.
  Future<void> _muatData() async {
    if (!mounted) return;

    setState(() {
      _sedangMemuat = true;
      _pesanError = null;
    });

    try {
      final hasil = await _service.ambilDaftarPengajuan();

      // Jeda ini membantu indikator loading terlihat saat demonstrasi.
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _daftar = hasil;
        _sedangMemuat = false;
        _pesanError = null;
      });
    } catch (e) {
      // Jeda agar kondisi loading juga terlihat ketika pengujian error.
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _pesanError =
            e.toString().replaceFirst('Exception: ', '');
        _sedangMemuat = false;
      });
    }
  }

  // POST: Mengirim pengajuan baru ke server.
  Future<void> _kirimData() async {
    if (_sedangMengirim) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _sedangMengirim = true;
    });

    final data = DataPengajuan(
      id: '',
      namaFasilitas: _fasilitasTerpilih,
      tanggal: _tanggalController.text.trim(),
      jamMulai: _jamMulaiController.text.trim(),
      jamSelesai: _jamSelesaiController.text.trim(),
      tujuan: _tujuanController.text.trim(),
      status: 'Menunggu',
    );

    try {
      final hasil = await _service.kirimPengajuan(data);

      if (!mounted) return;

      setState(() {
        _daftar = [hasil, ..._daftar];
        _sedangMengirim = false;
        _tujuanController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pengajuan ${hasil.namaFasilitas} berhasil dikirim.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _sedangMengirim = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Tampilan utama halaman API.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrasi REST API'),
        backgroundColor: merah,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Muat ulang data',
            onPressed: _sedangMemuat ? null : _muatData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _bangunKartuDaftar(),
          const SizedBox(height: 16),
          _bangunKartuForm(),
          const SizedBox(height: 12),
          const Text(
            'Catatan: JSONPlaceholder merupakan API simulasi. '
            'Respons POST memberikan contoh data berhasil dibuat, '
            'tetapi data tidak disimpan permanen sebagai backend FasKampus.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  // Kartu daftar data dari GET.
  Widget _bangunKartuDaftar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Pengajuan dari API',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            const Text(
              'GET https://jsonplaceholder.typicode.com/posts',
              style: TextStyle(fontSize: 12),
            ),
            const Divider(height: 24),
            _bangunDaftar(),
          ],
        ),
      ),
    );
  }

  // Tiga kondisi: loading, error, dan sukses.
  Widget _bangunDaftar() {
    if (_sedangMemuat) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                color: merah,
              ),
              SizedBox(height: 16),
              Text(
                'Memuat data dari server...',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                'Mohon tunggu sebentar.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_pesanError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_off,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _pesanError!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _sedangMemuat ? null : _muatData,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_daftar.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text('Belum ada data dari server.'),
        ),
      );
    }

    return Column(
      children: _daftar.map((item) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(
            child: Icon(Icons.assignment_outlined),
          ),
          title: Text(
            item.namaFasilitas,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${item.tanggal} • ${item.tujuan}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            '#${item.id}',
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
    );
  }

  // Kartu form untuk mengirim data melalui POST.
  Widget _bangunKartuForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Form Pengajuan Baru',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              const Text('Data dikirim menggunakan HTTP POST.'),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _fasilitasTerpilih,
                decoration: const InputDecoration(
                  labelText: 'Fasilitas',
                  border: OutlineInputBorder(),
                ),
                items: _fasilitas.map((fasilitas) {
                  return DropdownMenuItem<String>(
                    value: fasilitas,
                    child: Text(fasilitas),
                  );
                }).toList(),
                onChanged: _sedangMengirim
                    ? null
                    : (value) {
                        if (value == null) return;
                        setState(() {
                          _fasilitasTerpilih = value;
                        });
                      },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _tanggalController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tanggal wajib diisi.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _jamMulaiController,
                      decoration: const InputDecoration(
                        labelText: 'Jam mulai',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Jam mulai wajib diisi.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _jamSelesaiController,
                      decoration: const InputDecoration(
                        labelText: 'Jam selesai',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Jam selesai wajib diisi.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _tujuanController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Tujuan kegiatan',
                  hintText: 'Contoh: Seminar organisasi mahasiswa',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Tujuan minimal 5 karakter.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _sedangMengirim ? null : _kirimData,
                  icon: _sedangMengirim
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    _sedangMengirim
                        ? 'Mengirim...'
                        : 'Kirim Pengajuan (POST)',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
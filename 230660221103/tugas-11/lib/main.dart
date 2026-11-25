// Tugas 11: Integrasi Fitur Perangkat — Halaman Utama & Form Lampiran
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — implementasi state loading, preview XFile, pembatalan, dan pesan permission

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/lampiran_foto_service.dart';

void main() {
  runApp(const KantinFiturPerangkatApp());
}

class PesananDenganBukti {
  const PesananDenganBukti({
    required this.id,
    required this.namaPemesan,
    required this.namaMenu,
    required this.buktiFoto,
  });

  final String id;
  final String namaPemesan;
  final String namaMenu;
  final HasilPilihFoto buktiFoto;
}

class KantinFiturPerangkatApp extends StatelessWidget {
  const KantinFiturPerangkatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital — Bukti Pembayaran',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HalamanKonfirmasiPembayaran(),
    );
  }
}

class HalamanKonfirmasiPembayaran extends StatefulWidget {
  const HalamanKonfirmasiPembayaran({super.key});

  @override
  State<HalamanKonfirmasiPembayaran> createState() =>
      _HalamanKonfirmasiPembayaranState();
}

class _HalamanKonfirmasiPembayaranState
    extends State<HalamanKonfirmasiPembayaran> {
  final _formKey = GlobalKey<FormState>();
  final _namaPemesanController = TextEditingController();
  final _namaMenuController = TextEditingController();
  final LampiranFotoService _fotoService = LampiranFotoService();

  // State lifecycle fitur perangkat
  bool _sedangMemprosesFoto = false;
  HasilPilihFoto? _fotoTerpilih;
  String? _pesanPermissionDitolak;
  String? _pesanErrorPerangkat;
  ImageSource _sumberTerakhir = ImageSource.gallery;

  // Daftar pesanan yang sudah terkonfirmasi dengan bukti foto
  final List<PesananDenganBukti> _riwayatTerkonfirmasi = [];

  @override
  void dispose() {
    _namaPemesanController.dispose();
    _namaMenuController.dispose();
    super.dispose();
  }

  Future<void> _ambilAtauPilihFoto(ImageSource sumber) async {
    setState(() {
      _sedangMemprosesFoto = true;
      _pesanPermissionDitolak = null;
      _pesanErrorPerangkat = null;
      _sumberTerakhir = sumber;
    });

    try {
      final hasil = await _fotoService.pilihBuktiFoto(sumber: sumber);
      if (!mounted) return;

      if (hasil == null) {
        // Pengguna membatalkan pemilihan: pertahankan _fotoTerpilih sebelumnya!
        setState(() {
          _sedangMemprosesFoto = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pemilihan gambar dibatalkan. Data sebelumnya dipertahankan.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Berhasil memperoleh gambar
      setState(() {
        _fotoTerpilih = hasil;
        _sedangMemprosesFoto = false;
      });
    } on IzinPerangkatDitolakException catch (e) {
      if (!mounted) return;
      setState(() {
        _pesanPermissionDitolak = e.pesan;
        _sedangMemprosesFoto = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _pesanErrorPerangkat = e.toString().replaceFirst('Exception: ', '');
        _sedangMemprosesFoto = false;
      });
    }
  }

  void _kirimKonfirmasiPesanan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_fotoTerpilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Harap lampirkan foto bukti pembayaran QRIS terlebih dahulu.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final pesananBaru = PesananDenganBukti(
      id: DateTime.now().millisecondsSinceEpoch.toString().substring(7),
      namaPemesan: _namaPemesanController.text.trim(),
      namaMenu: _namaMenuController.text.trim(),
      buktiFoto: _fotoTerpilih!,
    );

    setState(() {
      _riwayatTerkonfirmasi.insert(0, pesananBaru);
      _namaPemesanController.clear();
      _namaMenuController.clear();
      _fotoTerpilih = null;
      _pesanPermissionDitolak = null;
      _pesanErrorPerangkat = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pesanan "${pesananBaru.namaMenu}" beserta bukti foto berhasil dikirim.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan & Bukti Foto'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unggah Bukti Pembayaran QRIS',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lampirkan tangkapan layar atau foto struk QRIS untuk verifikasi cepat di stan kantin.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _namaPemesanController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Pemesan / NIM',
                        hintText: 'Contoh: Reina Anatasya (230660221103)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama pemesan wajib diisi.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _namaMenuController,
                      decoration: const InputDecoration(
                        labelText: 'Menu yang Dipesan',
                        hintText: 'Contoh: Nasi Goreng Spesial Kampus',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama menu wajib diisi.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Tombol aksi pemanggilan kamera & galeri
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _sedangMemprosesFoto
                                ? null
                                : () => _ambilAtauPilihFoto(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Ambil Kamera'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _sedangMemprosesFoto
                                ? null
                                : () => _ambilAtauPilihFoto(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Pilih Galeri'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Area tampilan state fitur perangkat
                    _bangunAreaStatusFoto(context),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _sedangMemprosesFoto
                            ? null
                            : _kirimKonfirmasiPesanan,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Kirim Pesanan & Bukti Foto'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Pesanan Terkonfirmasi (${_riwayatTerkonfirmasi.length})',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_riwayatTerkonfirmasi.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'Belum ada pesanan dengan lampiran foto.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            )
          else
            ..._riwayatTerkonfirmasi.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      item.buktiFoto.bytesGambar,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item.namaMenu,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${item.namaPemesan}\nLampiran: ${item.buktiFoto.namaFile}',
                  ),
                  isThreeLine: true,
                  trailing: Chip(
                    label: const Text('Terlampir'),
                    backgroundColor: colorScheme.secondaryContainer,
                    side: BorderSide.none,
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _bangunAreaStatusFoto(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 1. State Loading
    if (_sedangMemprosesFoto) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(width: 12),
            Text('Memproses gambar dari perangkat...'),
          ],
        ),
      );
    }

    // 2. State Permission Ditolak
    if (_pesanPermissionDitolak != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline, color: colorScheme.onErrorContainer),
                const SizedBox(width: 8),
                Text(
                  'Izin Akses Perangkat Ditolak',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _pesanPermissionDitolak!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () => _ambilAtauPilihFoto(_sumberTerakhir),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Coba Minta Izin Lagi'),
            ),
          ],
        ),
      );
    }

    // 3. State Error Perangkat / Validasi
    if (_pesanErrorPerangkat != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gagal Memuat Gambar',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _pesanErrorPerangkat!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _ambilAtauPilihFoto(_sumberTerakhir),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    // 4. State Berhasil (Preview Gambar Tersedia)
    if (_fotoTerpilih != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                _fotoTerpilih!.bytesGambar,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_fotoTerpilih!.namaFile} (${_fotoTerpilih!.ukuranKb.toStringAsFixed(1)} KB)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  tooltip: 'Hapus Lampiran',
                  onPressed: () => setState(() => _fotoTerpilih = null),
                  icon: Icon(Icons.close, color: colorScheme.error),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // 5. State Awal (Belum ada gambar dipilih)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.image_outlined, color: colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Belum ada bukti foto dipilih. Gunakan kamera atau galeri di atas.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
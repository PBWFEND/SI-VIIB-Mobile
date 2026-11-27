
import 'package:flutter/material.dart';
import 'data_pengajuan.dart';

/// Form pengajuan peminjaman fasilitas FasKampus.
/// Data diteruskan ke halaman pemanggil untuk disimpan secara lokal.
class FormInteraksi extends StatefulWidget {
  const FormInteraksi({
    super.key,
    required this.daftarFasilitas,
    required this.onSimpan,
    this.fasilitasAwal,
  });

  final List<Map<String, String>> daftarFasilitas;
  final Map<String, String>? fasilitasAwal;
  final ValueChanged<DataPengajuan> onSimpan;

  @override
  State<FormInteraksi> createState() => _FormInteraksiState();
}

class _FormInteraksiState extends State<FormInteraksi> {
  final _formKey = GlobalKey<FormState>();

  final _tanggalController = TextEditingController();
  final _jamMulaiController = TextEditingController();
  final _jamSelesaiController = TextEditingController();
  final _tujuanController = TextEditingController();

  String? _fasilitasTerpilih;
  DateTime? _tanggal;
  TimeOfDay? _jamMulai;
  TimeOfDay? _jamSelesai;

  @override
  void initState() {
    super.initState();

    final namaAwal = widget.fasilitasAwal?['nama'];
    final tersedia = widget.daftarFasilitas
        .map((fasilitas) => fasilitas['nama'])
        .whereType<String>()
        .toSet();

    _fasilitasTerpilih =
        namaAwal != null && tersedia.contains(namaAwal)
            ? namaAwal
            : null;
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _jamMulaiController.dispose();
    _jamSelesaiController.dispose();
    _tujuanController.dispose();
    super.dispose();
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<void> _pilihTanggal() async {
    final sekarang = DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);

    final tanggalDipilih = await showDatePicker(
      context: context,
      initialDate: _tanggal != null && !_tanggal!.isBefore(hariIni)
          ? _tanggal!
          : hariIni,
      firstDate: hariIni,
      lastDate: DateTime(sekarang.year + 1, 12, 31),
      helpText: 'Pilih tanggal peminjaman',
    );

    if (tanggalDipilih != null && mounted) {
      setState(() {
        _tanggal = tanggalDipilih;
        _tanggalController.text =
            '${tanggalDipilih.day.toString().padLeft(2, '0')}/'
            '${tanggalDipilih.month.toString().padLeft(2, '0')}/'
            '${tanggalDipilih.year}';
      });
    }
  }

  Future<void> _pilihJam({required bool jamMulai}) async {
    final jamDipilih = await showTimePicker(
      context: context,
      initialTime: jamMulai
          ? (_jamMulai ?? const TimeOfDay(hour: 8, minute: 0))
          : (_jamSelesai ?? const TimeOfDay(hour: 9, minute: 0)),
      helpText: jamMulai ? 'Pilih jam mulai' : 'Pilih jam selesai',
    );

    if (jamDipilih != null && mounted) {
      setState(() {
        if (jamMulai) {
          _jamMulai = jamDipilih;
          _jamMulaiController.text = jamDipilih.format(context);
        } else {
          _jamSelesai = jamDipilih;
          _jamSelesaiController.text = jamDipilih.format(context);
        }
      });
    }
  }

  int _menit(TimeOfDay waktu) {
    return waktu.hour * 60 + waktu.minute;
  }

  Future<void> _kirimPengajuan() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_tanggal == null ||
        _jamMulai == null ||
        _jamSelesai == null ||
        _fasilitasTerpilih == null) {
      _tampilkanPesan('Lengkapi fasilitas, tanggal, dan waktu peminjaman.');
      return;
    }

    if (_menit(_jamSelesai!) <= _menit(_jamMulai!)) {
      _tampilkanPesan(
        'Jam selesai harus lebih akhir daripada jam mulai.',
      );
      return;
    }

    final fasilitas = _fasilitasTerpilih!;
    final tanggal = _tanggalController.text;
    final jamMulai = _jamMulaiController.text;
    final jamSelesai = _jamSelesaiController.text;
    final tujuan = _tujuanController.text.trim();

    final dikonfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Peminjaman'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Periksa kembali data pengajuan kamu:'),
                const SizedBox(height: 16),
                Text('Fasilitas: $fasilitas'),
                Text('Tanggal: $tanggal'),
                Text('Waktu: $jamMulai - $jamSelesai'),
                const SizedBox(height: 8),
                const Text('Tujuan peminjaman:'),
                Text(tujuan),
                const SizedBox(height: 16),
                const Text(
                  'Pengajuan akan ditambahkan ke daftar lokal '
                  'FasKampus. Data belum dikirim ke server.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Periksa Lagi'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );

    if (dikonfirmasi != true || !mounted) return;

    // Membentuk objek dari hasil form.
    final pengajuan = DataPengajuan(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      namaFasilitas: fasilitas,
      tanggal: tanggal,
      jamMulai: jamMulai,
      jamSelesai: jamSelesai,
      tujuan: tujuan,
      status: 'Menunggu',
    );

    // Mengirim data ke halaman pemanggil untuk disimpan.
    widget.onSimpan(pengajuan);

    if (!mounted) return;

    // Kembali ke halaman sebelumnya setelah data dikirim.
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Peminjaman'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Ajukan Peminjaman Fasilitas',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Isi informasi berikut untuk mengajukan peminjaman '
              'fasilitas kampus.',
            ),
            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              initialValue: _fasilitasTerpilih,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Pilih Fasilitas',
                prefixIcon: Icon(Icons.meeting_room_outlined),
                border: OutlineInputBorder(),
              ),
              items: widget.daftarFasilitas.map((fasilitas) {
                final nama = fasilitas['nama'] ?? '';
                return DropdownMenuItem<String>(
                  value: nama,
                  child: Text(nama),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _fasilitasTerpilih = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pilih fasilitas yang akan dipinjam.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _tanggalController,
              readOnly: true,
              onTap: _pilihTanggal,
              decoration: const InputDecoration(
                labelText: 'Tanggal Peminjaman',
                hintText: 'Pilih tanggal',
                prefixIcon: Icon(Icons.calendar_today),
                suffixIcon: Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (_tanggal == null ||
                    value == null ||
                    value.isEmpty) {
                  return 'Tanggal peminjaman wajib dipilih.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _jamMulaiController,
              readOnly: true,
              onTap: () => _pilihJam(jamMulai: true),
              decoration: const InputDecoration(
                labelText: 'Jam Mulai',
                hintText: 'Pilih jam mulai',
                prefixIcon: Icon(Icons.access_time),
                suffixIcon: Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (_jamMulai == null ||
                    value == null ||
                    value.isEmpty) {
                  return 'Jam mulai wajib dipilih.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _jamSelesaiController,
              readOnly: true,
              onTap: () => _pilihJam(jamMulai: false),
              decoration: const InputDecoration(
                labelText: 'Jam Selesai',
                hintText: 'Pilih jam selesai',
                prefixIcon: Icon(Icons.access_time_filled),
                suffixIcon: Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (_jamSelesai == null ||
                    value == null ||
                    value.isEmpty) {
                  return 'Jam selesai wajib dipilih.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _tujuanController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Tujuan Peminjaman',
                hintText: 'Contoh: kegiatan diskusi mahasiswa',
                prefixIcon: Icon(Icons.description_outlined),
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tujuan peminjaman wajib diisi.';
                }

                if (value.trim().length < 5) {
                  return 'Jelaskan tujuan minimal 5 karakter.';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _kirimPengajuan,
                icon: const Icon(Icons.send),
                label: const Text('Lanjutkan Pengajuan'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Data akan disimpan di daftar lokal selama aplikasi '
              'berjalan. Pengajuan belum dikirim ke server.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

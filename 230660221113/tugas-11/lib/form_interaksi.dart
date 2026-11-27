
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'data_pengajuan.dart';

/// Form pengajuan peminjaman fasilitas FasKampus.
/// Pengguna dapat melampirkan surat izin atau proposal kegiatan.
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

  PlatformFile? _lampiran;
  String? _ukuranLampiran;
  bool _sedangMemilihLampiran = false;
  bool _sedangMenyimpan = false;

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
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(pesan)),
      );
  }

  Future<void> _pilihLampiran() async {
    if (_sedangMemilihLampiran) return;

    setState(() {
      _sedangMemilihLampiran = true;
    });

    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (!mounted) return;

      // Jika pengguna membatalkan picker, lampiran sebelumnya
      // tetap dipertahankan.
      if (file == null) {
        _tampilkanPesan('Pemilihan dokumen dibatalkan.');
        return;
      }

      final ukuran = file.lengthSync() ?? await file.length();

      if (!mounted) return;

      setState(() {
        _lampiran = file;
        _ukuranLampiran =
            ukuran == null ? 'Ukuran tidak diketahui' : _formatUkuran(ukuran);
      });

      _tampilkanPesan('Dokumen berhasil dipilih.');
    } catch (e) {
      _tampilkanPesan('Gagal memilih dokumen: $e');
    } finally {
      if (mounted) {
        setState(() {
          _sedangMemilihLampiran = false;
        });
      }
    }
  }

  void _hapusLampiran() {
    setState(() {
      _lampiran = null;
      _ukuranLampiran = null;
    });

    _tampilkanPesan('Lampiran dihapus dari form.');
  }

  String _formatUkuran(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  Future<void> _pilihTanggal() async {
    final sekarang = DateTime.now();
    final hariIni = DateTime(
      sekarang.year,
      sekarang.month,
      sekarang.day,
    );

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
    if (_sedangMenyimpan || _sedangMemilihLampiran) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_tanggal == null ||
        _jamMulai == null ||
        _jamSelesai == null ||
        _fasilitasTerpilih == null) {
      _tampilkanPesan(
        'Lengkapi fasilitas, tanggal, dan waktu peminjaman.',
      );
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

    final namaLampiran = _lampiran?.name ?? 'Tidak ada lampiran';

    setState(() {
      _sedangMenyimpan = true;
    });

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
                const Text(
                  'Periksa kembali data pengajuan kamu:',
                ),
                const SizedBox(height: 16),
                Text('Fasilitas: $fasilitas'),
                Text('Tanggal: $tanggal'),
                Text('Waktu: $jamMulai - $jamSelesai'),
                const SizedBox(height: 8),
                const Text('Tujuan peminjaman:'),
                Text(tujuan),
                const SizedBox(height: 12),
                const Text('Lampiran dokumen:'),
                Text(namaLampiran),
                const SizedBox(height: 16),
                const Text(
                  'Pengajuan akan diteruskan ke proses penyimpanan '
                  'lokal. Lampiran yang dipilih saat ini belum '
                  'disimpan ke dalam data CRUD.',
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

    if (!mounted) return;

    if (dikonfirmasi != true) {
      setState(() {
        _sedangMenyimpan = false;
      });
      return;
    }

    try {
      final pengajuan = DataPengajuan(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        namaFasilitas: fasilitas,
        tanggal: tanggal,
        jamMulai: jamMulai,
        jamSelesai: jamSelesai,
        tujuan: tujuan,
        status: 'Menunggu',
      );

      widget.onSimpan(pengajuan);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      _tampilkanPesan('Gagal mengirim pengajuan: $e');

      if (mounted) {
        setState(() {
          _sedangMenyimpan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Peminjaman'),
        backgroundColor: const Color(0xFFB21F32),
        foregroundColor: Colors.white,
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
                if (_tanggal == null || value == null || value.isEmpty) {
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
                if (_jamMulai == null || value == null || value.isEmpty) {
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
                if (_jamSelesai == null || value == null || value.isEmpty) {
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
            const SizedBox(height: 20),

            // Bagian pemilihan lampiran.
            const Text(
              'Lampiran Dokumen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Lampirkan surat izin atau proposal kegiatan '
              'dalam format PDF, DOC, atau DOCX.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _sedangMemilihLampiran
                  ? null
                  : _pilihLampiran,
              icon: _sedangMemilihLampiran
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.attach_file),
              label: Text(
                _sedangMemilihLampiran
                    ? 'Memilih dokumen...'
                    : _lampiran == null
                        ? 'Pilih Dokumen'
                        : 'Ganti Dokumen',
              ),
            ),

            if (_lampiran != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insert_drive_file,
                      color: Colors.green,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _lampiran!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _ukuranLampiran ?? 'Ukuran tidak diketahui',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Hapus lampiran',
                      onPressed: _hapusLampiran,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _sedangMenyimpan ||
                        _sedangMemilihLampiran
                    ? null
                    : _kirimPengajuan,
                icon: const Icon(Icons.send),
                label: Text(
                  _sedangMenyimpan
                      ? 'Memproses...'
                      : 'Lanjutkan Pengajuan',
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Data pengajuan diteruskan ke proses penyimpanan lokal. '
              'Penyimpanan file lampiran secara permanen belum diterapkan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
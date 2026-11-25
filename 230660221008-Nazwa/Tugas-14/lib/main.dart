import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'models/pengaduan_model.dart';
import 'services/pengaduan_repository.dart';
import 'services/token_storage_service.dart';
import 'validators/pengaduan_validator.dart';

void main() {
  runApp(const AplikasiPengaduanCandidateApp());
}

class AplikasiPengaduanCandidateApp extends StatelessWidget {
  const AplikasiPengaduanCandidateApp({
    super.key,
    this.repositoryKustom,
  });

  final PengaduanRepository? repositoryKustom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Pengaduan Fasilitas Kampus v1.0.0-rc.1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: HalamanUtamaTerintegrasi(repositoryKustom: repositoryKustom),
    );
  }
}

class HalamanUtamaTerintegrasi extends StatefulWidget {
  const HalamanUtamaTerintegrasi({
    super.key,
    this.repositoryKustom,
  });

  final PengaduanRepository? repositoryKustom;

  @override
  State<HalamanUtamaTerintegrasi> createState() =>
      _HalamanUtamaTerintegrasiState();
}

class _HalamanUtamaTerintegrasiState extends State<HalamanUtamaTerintegrasi> {
  late final SecureSessionTokenStorage _tokenStorage;
  late final PengaduanRepository _repository;

  bool _sesiAktif = false;
  bool _sedangMemuat = true;
  String? _pesanErrorMuat;
  StatusPengajuan? _filterStatus;
  List<Pengaduan> _semuaPengaduan = [];
  String? _idTerpilih;

  @override
  void initState() {
    super.initState();
    if (widget.repositoryKustom != null) {
      _repository = widget.repositoryKustom!;
      _tokenStorage = _repository.tokenStorage as SecureSessionTokenStorage;
    } else {
      _tokenStorage = SecureSessionTokenStorage();
      _repository = PengaduanRepository(tokenStorage: _tokenStorage);
    }
    _inisialisasiAplikasi();
  }

  Future<void> _inisialisasiAplikasi() async {
    await _repository.buatSesiLogin(nim: '230660221008');
    final bool aktif = await _tokenStorage.memilikiSesiAktif();
    if (!mounted) return;
    setState(() {
      _sesiAktif = aktif;
    });
    await _muatDaftarPengaduan();
  }

  Future<void> _muatDaftarPengaduan() async {
    setState(() {
      _sedangMemuat = true;
      _pesanErrorMuat = null;
    });

    try {
      final hasil = await _repository.ambilSemuaPengaduan();
      if (!mounted) return;
      final daftarBaru = List<Pengaduan>.from(hasil);
      setState(() {
        _semuaPengaduan = daftarBaru;
        _sedangMemuat = false;
        if (daftarBaru.isNotEmpty) {
          final masihAda = daftarBaru.any((item) => item.id == _idTerpilih);
          if (!masihAda) {
            _idTerpilih = daftarBaru.first.id;
          }
        } else {
          _idTerpilih = null;
        }
      });
    } on KoneksiLayananException catch (e) {
      if (!mounted) return;
      setState(() {
        _sedangMemuat = false;
        _pesanErrorMuat = e.pesan;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _sedangMemuat = false;
        _pesanErrorMuat = 'Terjadi kendala saat memuat data pengaduan.';
      });
    }
  }

  List<Pengaduan> get _pengaduanTersaring {
    if (_filterStatus == null) {
      return _semuaPengaduan;
    }
    return _semuaPengaduan
        .where((item) => item.status == _filterStatus)
        .toList();
  }

  int _hitungStatus(StatusPengajuan target) {
    return _semuaPengaduan.where((item) => item.status == target).length;
  }

  Future<void> _toggleSesiLogin() async {
    if (_sesiAktif) {
      await _repository.logout();
      if (!mounted) return;
      setState(() {
        _sesiAktif = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout berhasil: Token sesi dihapus.'),
        ),
      );
    } else {
      await _repository.buatSesiLogin(nim: '230660221008');
      if (!mounted) return;
      setState(() {
        _sesiAktif = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login sesi berhasil melalui HTTPS.'),
        ),
      );
    }
  }

  Future<void> _bukaFormPengaduan() async {
    final Pengaduan? hasil = await Navigator.of(context).push<Pengaduan>(
      MaterialPageRoute<Pengaduan>(
        builder: (_) => HalamanFormPengaduan(repository: _repository),
      ),
    );

    if (hasil != null && mounted) {
      await _muatDaftarPengaduan();
      if (!mounted) return;
      setState(() {
        _idTerpilih = hasil.id;
        _filterStatus = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tiket ${hasil.id} berhasil ditambahkan ke daftar.',
          ),
        ),
      );
    }
  }

  Future<void> _ubahStatusPengaduan(
    String id,
    StatusPengajuan statusBaru,
  ) async {
    await _repository.ubahStatus(id: id, statusBaru: statusBaru);
    await _muatDaftarPengaduan();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Status tiket $id diperbarui menjadi ${statusBaru.label}.'),
      ),
    );
  }

  Future<void> _hapusPengaduan(String id) async {
    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tiket Pengaduan?'),
        content: Text(
          'Tiket $id akan dihapus permanen dari daftar pengaduan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              minimumSize: const Size(88, 48),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && mounted) {
      await _repository.hapusPengaduan(id);
      await _muatDaftarPengaduan();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tiket $id telah dihapus.')),
      );
    }
  }

  Future<void> _bukaDetailLayarSempit(Pengaduan item) async {
    setState(() {
      _idTerpilih = item.id;
    });
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => HalamanDetailPengaduan(
          idPengaduan: item.id,
          repository: _repository,
          onUbahStatus: (statusBaru) =>
              _ubahStatusPengaduan(item.id, statusBaru),
          onHapus: () => _hapusPengaduan(item.id),
        ),
      ),
    );
    if (mounted) {
      await _muatDaftarPengaduan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaduan Fasilitas Kampus'),
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        actions: [
          IconButton(
            key: const Key('btn_muat_ulang'),
            tooltip: 'Muat ulang daftar pengaduan',
            onPressed: _muatDaftarPengaduan,
            icon: const Icon(Icons.refresh),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              key: const Key('btn_sesi_auth'),
              onPressed: _toggleSesiLogin,
              style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
              ),
              icon: Icon(_sesiAktif ? Icons.verified_user : Icons.login),
              label: Text(_sesiAktif ? 'Sesi Aktif' : 'Login'),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool modeDuaKolom = constraints.maxWidth >= 720;

          if (_sedangMemuat) {
            return _bangunKeadaanMemuat();
          }

          if (_pesanErrorMuat != null) {
            return _bangunKeadaanGagal();
          }

          if (!modeDuaKolom) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _bangunRingkasanStatus(scheme),
                const SizedBox(height: 12),
                _bangunTombolBuatLaporan(),
                const SizedBox(height: 14),
                _bangunBarFilter(),
                const SizedBox(height: 12),
                _bangunDaftarKartu(modeDuaKolom: false),
              ],
            );
          }

          final Pengaduan? terpilih = _idTerpilih == null
              ? null
              : _repository.cariBerdasarkanId(_idTerpilih!);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: ListView(
                    children: [
                      _bangunRingkasanStatus(scheme),
                      const SizedBox(height: 12),
                      _bangunTombolBuatLaporan(),
                      const SizedBox(height: 14),
                      _bangunBarFilter(),
                      const SizedBox(height: 12),
                      _bangunDaftarKartu(modeDuaKolom: true),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: PanelDetailPengaduan(
                      pengaduan: terpilih,
                      onUbahStatus: terpilih == null
                          ? null
                          : (statusBaru) =>
                              _ubahStatusPengaduan(terpilih.id, statusBaru),
                      onHapus: terpilih == null
                          ? null
                          : () => _hapusPengaduan(terpilih.id),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bangunKeadaanMemuat() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Memuat daftar pengaduan fasilitas kampus...'),
          ],
        ),
      ),
    );
  }

  Widget _bangunKeadaanGagal() {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          color: scheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off,
                  size: 40,
                  color: scheme.onErrorContainer,
                ),
                const SizedBox(height: 12),
                Text(
                  _pesanErrorMuat ?? 'Gagal memuat data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  key: const Key('btn_coba_lagi'),
                  onPressed: _muatDaftarPengaduan,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bangunRingkasanStatus(ColorScheme scheme) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: scheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _sesiAktif ? Icons.lock : Icons.lock_open,
                  size: 18,
                  color: _sesiAktif ? scheme.primary : scheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _sesiAktif
                        ? 'Koneksi HTTPS Aktif • Sesi Pelapor Terverifikasi'
                        : 'Sesi Nonaktif • Tekan Login untuk mengirim laporan baru',
                    style: textTheme.labelMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _chipStatistik(
                  'Total: ${_semuaPengaduan.length}',
                  scheme.secondaryContainer,
                  scheme.onSecondaryContainer,
                ),
                _chipStatistik(
                  'Menunggu: ${_hitungStatus(StatusPengajuan.menunggu)}',
                  StatusPengajuan.menunggu.warnaLatar(scheme),
                  StatusPengajuan.menunggu.warnaTeks(scheme),
                ),
                _chipStatistik(
                  'Diproses: ${_hitungStatus(StatusPengajuan.diproses)}',
                  StatusPengajuan.diproses.warnaLatar(scheme),
                  StatusPengajuan.diproses.warnaTeks(scheme),
                ),
                _chipStatistik(
                  'Selesai: ${_hitungStatus(StatusPengajuan.selesai)}',
                  StatusPengajuan.selesai.warnaLatar(scheme),
                  StatusPengajuan.selesai.warnaTeks(scheme),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipStatistik(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _bangunTombolBuatLaporan() {
    return FilledButton.icon(
      key: const Key('btn_buat_pengaduan'),
      onPressed: _bukaFormPengaduan,
      icon: const Icon(Icons.add_circle_outline),
      label: const Text('Buat Laporan Kerusakan Baru'),
    );
  }

  Widget _bangunBarFilter() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Semua'),
          selected: _filterStatus == null,
          onSelected: (_) {
            setState(() {
              _filterStatus = null;
            });
          },
        ),
        ...StatusPengajuan.values.map(
          (status) => ChoiceChip(
            label: Text(status.label),
            selected: _filterStatus == status,
            onSelected: (_) {
              setState(() {
                _filterStatus = status;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _bangunDaftarKartu({required bool modeDuaKolom}) {
    final daftar = _pengaduanTersaring;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (daftar.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 40, color: scheme.outline),
              const SizedBox(height: 10),
              Text(
                _filterStatus == null
                    ? 'Belum ada laporan kerusakan fasilitas yang tercatat.'
                    : 'Tidak ada laporan dengan status "${_filterStatus!.label}".',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: const Key('btn_aksi_kosong'),
                onPressed: _filterStatus == null
                    ? _bukaFormPengaduan
                    : () {
                        setState(() {
                          _filterStatus = null;
                        });
                      },
                icon: Icon(
                  _filterStatus == null ? Icons.add : Icons.filter_alt_off,
                ),
                label: Text(
                  _filterStatus == null
                      ? 'Buat Laporan Pertama'
                      : 'Tampilkan Semua Status',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: daftar.map((item) {
        final bool dipilih = modeDuaKolom && item.id == _idTerpilih;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            color: dipilih
                ? scheme.secondaryContainer.withValues(alpha: 0.45)
                : null,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (modeDuaKolom) {
                  setState(() {
                    _idTerpilih = item.id;
                  });
                } else {
                  _bukaDetailLayarSempit(item);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.id} • ${item.lokasi}',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _badgeStatus(item.status, scheme),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.deskripsi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.tanggalKejadian,
                          style: textTheme.labelSmall,
                        ),
                        const Spacer(),
                        Text(
                          modeDuaKolom
                              ? 'Lihat panel detail'
                              : 'Ketuk untuk detail',
                          style: textTheme.labelSmall?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _badgeStatus(StatusPengajuan status, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.warnaLatar(scheme),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.ikon, size: 14, color: status.warnaTeks(scheme)),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: status.warnaTeks(scheme),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class PanelDetailPengaduan extends StatelessWidget {
  const PanelDetailPengaduan({
    super.key,
    required this.pengaduan,
    this.onUbahStatus,
    this.onHapus,
  });

  final Pengaduan? pengaduan;
  final ValueChanged<StatusPengajuan>? onUbahStatus;
  final VoidCallback? onHapus;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (pengaduan == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.description_outlined, size: 42, color: scheme.outline),
              const SizedBox(height: 10),
              Text(
                'Pilih salah satu tiket pengaduan di sebelah kiri untuk melihat detail dan memperbarui status.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final item = pengaduan!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Detail Tiket ${item.id}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('btn_hapus_detail'),
                  tooltip: 'Hapus tiket pengaduan',
                  onPressed: onHapus,
                  icon: Icon(Icons.delete_outline, color: scheme.error),
                ),
              ],
            ),
            const Divider(height: 20),
            _barisInfo('Lokasi Fasilitas', item.lokasi, textTheme),
            _barisInfo('Tanggal Kejadian', item.tanggalKejadian, textTheme),
            _barisInfo('NIM Pelapor', item.nim, textTheme),
            _barisInfo('Email Notifikasi', item.email, textTheme),
            _barisInfo(
              'Lampiran Foto',
              item.namaLampiran ?? 'Tidak ada lampiran',
              textTheme,
            ),
            const SizedBox(height: 8),
            Text(
              'Deskripsi Kerusakan',
              style: textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(item.deskripsi, style: textTheme.bodyMedium),
            const SizedBox(height: 18),
            Text(
              'Perbarui Status Penanganan',
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: StatusPengajuan.values.map((status) {
                final bool aktif = item.status == status;
                return OutlinedButton.icon(
                  key: Key('btn_status_${status.name}'),
                  onPressed: aktif || onUbahStatus == null
                      ? null
                      : () => onUbahStatus!(status),
                  icon: Icon(status.ikon, size: 18),
                  label: Text(status.label),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barisInfo(String label, String nilai, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelSmall),
          const SizedBox(height: 2),
          Text(
            nilai,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class HalamanDetailPengaduan extends StatefulWidget {
  const HalamanDetailPengaduan({
    super.key,
    required this.idPengaduan,
    required this.repository,
    required this.onUbahStatus,
    required this.onHapus,
  });

  final String idPengaduan;
  final PengaduanRepository repository;
  final Future<void> Function(StatusPengajuan) onUbahStatus;
  final Future<void> Function() onHapus;

  @override
  State<HalamanDetailPengaduan> createState() => _HalamanDetailPengaduanState();
}

class _HalamanDetailPengaduanState extends State<HalamanDetailPengaduan> {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pengaduan = widget.repository.cariBerdasarkanId(widget.idPengaduan);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail ${widget.idPengaduan}'),
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: PanelDetailPengaduan(
          pengaduan: pengaduan,
          onUbahStatus: (statusBaru) async {
            await widget.onUbahStatus(statusBaru);
            if (mounted) {
              setState(() {});
            }
          },
          onHapus: () async {
            await widget.onHapus();
            if (mounted &&
                widget.repository.cariBerdasarkanId(widget.idPengaduan) ==
                    null) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}

class HalamanFormPengaduan extends StatefulWidget {
  const HalamanFormPengaduan({
    super.key,
    required this.repository,
  });

  final PengaduanRepository repository;

  @override
  State<HalamanFormPengaduan> createState() => _HalamanFormPengaduanState();
}

class _HalamanFormPengaduanState extends State<HalamanFormPengaduan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nimController =
      TextEditingController(text: '230660221008');
  final TextEditingController _emailController =
      TextEditingController(text: 'nazwa@kampus.ac.id');
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _sedangMengirim = false;
  String? _namaFotoTerpilih;
  Uint8List? _bytesFotoTerpilih;
  String? _pesanLampiran;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _tanggalController.text =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _nimController.dispose();
    _emailController.dispose();
    _lokasiController.dispose();
    _tanggalController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pilihFoto() async {
    setState(() {
      _pesanLampiran = null;
    });

    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      final errorValidasi = PengaduanValidator.validasiLampiranFoto(
        namaFile: file.name,
        ukuranByte: bytes.length,
      );
      if (errorValidasi != null) {
        if (!mounted) return;
        setState(() {
          _pesanLampiran = errorValidasi;
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _namaFotoTerpilih = file.name;
        _bytesFotoTerpilih = bytes;
      });
    } on PlatformException {
      if (!mounted) return;
      setState(() {
        _pesanLampiran =
            'Izin akses galeri ditolak. Aktifkan izin penyimpanan melalui pengaturan.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _pesanLampiran = 'Gagal memilih berkas foto.';
      });
    }
  }

  Future<void> _simpanPengaduan() async {
    if (_sedangMengirim) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _sedangMengirim = true;
    });

    try {
      final hasil = await widget.repository.tambahPengaduan(
        nim: _nimController.text.trim(),
        email: _emailController.text.trim(),
        lokasi: _lokasiController.text.trim(),
        tanggalKejadian: _tanggalController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        namaLampiran: _namaFotoTerpilih,
      );

      if (!mounted) return;
      Navigator.of(context).pop(hasil);
    } on OtorisasiSesiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.pesan)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim laporan. Silakan coba kembali.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sedangMengirim = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Pengaduan Baru'),
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        key: const Key('input_nim'),
                        controller: _nimController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'NIM Pelapor *',
                          border: OutlineInputBorder(),
                        ),
                        validator: PengaduanValidator.validasiNim,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('input_email'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Kampus *',
                          border: OutlineInputBorder(),
                        ),
                        validator: PengaduanValidator.validasiEmail,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('input_lokasi'),
                        controller: _lokasiController,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi Ruangan / Fasilitas *',
                          hintText: 'Contoh: Lab Jaringan Lantai 3',
                          border: OutlineInputBorder(),
                        ),
                        validator: PengaduanValidator.validasiLokasi,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('input_tanggal'),
                        controller: _tanggalController,
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Kejadian (YYYY-MM-DD) *',
                          border: OutlineInputBorder(),
                        ),
                        validator: PengaduanValidator.validasiTanggalKejadian,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('input_deskripsi'),
                        controller: _deskripsiController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Kerusakan *',
                          hintText:
                              'Jelaskan detail kerusakan minimal 10 karakter',
                          border: OutlineInputBorder(),
                        ),
                        validator: PengaduanValidator.validasiDeskripsi,
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: _pilihFoto,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(
                          _namaFotoTerpilih == null
                              ? 'Lampirkan Foto Bukti (Opsional, Maks 5 MB)'
                              : 'Foto: $_namaFotoTerpilih',
                        ),
                      ),
                      if (_bytesFotoTerpilih != null) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _bytesFotoTerpilih!,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      if (_pesanLampiran != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _pesanLampiran!,
                          style: TextStyle(color: scheme.error, fontSize: 12.5),
                        ),
                      ],
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        key: const Key('btn_simpan_laporan'),
                        onPressed: _sedangMengirim ? null : _simpanPengaduan,
                        icon: _sedangMengirim
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.send),
                        label: Text(
                          _sedangMengirim
                              ? 'Menyimpan Laporan...'
                              : 'Kirim Laporan Pengaduan',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Tugas 14: Integrasi Project & Candidate Release (v1.0.0-rc.1)
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — penyusunan LayoutBuilder responsif (breakpoint 720px) dan integrasi alur utama

import 'package:flutter/material.dart';
import 'models/pesanan_kantin.dart';

void main() {
  runApp(const KantinCandidateReleaseApp());
}

class KantinCandidateReleaseApp extends StatelessWidget {
  const KantinCandidateReleaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital (v1.0.0-rc.1)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HalamanUtamaTerintegrasi(),
    );
  }
}

class HalamanUtamaTerintegrasi extends StatefulWidget {
  const HalamanUtamaTerintegrasi({super.key});

  @override
  State<HalamanUtamaTerintegrasi> createState() =>
      _HalamanUtamaTerintegrasiState();
}

class _HalamanUtamaTerintegrasiState extends State<HalamanUtamaTerintegrasi> {
  // Satu sumber data terpusat untuk seluruh halaman (Daftar, Detail, Filter, Form)
  final List<PesananKantin> _semuaPesanan = [
    const PesananKantin(
      id: 'KTN-001',
      namaPemesan: 'Reina Anatasya',
      namaMenu: 'Nasi Goreng Spesial Kampus',
      jumlahPorsi: 2,
      nomorMeja: 12,
      catatan: 'Sambal dipisah, tanpa acar',
      status: StatusPesanan.diproses,
    ),
    const PesananKantin(
      id: 'KTN-002',
      namaPemesan: 'Dinda Maharani',
      namaMenu: 'Ayam Geprek Sambal Matah',
      jumlahPorsi: 1,
      nomorMeja: 5,
      catatan: 'Level pedas sedang',
      status: StatusPesanan.menunggu,
    ),
    const PesananKantin(
      id: 'KTN-003',
      namaPemesan: 'Rizky Pratama',
      namaMenu: 'Soto Ayam Lamongan + Es Teh',
      jumlahPorsi: 1,
      nomorMeja: 8,
      catatan: 'Tidak pakai seledri',
      status: StatusPesanan.siapDiambil,
    ),
  ];

  StatusPesanan? _filterStatus;
  String? _idTerpilih;
  bool _simulasiError = false;
  int _nomorUrut = 4;

  List<PesananKantin> get _daftarTersaring {
    if (_filterStatus == null) {
      return _semuaPesanan;
    }
    return _semuaPesanan
        .where((item) => item.status == _filterStatus)
        .toList();
  }

  PesananKantin? get _pesananTerpilih {
    if (_idTerpilih == null) return null;
    final idx = _semuaPesanan.indexWhere((item) => item.id == _idTerpilih);
    return idx == -1 ? null : _semuaPesanan[idx];
  }

  void _ubahStatusBerdasarkanId(String id, StatusPesanan statusBaru) {
    setState(() {
      final index = _semuaPesanan.indexWhere((item) => item.id == id);
      if (index != -1) {
        _semuaPesanan[index] = _semuaPesanan[index].salinDengan(
          status: statusBaru,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status pesanan $id diperbarui menjadi ${statusBaru.label}.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _bukaFormTambahPesanan() async {
    final pesananBaru = await Navigator.push<PesananKantin>(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanFormPesanan(
          idBerikutnya: 'KTN-${_nomorUrut.toString().padLeft(3, '0')}',
        ),
      ),
    );

    if (pesananBaru != null) {
      setState(() {
        _nomorUrut++;
        _semuaPesanan.insert(0, pesananBaru);
        _idTerpilih = pesananBaru.id;
        _filterStatus = null;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pesanan "${pesananBaru.namaMenu}" berhasil ditambahkan ke daftar.',
          ),
        ),
      );
    }
  }

  void _bukaDetailPadaLayarSempit(PesananKantin item) {
    setState(() {
      _idTerpilih = item.id;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Detail Pesanan ${item.id}'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          body: StatefulBuilder(
            builder: (context, setStateModal) {
              final dataTerkini = _semuaPesanan.firstWhere(
                (p) => p.id == item.id,
                orElse: () => item,
              );
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _bangunPanelDetail(
                  context,
                  dataTerkini,
                  onUbahStatus: (statusBaru) {
                    _ubahStatusBerdasarkanId(dataTerkini.id, statusBaru);
                    setStateModal(() {});
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _warnaStatus(ColorScheme scheme, StatusPesanan status) {
    switch (status) {
      case StatusPesanan.menunggu:
        return scheme.tertiaryContainer;
      case StatusPesanan.diproses:
        return scheme.primaryContainer;
      case StatusPesanan.siapDiambil:
        return scheme.secondaryContainer;
    }
  }

  Color _warnaTeksStatus(ColorScheme scheme, StatusPesanan status) {
    switch (status) {
      case StatusPesanan.menunggu:
        return scheme.onTertiaryContainer;
      case StatusPesanan.diproses:
        return scheme.onPrimaryContainer;
      case StatusPesanan.siapDiambil:
        return scheme.onSecondaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Kampus Digital'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            tooltip: _simulasiError
                ? 'Pulihkan Koneksi Normal'
                : 'Simulasi Keadaan Gagal',
            onPressed: () {
              setState(() {
                _simulasiError = !_simulasiError;
              });
            },
            icon: Icon(
              _simulasiError ? Icons.wifi_off : Icons.cloud_done_outlined,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormTambahPesanan,
        icon: const Icon(Icons.add),
        label: const Text('Buat Pesanan'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Titik henti responsif disepakati pada lebar 720 piksel
          final bool layarLebar = constraints.maxWidth >= 720;

          if (_simulasiError) {
            return _bangunKeadaanGagal(context);
          }

          if (!layarLebar) {
            // Susunan 1 kolom untuk layar sempit (< 720px)
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bangunBarisFilter(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _bangunDaftarPesanan(
                      context,
                      layarLebar: false,
                    ),
                  ),
                ],
              ),
            );
          }

          // Susunan 2 kolom berdampingan untuk layar lebar (>= 720px)
          final terpilih = _pesananTerpilih ??
              (_daftarTersaring.isNotEmpty ? _daftarTersaring.first : null);

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bangunBarisFilter(),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _bangunDaftarPesanan(
                          context,
                          layarLebar: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 4,
                  child: terpilih == null
                      ? const Card(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text('Pilih pesanan di sebelah kiri untuk melihat detail.'),
                          ),
                        )
                      : SingleChildScrollView(
                          child: _bangunPanelDetail(
                            context,
                            terpilih,
                            onUbahStatus: (statusBaru) =>
                                _ubahStatusBerdasarkanId(terpilih.id, statusBaru),
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

  Widget _bangunBarisFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: Text('Semua (${_semuaPesanan.length})'),
            selected: _filterStatus == null,
            onSelected: (_) => setState(() => _filterStatus = null),
          ),
          const SizedBox(width: 8),
          ...StatusPesanan.values.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(status.label),
                selected: _filterStatus == status,
                onSelected: (_) => setState(() => _filterStatus = status),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _bangunDaftarPesanan(
    BuildContext context, {
    required bool layarLebar,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final daftar = _daftarTersaring;

    // Keadaan Kosong (dibedakan jelas dari Keadaan Gagal)
    if (daftar.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 56,
                color: colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                'Belum ada pesanan pada kategori ini.',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(160, 48),
                ),
                onPressed: () => setState(() => _filterStatus = null),
                icon: const Icon(Icons.filter_alt_off),
                label: const Text('Tampilkan Semua'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: daftar.length,
      itemBuilder: (context, index) {
        final item = daftar[index];
        final dipilih = layarLebar && _idTerpilih == item.id;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: dipilih
                ? BorderSide(color: colorScheme.primary, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (layarLebar) {
                setState(() => _idTerpilih = item.id);
              } else {
                _bukaDetailPadaLayarSempit(item);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      '#${item.nomorMeja}',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.namaMenu} (${item.jumlahPorsi}x)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.namaPemesan} • ID ${item.id}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      item.status.label,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _warnaTeksStatus(colorScheme, item.status),
                      ),
                    ),
                    backgroundColor: _warnaStatus(colorScheme, item.status),
                    side: BorderSide.none,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bangunPanelDetail(
    BuildContext context,
    PesananKantin item, {
    required ValueChanged<StatusPesanan> onUbahStatus,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detail Pesanan ${item.id}',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    item.status.label,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _warnaTeksStatus(colorScheme, item.status),
                    ),
                  ),
                  backgroundColor: _warnaStatus(colorScheme, item.status),
                  side: BorderSide.none,
                ),
              ],
            ),
            const Divider(height: 24),
            Text('Menu Pesanan', style: textTheme.labelMedium),
            Text(
              '${item.namaMenu} (${item.jumlahPorsi} porsi)',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text('Pemesan & Nomor Meja', style: textTheme.labelMedium),
            Text(
              '${item.namaPemesan} — Meja #${item.nomorMeja}',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Text('Catatan Khusus', style: textTheme.labelMedium),
            Text(
              item.catatan.isEmpty ? 'Tidak ada catatan' : item.catatan,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Perbarui Status Proses:',
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: StatusPesanan.values.map((status) {
                final aktif = item.status == status;
                return ChoiceChip(
                  label: Text(status.label),
                  selected: aktif,
                  onSelected: (_) => onUbahStatus(status),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunKeadaanGagal(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Koneksi ke Server Terputus',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Periksa koneksi internet Anda lalu tekan tombol Coba Lagi.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size(160, 48),
              ),
              onPressed: () => setState(() => _simulasiError = false),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class HalamanFormPesanan extends StatefulWidget {
  const HalamanFormPesanan({super.key, required this.idBerikutnya});

  final String idBerikutnya;

  @override
  State<HalamanFormPesanan> createState() => _HalamanFormPesananState();
}

class _HalamanFormPesananState extends State<HalamanFormPesanan> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _menuController = TextEditingController();
  final _porsiController = TextEditingController(text: '1');
  final _mejaController = TextEditingController();
  final _catatanController = TextEditingController();
  bool _sedangMenyimpan = false;

  @override
  void dispose() {
    _namaController.dispose();
    _menuController.dispose();
    _porsiController.dispose();
    _mejaController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _simpanForm() {
    if (_sedangMenyimpan) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _sedangMenyimpan = true);

    final hasil = PesananKantin(
      id: widget.idBerikutnya,
      namaPemesan: _namaController.text.trim(),
      namaMenu: _menuController.text.trim(),
      jumlahPorsi: int.parse(_porsiController.text.trim()),
      nomorMeja: int.parse(_mejaController.text.trim()),
      catatan: _catatanController.text.trim(),
      status: StatusPesanan.menunggu,
    );

    Navigator.pop(context, hasil);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Pesanan (${widget.idBerikutnya})'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pemesan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nama pemesan wajib diisi.'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _menuController,
                  decoration: const InputDecoration(
                    labelText: 'Menu Makanan / Minuman',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nama menu wajib diisi.'
                      : null,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _porsiController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Porsi (1-50)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          final n = int.tryParse(v?.trim() ?? '');
                          if (n == null || n < 1 || n > 50) {
                            return 'Porsi harus 1 - 50.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _mejaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Meja (1-99)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          final n = int.tryParse(v?.trim() ?? '');
                          if (n == null || n < 1 || n > 99) {
                            return 'Meja harus 1 - 99.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _catatanController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan Pesanan (Opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: _sedangMenyimpan ? null : _simpanForm,
                  icon: const Icon(Icons.send),
                  label: const Text('Simpan & Kirim ke Antrean'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
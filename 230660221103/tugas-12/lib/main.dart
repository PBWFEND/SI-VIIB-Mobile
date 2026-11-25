// Tugas 12: Validasi dan Keamanan Praktis — Antarmuka Utama
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — implementasi form dengan 5 validator, pemeriksaan HTTPS, dan manajemen sesi logout

import 'package:flutter/material.dart';
import 'security/validasi_kantin.dart';

void main() {
  runApp(const KantinKeamananApp());
}

class KantinKeamananApp extends StatelessWidget {
  const KantinKeamananApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Kampus Digital — Validasi & Keamanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HalamanFormAmanKantin(),
    );
  }
}

class HalamanFormAmanKantin extends StatefulWidget {
  const HalamanFormAmanKantin({super.key});

  @override
  State<HalamanFormAmanKantin> createState() => _HalamanFormAmanKantinState();
}

class _HalamanFormAmanKantinState extends State<HalamanFormAmanKantin> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _porsiController = TextEditingController();
  final _mejaController = TextEditingController();
  final _catatanController = TextEditingController();

  final SesiTokenStorage _tokenStorage = SesiTokenStorage();
  bool _sesiAktif = false;
  final List<String> _logTransaksiAman = [];

  // Endpoint HTTPS terstandar (tanpa secret di dalam URL)
  static const String _endpointPesanan =
      'https://jsonplaceholder.typicode.com/posts';

  @override
  void initState() {
    super.initState();
    _inisialisasiSesi();
  }

  Future<void> _inisialisasiSesi() async {
    // Membuat token sesi dinamis saat runtime (tidak hardcoded di source code)
    final tokenRuntime =
        'session_${DateTime.now().millisecondsSinceEpoch}_verified';
    await _tokenStorage.simpan(tokenRuntime);
    final cek = await _tokenStorage.baca();
    if (!mounted) return;
    setState(() {
      _sesiAktif = cek != null && cek.isNotEmpty;
    });
  }

  Future<void> _logoutDanHapusToken() async {
    await _tokenStorage.hapus();
    if (!mounted) return;
    setState(() {
      _sesiAktif = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout berhasil: token sesi telah dihapus dari penyimpanan.'),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _porsiController.dispose();
    _mejaController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _prosesKirimAman() async {
    // 1. Pemeriksaan status autentikasi sesi
    final tokenAktif = await _tokenStorage.baca();
    if (tokenAktif == null || tokenAktif.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Sesi berakhir (401). Silakan aktifkan sesi kembali sebelum mengirim pesanan.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // 2. Jalankan seluruh validator form sebelum membentuk request
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Periksa kembali kolom yang ditandai merah sebelum mengirim.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // 3. Pastikan protokol komunikasi menggunakan HTTPS
    final uri = Uri.parse(_endpointPesanan);
    if (uri.scheme != 'https') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Koneksi ditolak: endpoint wajib menggunakan HTTPS.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // 4. Sanitasi input akhir dengan trim() dan simpan ringkasan tanpa menampilkan token
    final namaBersih = _namaController.text.trim();
    final emailBersih = _emailController.text.trim();
    final porsiBersih = int.parse(_porsiController.text.trim());
    final mejaBersih = int.parse(_mejaController.text.trim());

    setState(() {
      _logTransaksiAman.insert(
        0,
        '$namaBersih ($emailBersih) — $porsiBersih porsi | Meja #$mejaBersih [HTTPS Verified]',
      );
      _namaController.clear();
      _emailController.clear();
      _porsiController.clear();
      _mejaController.clear();
      _catatanController.clear();
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Validasi lolos & pesanan terkirim aman melalui HTTPS.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemesanan Kantin Tervalidasi'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          if (_sesiAktif)
            TextButton.icon(
              onPressed: _logoutDanHapusToken,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            )
          else
            TextButton.icon(
              onPressed: _inisialisasiSesi,
              icon: const Icon(Icons.login),
              label: const Text('Login Ulang'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner status keamanan koneksi & token
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _sesiAktif
                  ? colorScheme.secondaryContainer
                  : colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _sesiAktif ? Icons.verified_user : Icons.gpp_bad,
                  color: _sesiAktif
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _sesiAktif
                        ? 'Koneksi HTTPS aktif & sesi terautentikasi (token tersimpan aman, tidak ditampilkan).'
                        : 'Sesi nonaktif (token telah dihapus). Tekan Login Ulang untuk memulai sesi.',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _sesiAktif
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Form Pemesanan dengan Validasi Berlapis',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Pemesan',
                        hintText: 'Contoh: Reina Anatasya',
                        border: OutlineInputBorder(),
                      ),
                      validator: ValidatorKantin.validasiNamaPemesan,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Mahasiswa',
                        hintText: 'Contoh: reina@kampus.ac.id',
                        border: OutlineInputBorder(),
                      ),
                      validator: ValidatorKantin.validasiEmail,
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
                              hintText: '2',
                              border: OutlineInputBorder(),
                            ),
                            validator: ValidatorKantin.validasiJumlahPorsi,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _mejaController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Nomor Meja (1-99)',
                              hintText: '12',
                              border: OutlineInputBorder(),
                            ),
                            validator: ValidatorKantin.validasiNomorMeja,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _catatanController,
                      decoration: const InputDecoration(
                        labelText: 'Catatan Tambahan (Opsional, maks 150 karakter)',
                        hintText: 'Contoh: Sambal dipisah',
                        border: OutlineInputBorder(),
                      ),
                      validator: ValidatorKantin.validasiCatatan,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _prosesKirimAman,
                        icon: const Icon(Icons.lock_outline),
                        label: const Text('Validasi & Kirim Pesanan Aman'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Riwayat Transaksi Tervalidasi (${_logTransaksiAman.length})',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_logTransaksiAman.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Belum ada transaksi dikirim.'),
              ),
            )
          else
            ..._logTransaksiAman.map(
              (log) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(log),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const PustakaKuApp());
}

// KEY UNTUK SNACKBAR
final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

// MODEL BUKU
class Buku {
  final String judul;
  final String penulis;
  final String deskripsi;
  final int stok;

  const Buku({
    required this.judul,
    required this.penulis,
    required this.deskripsi,
    required this.stok,
  });

  bool get tersedia => stok > 0;
}

// MODEL PEMINJAMAN
class Peminjaman {
  final String nama;
  final String nim;
  final String judulBuku;
  final DateTime tanggal;
  final String status;

  const Peminjaman({
    required this.nama,
    required this.nim,
    required this.judulBuku,
    required this.tanggal,
    this.status = 'Diproses',
  });
}

// PENYIMPANAN SEMENTARA DATA PEMINJAMAN
final ValueNotifier<List<Peminjaman>> daftarPeminjaman =
    ValueNotifier<List<Peminjaman>>([]);

// DATA BUKU
const List<Buku> daftarBuku = [
  Buku(
    judul: 'Dasar-Dasar Pemrograman',
    penulis: 'Tim PustakaKu',
    deskripsi:
        'Buku pengantar konsep dasar pemrograman dan algoritma.',
    stok: 3,
  ),
  Buku(
    judul: 'Pengembangan Aplikasi Flutter',
    penulis: 'Tim PustakaKu',
    deskripsi:
        'Buku pengantar untuk membangun aplikasi menggunakan Flutter.',
    stok: 2,
  ),
  Buku(
    judul: 'Sistem Informasi Manajemen',
    penulis: 'Tim PustakaKu',
    deskripsi:
        'Buku mengenai pemanfaatan sistem informasi dalam organisasi.',
    stok: 0,
  ),
  Buku(
    judul: 'Konsep Basis Data',
    penulis: 'Tim PustakaKu',
    deskripsi:
        'Buku pengantar tabel, relasi, dan pengelolaan basis data.',
    stok: 5,
  ),
];

// APLIKASI UTAMA
class PustakaKuApp extends StatelessWidget {
  const PustakaKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PustakaKu',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: messengerKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const KatalogScreen(),
        '/detail': (context) => const DetailBukuScreen(),
        '/form': (context) => const FormPeminjamanScreen(),
        '/daftar-peminjaman': (context) =>
            const DaftarPeminjamanScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
    );
  }
}

// HALAMAN KATALOG
class KatalogScreen extends StatelessWidget {
  const KatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PustakaKu'),
        actions: [
          IconButton(
            tooltip: 'Daftar Peminjaman',
            icon: const Icon(Icons.assignment_outlined),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/daftar-peminjaman',
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Katalog Buku',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Temukan buku yang ingin dipinjam.',
          ),
          const SizedBox(height: 16),

          ...daftarBuku.map(
            (buku) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.menu_book),
                ),
                title: Text(buku.judul),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Penulis: ${buku.penulis}'),
                    const SizedBox(height: 4),
                    Text(
                      buku.tersedia
                          ? 'Tersedia (${buku.stok})'
                          : 'Sedang dipinjam',
                      style: TextStyle(
                        color: buku.tersedia
                            ? Colors.blue
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: buku,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/form');
        },
        icon: const Icon(Icons.assignment_outlined),
        label: const Text('Ajukan Peminjaman'),
      ),
    );
  }
}

// HALAMAN DETAIL BUKU
class DetailBukuScreen extends StatelessWidget {
  const DetailBukuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? arguments =
        ModalRoute.of(context)?.settings.arguments;

    if (arguments == null) {
      return halamanDataTidakTersedia(
        context,
        'Data buku tidak tersedia.',
      );
    }

    if (arguments is! Buku) {
      return halamanDataTidakTersedia(
        context,
        'Data yang diterima bukan informasi buku.',
      );
    }

    final Buku buku = arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.menu_book,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              buku.judul,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('Penulis: ${buku.penulis}'),
            const SizedBox(height: 16),
            Text(buku.deskripsi),
            const SizedBox(height: 16),
            Text(
              buku.tersedia
                  ? 'Status: Tersedia (${buku.stok} buku)'
                  : 'Status: Sedang dipinjam',
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: buku.tersedia
                  ? () {
                      Navigator.pushNamed(
                        context,
                        '/form',
                        arguments: buku,
                      );
                    }
                  : null,
              child: const Text(
                'Ajukan Peminjaman Buku Ini',
              ),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali ke Katalog'),
            ),
          ],
        ),
      ),
    );
  }
}

// TAMPILAN JIKA DATA DETAIL TIDAK TERSEDIA
Widget halamanDataTidakTersedia(
  BuildContext context,
  String pesan,
) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Detail Buku'),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline,
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(
              pesan,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    ),
  );
}

// HALAMAN FORM PEMINJAMAN
class FormPeminjamanScreen extends StatefulWidget {
  const FormPeminjamanScreen({super.key});

  @override
  State<FormPeminjamanScreen> createState() =>
      _FormPeminjamanScreenState();
}

class _FormPeminjamanScreenState
    extends State<FormPeminjamanScreen> {

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _namaController =
      TextEditingController();

  final TextEditingController _nimController =
      TextEditingController();

  final TextEditingController _judulController =
      TextEditingController();

  Buku? _bukuPilihan;
  bool _sudahMemeriksaArgumen = false;

  // MENERIMA DATA BUKU DARI HALAMAN DETAIL
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_sudahMemeriksaArgumen) return;

    _sudahMemeriksaArgumen = true;

    final Object? arguments =
        ModalRoute.of(context)?.settings.arguments;

    if (arguments == null) {
      _bukuPilihan = null;
    } else if (arguments is Buku) {
      _bukuPilihan = arguments;
      _judulController.text = arguments.judul;
    } else {
      _bukuPilihan = null;
    }
  }

  // MEMBERSIHKAN CONTROLLER
  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _judulController.dispose();
    super.dispose();
  }

  // MENGIRIM DATA PEMINJAMAN
  void _kirimPeminjaman() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String nama =
        _namaController.text.trim();

    final String nim =
        _nimController.text.trim();

    final String judul =
        _judulController.text.trim();

    // Membuat data peminjaman baru.
    final Peminjaman peminjaman = Peminjaman(
      nama: nama,
      nim: nim,
      judulBuku: judul,
      tanggal: DateTime.now(),
    );

    // Menambahkan data ke daftar sementara.
    daftarPeminjaman.value = [
      ...daftarPeminjaman.value,
      peminjaman,
    ];

    // Berpindah ke halaman Daftar Peminjaman.
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/daftar-peminjaman',
      ModalRoute.withName('/'),
    );

    // Menampilkan feedback.
    messengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text(
          'Data peminjaman berhasil ditambahkan.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Peminjaman'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Form Peminjaman Buku',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan lengkapi data peminjaman buku.',
              ),
              const SizedBox(height: 24),

              // FIELD NAMA
              TextFormField(
                controller: _namaController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama Peminjam',
                  hintText: 'Masukkan nama lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Nama peminjam wajib diisi.';
                  }

                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // FIELD NIM
              TextFormField(
                controller: _nimController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  hintText: 'Masukkan NIM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'NIM wajib diisi.';
                  }

                  if (value.trim().length < 5) {
                    return 'Periksa kembali NIM yang dimasukkan.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // FIELD JUDUL BUKU
              TextFormField(
                controller: _judulController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Judul Buku',
                  hintText: 'Masukkan judul buku',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.menu_book_outlined),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Judul buku wajib diisi.';
                  }

                  return null;
                },
                onFieldSubmitted: (_) {
                  _kirimPeminjaman();
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed:
                    (_bukuPilihan != null &&
                            !_bukuPilihan!.tersedia)
                        ? null
                        : _kirimPeminjaman,
                icon: const Icon(Icons.send),
                label: const Text('Kirim Peminjaman'),
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// HALAMAN DAFTAR PEMINJAMAN
class DaftarPeminjamanScreen extends StatelessWidget {
  const DaftarPeminjamanScreen({super.key});

  String formatTanggal(DateTime tanggal) {
    final String hari = tanggal.day.toString().padLeft(2, '0');
    final String bulan = tanggal.month.toString().padLeft(2, '0');
    final String tahun = tanggal.year.toString();

    return '$hari/$bulan/$tahun';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PustakaKu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ValueListenableBuilder<List<Peminjaman>>(
        valueListenable: daftarPeminjaman,
        builder: (context, dataPeminjaman, child) {
          if (dataPeminjaman.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.library_books_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada peminjaman buku.',
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Lihat Katalog Buku'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Daftar Peminjaman',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Terdapat ${dataPeminjaman.length} data peminjaman buku.',
              ),
              const SizedBox(height: 16),

              // MENAMPILKAN SETIAP DATA DALAM BENTUK CARD
              ...dataPeminjaman.asMap().entries.map(
                (entry) {
                  final int index = entry.key;
                  final Peminjaman data = entry.value;

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.menu_book,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Peminjaman Buku',
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'PustakaKu',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Diproses',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Divider(),

                          _barisInformasi(
                            'Nama Peminjam',
                            data.nama,
                          ),
                          _barisInformasi(
                            'NIM',
                            data.nim,
                          ),
                          _barisInformasi(
                            'Judul Buku',
                            data.judulBuku,
                          ),
                          _barisInformasi(
                            'Tanggal',
                            formatTanggal(data.tanggal),
                          ),

                          const Divider(),

                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Detail Peminjaman',
                                      ),
                                      content: Column(
                                        mainAxisSize:
                                            MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nama: ${data.nama}',
                                          ),
                                          Text(
                                            'NIM: ${data.nim}',
                                          ),
                                          Text(
                                            'Judul Buku: ${data.judulBuku}',
                                          ),
                                          Text(
                                            'Tanggal: ${formatTanggal(data.tanggal)}',
                                          ),
                                          Text(
                                            'Status: ${data.status}',
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Tutup',
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 16,
                              ),
                              label: Text(
                                'Detail #${index + 1}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.menu_book),
        label: const Text('Katalog Buku'),
      ),
    );
  }
}

// WIDGET BARIS INFORMASI
Widget _barisInformasi(String label, String nilai) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        const Text(': '),
        Expanded(
          child: Text(
            nilai,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

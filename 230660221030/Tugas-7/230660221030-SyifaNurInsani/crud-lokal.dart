
import 'package:flutter/material.dart';

void main() {
  runApp(const PustakaKuApp());
}

// MODEL DATA PEMINJAMAN
class Peminjaman {
  final String id;
  final String nama;
  final String nim;
  final String judulBuku;
  final DateTime tanggal;
  final String status;

  const Peminjaman({
    required this.id,
    required this.nama,
    required this.nim,
    required this.judulBuku,
    required this.tanggal,
    required this.status,
  });

  @override
  String toString() {
    return 'Peminjaman(id: $id, nama: $nama, nim: $nim, '
        'judulBuku: $judulBuku, tanggal: $tanggal, status: $status)';
  }
}

// APLIKASI UTAMA
class PustakaKuApp extends StatelessWidget {
  const PustakaKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PustakaKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const DaftarPeminjamanScreen(),
    );
  }
}

// HALAMAN DAFTAR PEMINJAMAN
class DaftarPeminjamanScreen extends StatefulWidget {
  const DaftarPeminjamanScreen({super.key});

  @override
  State<DaftarPeminjamanScreen> createState() =>
      _DaftarPeminjamanScreenState();
}

class _DaftarPeminjamanScreenState
    extends State<DaftarPeminjamanScreen> {
  // DATA DISIMPAN DI STATE
  final List<Peminjaman> daftarPeminjaman = [];

  // DAFTAR BUKU
  final List<String> daftarBuku = [
    'Dasar-Dasar Pemrograman',
    'Pengembangan Aplikasi Flutter',
    'Sistem Informasi Manajemen',
    'Konsep Basis Data',
  ];

  // FORMAT TANGGAL
  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}/'
        '${tanggal.month.toString().padLeft(2, '0')}/'
        '${tanggal.year}';
  }

  // CREATE: TAMBAH DATA PEMINJAMAN
  Future<void> tambahPeminjaman() async {
    final hasil = await showDialog<Peminjaman>(
      context: context,
      builder: (context) {
        return FormPeminjamanDialog(
          daftarBuku: daftarBuku,
        );
      },
    );

    if (hasil != null) {
      setState(() {
        daftarPeminjaman.add(hasil);
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data peminjaman berhasil ditambahkan.'),
        ),
      );
    }
  }

  // UPDATE: UBAH STATUS PEMINJAMAN
  Future<void> ubahStatus(Peminjaman peminjaman) async {
    String statusBaru = peminjaman.status;

    final hasil = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Ubah Status Peminjaman'),
              content: DropdownButtonFormField<String>(
                value: statusBaru,
                decoration: const InputDecoration(
                  labelText: 'Pilih Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Diproses',
                    child: Text('Diproses'),
                  ),
                  DropdownMenuItem(
                    value: 'Disetujui',
                    child: Text('Disetujui'),
                  ),
                  DropdownMenuItem(
                    value: 'Ditolak',
                    child: Text('Ditolak'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      statusBaru = value;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, statusBaru);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (hasil == null) return;

    // MENCARI DATA BERDASARKAN ID
    final index = daftarPeminjaman.indexWhere(
      (item) => item.id == peminjaman.id,
    );

    if (index != -1) {
      setState(() {
        // MENGGANTI OBJEK LAMA DENGAN OBJEK BARU
        daftarPeminjaman[index] = Peminjaman(
          id: peminjaman.id,
          nama: peminjaman.nama,
          nim: peminjaman.nim,
          judulBuku: peminjaman.judulBuku,
          tanggal: peminjaman.tanggal,
          status: hasil,
        );
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status peminjaman berhasil diperbarui.'),
        ),
      );
    }
  }

  // DELETE: KONFIRMASI DAN HAPUS DATA
  Future<void> hapusPeminjaman(Peminjaman peminjaman) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Peminjaman?'),
          content: Text(
            'Apakah data peminjaman ${peminjaman.nama} '
            'untuk buku "${peminjaman.judulBuku}" '
            'akan dihapus?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi == true) {
      setState(() {
        // MENGHAPUS DATA BERDASARKAN ID
        daftarPeminjaman.removeWhere(
          (item) => item.id == peminjaman.id,
        );
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data peminjaman berhasil dihapus.'),
        ),
      );
    }
  }

  // READ: MENAMPILKAN DAFTAR DATA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PustakaKu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Peminjaman',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Kelola data peminjaman buku di PustakaKu.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: daftarPeminjaman.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 65,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Belum ada data peminjaman.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Tekan tombol di bawah untuk menambahkan data.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: daftarPeminjaman.length,
                      itemBuilder: (context, index) {
                        final peminjaman =
                            daftarPeminjaman[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.menu_book,
                                      color: Colors.indigo,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        peminjaman.judulBuku,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Text('Nama: ${peminjaman.nama}'),
                                const SizedBox(height: 5),
                                Text('NIM: ${peminjaman.nim}'),
                                const SizedBox(height: 5),
                                Text(
                                  'Tanggal: ${formatTanggal(peminjaman.tanggal)}',
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Text(
                                      'Status: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Chip(
                                      label: Text(peminjaman.status),
                                      backgroundColor:
                                          peminjaman.status == 'Disetujui'
                                              ? Colors.green.shade100
                                              : peminjaman.status == 'Ditolak'
                                                  ? Colors.red.shade100
                                                  : Colors.orange.shade100,
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () =>
                                          ubahStatus(peminjaman),
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Ubah Status'),
                                    ),
                                    IconButton(
                                      tooltip: 'Hapus Peminjaman',
                                      onPressed: () =>
                                          hapusPeminjaman(peminjaman),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: tambahPeminjaman,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Peminjaman'),
      ),
    );
  }
}

// FORM TAMBAH PEMINJAMAN
class FormPeminjamanDialog extends StatefulWidget {
  final List<String> daftarBuku;

  const FormPeminjamanDialog({
    super.key,
    required this.daftarBuku,
  });

  @override
  State<FormPeminjamanDialog> createState() =>
      _FormPeminjamanDialogState();
}

class _FormPeminjamanDialogState
    extends State<FormPeminjamanDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController =
      TextEditingController();

  final TextEditingController nimController =
      TextEditingController();

  String? bukuTerpilih;

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    super.dispose();
  }

  void simpanPeminjaman() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dataBaru = Peminjaman(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nama: namaController.text.trim(),
      nim: nimController.text.trim(),
      judulBuku: bukuTerpilih!,
      tanggal: DateTime.now(),
      status: 'Diproses',
    );

    Navigator.pop(context, dataBaru);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Peminjaman'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Peminjam',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama peminjam wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: bukuTerpilih,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Judul Buku',
                  border: OutlineInputBorder(),
                ),
                items: widget.daftarBuku.map((judul) {
                  return DropdownMenuItem(
                    value: judul,
                    child: Text(
                      judul,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    bukuTerpilih = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Silakan pilih buku';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: simpanPeminjaman,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

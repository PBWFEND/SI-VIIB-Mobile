import 'package:flutter/material.dart';
void main() {
    runApp(const AplikasiPerpustakaan());
}

// Model Data Sederhana
class DataBuku{
    final String id;
    final String judul;
    final String pengarang;
    final String kategori;
    final bool tersedia;

Cost DataBuku({
    required this.id,
    required this.judul,
    required this.pengarang,
    required this.kategori,
    required this.tersedia,
});
}

class AplikasiPerpustakaan extends StatelessWidget {
    const AplikasiPerpustakaan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Perpustakaan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LayarKatalogUtama(),
        '/form-pinjam': (context) => const LayarFormPinjam(),
        '/detail-buku': (context) => const LayarDetailBuku(),
      },
    );
  }
}

// 1. Layar Utama (Katalog)
class LayarKatalogUtama extends StatelessWidget {
  const LayarKatalogUtama({super.key});

  final List<DataBuku> daftarBuku = const [
    DataBuku(
      id: 'B01',
      judul: 'Pemrograman Mobile dengan Flutter',
      pengarang: 'Tim Dosen SI',
      kategori: 'Teknologi',
      tersedia: true,
    ),
    DataBuku(
      id: 'B02',
      judul: 'Analisis dan Perancangan Sistem',
      pengarang: 'Prof. Suparno',
      kategori: 'Sistem Informasi',
      tersedia: true,
    ),
    DataBuku(
      id: 'B03',
      judul: 'Basis Data Lanjutan',
      pengarang: 'Dr. Ahmad',
      kategori: 'Komputer',
      tersedia: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Perpustakaan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: daftarBuku.length,
        itemBuilder: (context, index) {
          final buku = daftarBuku[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            child: ListTile(
              title: Text(
                buku.judul,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${buku.pengarang} • ${buku.kategori}'),
              trailing: Chip(
                label: Text(
                  buku.tersedia ? 'Tersedia' : 'Dipinjam',
                  style: TextStyle(
                    color: buku.tersedia ? Colors.green[900] : Colors.red[900],
                    fontSize: 12,
                  ),
                ),
                backgroundColor:
                    buku.tersedia ? Colors.green[100] : Colors.red[100],
              ),
              onTap: () {
                // Pengiriman data via arguments
                Navigator.pushNamed(
                  context,
                  '/detail-buku',
                  arguments: buku,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/form-pinjam');
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajukan Peminjaman'),
      ),
    );
  }
}

// 2. Layar Form Peminjaman (StatefulWidget)
class LayarFormPinjam extends StatefulWidget {
  const LayarFormPinjam({super.key});

  @override
  State<LayarFormPinjam> createState() => _LayarFormPinjamState();
}

class _LayarFormPinjamState extends State<LayarFormPinjam> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _judulBukuController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _judulBukuController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return; // Berhenti jika form tidak valid
    }

    final nama = _namaController.text.trim();
    final buku = _judulBukuController.text.trim();

    // Feedback instan SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Peminjaman "$buku" oleh $nama berhasil dikirim (simulasi).'),
        backgroundColor: Colors.green[800],
      ),
    );

    // Kembali ke layar sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Peminjaman Buku'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap Mahasiswa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _judulBukuController,
                decoration: const InputDecoration(
                  labelText: 'Judul Buku yang Dipinjam',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul buku wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send),
                label: const Text('Kirim Pengajuan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. Layar Detail Buku (Read-Only)
class LayarDetailBuku extends StatelessWidget {
  const LayarDetailBuku({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca arguments dengan type check & null branch
    final args = ModalRoute.of(context)?.settings.arguments;
    final buku = args is DataBuku ? args : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku'),
      ),
      body: buku == null
          ? const Center(
              child: Text('Data buku tidak ditemukan atau kosong.'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buku.judul,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Divider(height: 24),
                      Text('Kode Buku: ${buku.id}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Pengarang: ${buku.pengarang}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Kategori: ${buku.kategori}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Status: ', style: TextStyle(fontSize: 16)),
                          Chip(
                            label: Text(
                              buku.tersedia ? 'Tersedia' : 'Dipinjam',
                              style: TextStyle(
                                color: buku.tersedia
                                    ? Colors.green[900]
                                    : Colors.red[900],
                              ),
                            ),
                            backgroundColor: buku.tersedia
                                ? Colors.green[100]
                                : Colors.red[100],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Kembali ke Katalog'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
}
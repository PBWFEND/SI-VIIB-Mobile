# Tes Konsep UTS — Annisa Nur Sabariyah (230660221085)

## Soal 1 — Konsep Aplikasi Bergerak dalam SI

1. Karakteristik: Portabilitas dan Aksesibilitas Kapan Saja (Portability & Anywhere Access)
   Contoh penerapan: Mahasiswa dapat mengecek katalog dan mengajukan peminjaman buku kapan saja langsung dari smartphone mereka tanpa harus hadir secara fisik di perpustakaan atau terikat oleh jam operasional loket.

2. Karakteristik: Notifikasi Push Real-Time (Real-time Push Notifications)
   Contoh penerapan: Aplikasi dapat mengirimkan pemberitahuan pengingat tenggat waktu pengembalian buku atau perubahan status peminjaman (misal: "Buku Siap Diambil") secara langsung ke layar perangkat mahasiswa.

3. Karakteristik: Pemanfaatan Kapabilitas Perangkat / Pemindaian Kamera & Penyimpanan Lokal (Hardware & Local Storage Integration)
   Contoh penerapan: Mahasiswa dapat memanfaatkan kamera smartphone untuk memindai barcode/QR Code buku saat melakukan pencarian di rak, serta menyimpan data peminjaman secara lokal di perangkat agar riwayat tetap dapat diakses saat koneksi internet lambat.

---

## Soal 2 — Dasar Pemrograman Dart

- List<String> daftarSurat = []: Mendeklarasikan variabel `daftarSurat` berjenis List koleksi dinamis yang khusus menampung elemen tipe data `String`, serta diinisialisasi sebagai List kosong (`[]`).
- Parameter String jenis: Parameter masukan bertipe `String` pada fungsi `tambahSurat` yang menerima nama atau jenis surat/layanan yang akan dimasukkan ke dalam daftar koleksi.
- jenis.isEmpty: Properti boolean bawaan String yang mengembalikan nilai `true` jika variabel `jenis` tidak memiliki karakter (panjang string = 0).
- return pada kondisi error: Menghentikan eksekusi baris kode di dalam fungsi secara langsung ketika validasi `jenis.isEmpty` terpenuhi (`true`), sehingga kode penambahan data `daftarSurat.add(jenis)` di bawahnya tidak dijalankan.
- daftarSurat.add(jenis): Method koleksi List untuk memasukkan nilai variabel `jenis` ke urutan/indeks paling akhir dari `daftarSurat`.
- Perulangan for: Konstruksi kontrol perulangan berbasis indeks (`for (int i = 0; i < daftarSurat.length; i++)`) yang melakukan iterasi untuk mengakses dan mencetak setiap elemen `daftarSurat` secara berurutan.

Kesalahan umum bila validasi isEmpty dihapus:
Data berupa String kosong (`""` atau karakter tidak terisi) akan tetap masuk ke dalam `daftarSurat`. Hal ini mengakibatkan inkonsistensi data di mana antarmuka pengguna (UI) akan menampilkan baris kosong tanpa teks pada daftar, yang merusak tampilan dan mengganggu validitas data Sistem Informasi. Selain itu, kesalahan sintaksis seperti penulisan `.Lenght` (seharusnya `.length`) juga dapat memicu compile error pada Dart.

---

## Soal 3 — Struktur Flutter dan Widget

- MaterialApp: Widget utama (root) yang mengonfigurasi aplikasi Flutter dengan tema Material Design, judul aplikasi ('Aplikasi Peminjaman Buku Perpustakaan'), serta struktur rute navigasi.
- Scaffold: Widget kerangka dasar antarmuka halaman yang menyediakan struktur visual utama seperti AppBar, body (area konten utama), dan FloatingActionButton.
- AppBar: Widget bilah bagian atas (header) yang menampilkan judul halaman ('Katalog Perpustakaan' / 'Peminjaman Buku') serta warna latar belakang tema.
- Column: Widget tata letak (layout) yang menyusun elemen-elemen anaknya secara vertikal dari atas ke bawah.
- Text: Widget untuk menampilkan string teks di layar seperti judul buku, nama peminjam, atau status ketersediaan.
- ListView.builder: Widget daftar gulir (scrollable list) yang merender elemen anak secara dinamis dan efisien (lazy loading) sesuai dengan jumlah data koleksi.

Masalah bila ListView.builder di dalam Column tanpa Expanded:
Terjadi error RenderFlex overflow (biasanya ditandai dengan garis-garis kuning-hitam di layar atau pesan 'Vertical viewport was given unbounded height' pada konsol debug).
Penyebab: Column memberikan ruang vertikal tanpa batas (unbounded height) kepada anak-anaknya, sedangkan ListView.builder secara bawaan membutuhkan batasan tinggi yang jelas (bounded height) dari induknya agar dapat menghitung area yang bisa digulirkan.
Perbaikan: Membungkus ListView.builder dengan widget Expanded. Widget Expanded akan memaksa ListView.builder untuk mengambil sisa ruang vertikal yang tersedia di dalam Column tanpa memicu overflow.

---

## Soal 4 — Analisis Kebutuhan dan User Flow

Klasifikasi dan prioritas:

| No. | Permintaan | Fungsional/Nonfungsional | Prioritas MoSCoW | Alasan |
|:---:|:-----------|:-------------------------|:----------------:|:-------|
| 1   | "Saya ingin mengajukan surat keterangan aktif kuliah." | Fungsional | Must | Merupakan fungsi inti (core business process) layanan. Tanpa fitur ini, aplikasi tidak memiliki nilai guna utama bagi pengguna. |
| 2   | "Saya ingin melihat status pengajuan saya." | Fungsional | Must | Krusial untuk transparansi proses; pengguna perlu memantau apakah pengajuannya dalam status menunggu, disetujui, atau ditolak. |
| 3   | "Saya ingin menerima notifikasi saat surat siap diambil." | Fungsional | Should | Penting untuk meningkatkan kenyamanan pengguna, namun jika belum ada, alur utama aplikasi tetap dapat berjalan melalui pengecekan status manual secara berkala. |

User flow untuk kebutuhan Must (Mengajukan Peminjaman Buku):
1. Mahasiswa membuka aplikasi dan masuk ke Halaman Utama (Katalog Buku).
2. Mahasiswa menekan tombol "Tambah Data" / "Ajukan Peminjaman".
3. Sistem menampilkan Form Peminjaman Buku (Modal Bottom Sheet / Form Page).
4. Mahasiswa mengisi data (Judul Buku, Nama Peminjam, Kategori) dan menekan tombol "Simpan Data".
5. Sistem memvalidasi kelengkapan data form. Jika ada field kosong, sistem menampilkan pesan kesalahan input di bawah field terkait.
6. Jika form valid, sistem membuat ID unik (`millisecondsSinceEpoch`) dan menambahkan data ke state aplikasi.
7. Sistem memberikan feedback instan berupa `SnackBar` konfirmasi sukses dan menutup form (`Navigator.pop`).
8. Mahasiswa melihat data peminjaman terbaru langsung muncul pada Halaman Utama dengan status awal "Dipinjam".

---

## Soal 5 — UI/UX Mobile

1. Prinsip: Target Sentuh yang Memadai & Aksesibilitas Ibu Jari (Thumb Zone)
   Keputusan desain: Menempatkan tombol aksi utama pembuatan peminjaman menggunakan `FloatingActionButton.extended` bertuliskan "Tambah Data" di pojok kanan bawah antarmuka.
   Alasan: Mayoritas penggunaan smartphone dilakukan dengan satu tangan (ibu jari). Penempatan FAB di pojok kanan bawah memastikan tombol mudah dijangkau dengan target sentuh memadai (minimal 48x48 dp) tanpa menghalangi konten daftar di atasnya.

2. Prinsip: Kejelasan Feedback Visual & Efisiensi Informasi (Visual Feedback)
   Keputusan desain: Menggunakan komponen `Chip` / label status dengan warna dinamis berbasis kondisi ternary (Hijau = Tersedia, Oranye/Merah = Dipinjam) pada setiap kartu item.
   Alasan: Pengguna mobile memiliki sesi penggunaan yang singkat. Penggunaan label warna dinamis memungkinkan mahasiswa memahami kondisi ketersediaan buku secara instan melalui pemindaian visual singkat (scanability) tanpa perlu membaca seluruh teks detail.

3. Prinsip: Kejelasan Status Keadaan Kosong (Empty State Handling)
   Keputusan desain: Menyediakan tampilan keadaan kosong menggunakan kombinasi ikon dan teks penjelasan di tengah layar (`Center`) yang otomatis aktif saat data peminjaman kosong.
   Alasan: Mengeliminasi kebingungan pengguna baru agar tidak dihadapkan pada layar putih polos (yang sering disalahartikan sebagai aplikasi error/loading buntu), serta memberikan arahan visual bahwa belum ada transaksi yang tercatat.

---

## Soal 6 — Navigasi dan Interaksi

Metode navigasi dan kapan digunakan:
- push: Menambahkan halaman baru ke atas tumpukan (stack) navigasi. Digunakan untuk berpindah layar secara dinamis dengan mengoper data secara langsung melalui konstruktor.
- pushNamed: Menambahkan halaman baru berdasarkan nama rute yang telah terdaftar pada peta `routes` di `MaterialApp` (misalnya: `/form-pinjam` atau `/detail-buku`). Digunakan untuk menjaga struktur navigasi terpusat dan mudah dipelihara.
- pop: Menghapus rute teratas dari tumpukan navigasi untuk kembali ke halaman sebelumnya (misalnya: menekan tombol 'Kembali' atau setelah tombol 'Simpan' berhasil diproses).

Pengiriman data jenis surat / objek data ke halaman form/detail:
Data dikirimkan sebagai objek melalui parameter `arguments` pada method `Navigator.pushNamed(context, '/detail-buku', arguments: dataBuku)`. Di halaman tujuan, data dibaca secara aman menggunakan `ModalRoute.of(context)?.settings.arguments` dengan pemeriksaan tipe data (`args is DataBuku`) dan penanganan cabang null untuk mencegah crash.

Feedback setelah form dikirim:
Feedback diberikan dalam dua tahap:
1. Feedback Validasi Input: Menampilkan pesan kesalahan merah tepat di bawah kolom input jika data belum terisi (`value.trim().isEmpty`).
2. Feedback Konfirmasi Aksi: Setelah validasi berhasil (`_formKey.currentState!.validate()`), sistem menampilkan `SnackBar` di bagian bawah layar sebagai konfirmasi bahwa data berhasil ditambahkan/diproses, dilanjutkan dengan pemanggilan `Navigator.pop(context)`.

---

## Soal 7 — Model Data dan State

Mengapa setiap field bersifat final:
Properti bersifat `final` untuk menjaga imutabilitas (immutability) objek `DataBuku`. Hal ini mencegah data diubah secara tidak sengaja di luar mekanisme manajemen state resmi, sehingga membuat aliran data aplikasi lebih terprediksi dan aman dari bug konsistensi data.

Mengapa id wajib ada:
`id` berfungsi sebagai pengenal unik (unique identifier) untuk setiap entitas peminjaman. Tanpa `id`, aplikasi tidak dapat membedakan dua transaksi peminjaman yang memiliki judul atau nama peminjam yang sama saat melakukan pembaruan status (Update) atau penghapusan (Delete).

Perbedaan StatelessWidget dan StatefulWidget:
`StatelessWidget` adalah widget statis yang tampilan UI-nya tidak pernah berubah setelah di-build pertama kali. Sedangkan `StatefulWidget` memuat objek `State` yang dapat mengubah tampilannya secara dinamis selama runtime ketika terjadi pembaruan data/state.
Halaman daftar menggunakan: StatefulWidget (`LayarUtamaCrud`)
Alasan: Halaman daftar bersifat dinamis di mana konten antarmuka harus langsung memperbarui tampilannya saat pengguna menambah peminjaman baru, mengubah status ketersediaan, atau menghapus data.

Fungsi setState:
`setState` menginstruksikan framework Flutter bahwa state internal objek telah berubah, yang memicu framework untuk menjalankan ulang fungsi `build()` dan merender ulang antarmuka pengguna (UI) sesuai dengan data terbaru.

Apa yang terjadi bila data ditambah tanpa setState:
Data dalam `List` memori akan bertambah, tetapi UI tidak akan merender ulang tampilannya. Pengguna tidak akan melihat item baru tersebut di layar sampai terjadi peristiwa re-render lain.

---

## Soal 8 — CRUD Lokal

| Operasi | Method List / mekanisme |
|:--------|:------------------------|
| Create  | `_daftarBuku.add(baru)` |
| Read    | Iterasi `ListView.builder` membaca `_daftarBuku[index]` |
| Update  | Menggunakan `indexWhere((b) => b.id == id)` lalu mengganti elemen `_daftarBuku[index] = DataBuku(...)` |
| Delete  | `_daftarBuku.removeWhere((b) => b.id == buku.id)` diawali dengan konfirmasi `showDialog` |

Mengapa id digunakan sebagai kunci update dan delete:
`id` bernilai unik dan permanen bagi setiap objek data (dihasilkan melalui timestamp `DateTime.now().millisecondsSinceEpoch.toString()`).

Konsekuensi bila index digunakan sebagai kunci:
Jika index daftar digunakan sebagai kunci, dapat terjadi kesalahan operasi (data mismatch). Hal ini dikarenakan posisi index bersifat dinamis; jika data disortir ulang, difilter, atau ada baris data yang dihapus sebelumnya, nilai index dari suatu item akan bergeser sehingga operasi update/delete dapat mengenai data yang salah.

---

## Soal 9 — Persistensi Data Lokal

Perbedaan in-memory dan persistensi:
Penyimpanan in-memory (`List<DataBuku>` pada State) menyimpan data di memori RAM sehingga data akan hilang secara permanen saat aplikasi ditutup atau di-restart. Sedangkan persistensi (`shared_preferences`) menyimpan data ke penyimpanan fisik perangkat (disk storage) sehingga data tetap tersimpan walaupun aplikasi ditutup atau HP di-restart.

Mengapa operasi shared_preferences asinkron (Future):
Operasi I/O (Input/Output) membaca dan menulis ke penyimpanan fisik membutuhkan waktu relatif lebih lama dibanding membaca RAM. Sifat asinkron (`Future`) digunakan agar proses I/O dilakukan di background thread tanpa memblokir thread utama antarmuka pengguna (UI thread) agar aplikasi tidak mengalami freeze.

Apa yang terjadi bila await diabaikan:
Eksekusi kode akan melompat ke baris berikutnya sebelum proses penulisan ke disk selesai. Akibatnya, data mungkin gagal tersimpan secara utuh atau aplikasi membaca data lama yang belum diperbarui (race condition).

Contoh situasi in-memory sudah cukup:
Menyimpan teks pencarian sementara (search query), status ekspansi widget accordion, atau nilai input sementara pada form yang belum disubmit.

Contoh situasi persistensi mutlak diperlukan:
Menyimpan riwayat pengajuan peminjaman buku yang sudah disubmit, token autentikasi login pengguna, atau pengaturan tema aplikasi agar tetap ada saat aplikasi dibuka kembali.

---

## Soal 10 — Integrasi Konsep Lintas Pertemuan (CPMK-1 s.d. CPMK-3)

1. Arsitektur:
   Aplikasi Mobile Flutter bertindak sebagai lapisan antarmuka pengguna (Client). Aplikasi berkomunikasi dengan Backend Sistem Informasi Perpustakaan melalui REST API menggunakan protokol HTTP Request dan HTTP Response dengan data berformat JSON. Backend kemudian melakukan Query dan Transaksi ke Database Perpustakaan untuk mengelola data buku dan peminjaman. Di sisi mobile, penyimpanan lokal (in-memory/shared_preferences) digunakan untuk menyimpan riwayat peminjaman sementara dan caching data saat offline.

2. Kebutuhan & Alur:
   Dua kebutuhan Must have:
   - Mahasiswa dapat melihat katalog daftar buku beserta status ketersediaannya (F-03).
   - Mahasiswa dapat mengajukan peminjaman buku dengan mengisi form (F-01).

   Alur pengguna dari membuka aplikasi hingga tugas selesai:
   Membuka Aplikasi -> Lihat Halaman Katalog Utama -> Tekan Tombol "Tambah Data" / "Pinjam" -> Mengisi Form Peminjaman (Judul, Nama Peminjam, Kategori) -> Tekan "Simpan Data" -> Validasi Form -> Sistem menambahkan data baru ke state & menampilkan SnackBar konfirmasi -> Pengguna melihat peminjaman baru bertambah pada daftar riwayat dengan status "Dipinjam".

3. Struktur Komponen:
   - Root Widget: `MaterialApp` dengan tema terpusat `ColorScheme.fromSeed(seedColor: Colors.teal)`.
   - Halaman Utama: `Scaffold`, `AppBar` ("Peminjaman Buku (Data Lokal)"), dan `body` berisi `ListView.builder` yang membungkus `Card` dan `ListTile`.
   - Halaman/Modal Form: `Form` dengan `TextFormField` (Judul, Peminjam, Kategori) dan `ElevatedButton` ("Simpan Data").
   - Navigasi: Menggunakan `showModalBottomSheet` / `Navigator.pushNamed` untuk membuka form dan `Navigator.pop` untuk kembali setelah data disimpan.

4. Data & State:
   Definisi model data DataBuku:
   ```dart
   class DataBuku {
     final String id;
     final String judul;
     final String peminjam;
     final String kategori;
     final String status;

     const DataBuku({
       required this.id,
       required this.judul,
       required this.peminjam,
       required this.kategori,
       required this.status,
     });
   }
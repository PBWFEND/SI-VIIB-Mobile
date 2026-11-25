# Tes Konsep UTS — Reina Anatasya Kusumah Putri 230660221103

## Soal 1 — Konsep Aplikasi Bergerak dalam SI (CPMK-1)

1. **Karakteristik: Mobilitas dan Akses Kapan Saja / Di Mana Saja (Ubiquitous Access)**
   * **Alasan teknis:** Perangkat mobile selalu dibawa pengguna dan terhubung ke jaringan seluler/Wi-Fi tanpa memerlukan ruang kerja tetap seperti komputer desktop.
   * **Contoh penerapan:** Mahasiswa tidak perlu datang ke gedung administrasi untuk mengambil formulir kertas; pengajuan surat keterangan aktif kuliah dapat dilakukan langsung dari ruang kelas, kantin, atau rumah melalui ponsel.

2. **Karakteristik: Pemberitahuan Real-Time (Push Notification)**
   * **Alasan teknis:** Sistem operasi mobile memiliki layanan notifikasi latar belakang yang langsung memberi tahu pengguna ketika terjadi perubahan status transaksi pada server Sistem Informasi.
   * **Contoh penerapan:** Ketika petugas administrasi selesai memvalidasi dan menandatangani surat, mahasiswa langsung menerima notifikasi di layar ponsel bahwa surat sudah siap diambil atau diunduh, sehingga tidak perlu bolak-balik mengecek loket.

3. **Karakteristik: Interaksi Cepat dan Personal (Context-Aware & Single-User Device)**
   * **Alasan teknis:** Ponsel melekat pada satu identitas pemilik dengan sesi autentikasi tersimpan serta mendukung fitur perangkat (seperti kamera/pemindai QR) untuk verifikasi cepat.
   * **Contoh penerapan:** Mahasiswa tidak perlu mengisi ulang biodata dasar (NIM, nama, program studi) setiap mengajukan surat karena identitas sudah terikat pada akun mobile, dan pengambilan fisik di loket cukup memindai kode QR bukti pengajuan.

---

## Soal 2 — Dasar Pemrograman Dart (CPMK-1)

* **`List<String> daftarSurat = [];`**: Mendeklarasikan variabel koleksi bertipe `List` yang hanya menerima elemen bertipe `String` dengan nilai awal kosong (`[]`) sebagai tempat menampung daftar jenis surat di memori.
* **Parameter `String jenis`**: Menerima input berupa teks (`String`) yang dikirimkan pemanggil fungsi `tambahSurat` untuk diproses dan disimpan ke dalam list.
* **`jenis.isEmpty`**: Properti boolean pada `String` untuk memeriksa apakah teks yang dimasukkan memiliki panjang karakter 0 (`""`), berfungsi sebagai gerbang validasi input.
* **`return` pada kondisi error**: Menghentikan eksekusi fungsi `tambahSurat` lebih awal (*early return*) tepat setelah mencetak pesan peringatan, sehingga baris kode penambahan data di bawahnya tidak dijalankan.
* **`daftarSurat.add(jenis)`**: Method bawaan `List` untuk menambahkan elemen `jenis` yang sudah lolos validasi ke posisi paling akhir dalam `daftarSurat`.
* **Perulangan `for`**: Melakukan iterasi terindeks dari `i = 0` hingga `daftarSurat.length - 1` untuk membaca seluruh isi daftar dan mencetaknya dengan nomor urut (`i + 1`).

**Kesalahan umum bila validasi `isEmpty` dihapus:**
String kosong (`""`) akan ikut tersimpan ke dalam `daftarSurat` dan ditampilkan sebagai baris nomor urut tanpa teks (data sampah/tidak valid) saat `tampilkanSurat()` dijalankan, sehingga merusak integritas daftar surat.

---

## Soal 3 — Struktur Flutter dan Widget (CPMK-1)

* **`MaterialApp`**: Widget akar (*root*) aplikasi yang menyediakan konfigurasi global desain Material Design, tema warna, judul aplikasi, serta manajemen navigasi layar (`home`/`routes`).
* **`Scaffold`**: Kerangka tata letak standar halaman Material yang menyediakan slot struktur visual seperti bilah atas (`appBar`), area konten utama (`body`), dan tombol aksi mengambang.
* **`AppBar`**: Bilah navigasi di bagian atas layar yang menampilkan judul halaman (`'Daftar Surat'`) serta tombol navigasi/aksi kontekstual.
* **`Column`**: Widget tata letak (*layout*) yang menyusun daftar widget anaknya (`children`) secara vertikal dari atas ke bawah.
* **`Text`**: Widget dasar untuk merender dan menampilkan rangkaian karakter teks (`'Pilih jenis surat'`) di layar.
* **`ListView.builder`**: Widget daftar gulir (*scrollable list*) yang membangun item secara dinamis dan efisien (*lazy rendering*) hanya untuk item yang terlihat di layar.

**Masalah bila `ListView.builder` di dalam `Column` tanpa `Expanded`:**
* **Masalah:** Terjadi *runtime layout error* (`Vertical viewport was given unbounded height`) dan daftar gagal dirender.
* **Penyebab:** `Column` memberikan batasan tinggi tak terbatas (*unbounded height*) kepada anak-anaknya, sementara `ListView.builder` membutuhkan batas tinggi yang pasti untuk menghitung area gulir (*viewport*).
* **Perbaikan:** Membungkus `ListView.builder` dengan widget **`Expanded`** agar `ListView` mengambil sisa ruang vertikal yang tersedia di dalam `Column` secara terukur.

---

## Soal 4 — Analisis Kebutuhan dan User Flow (CPMK-2)

**Klasifikasi dan prioritas:**

| No. | Permintaan | Fungsional / Nonfungsional | Prioritas MoSCoW | Alasan |
| :-: | :--- | :--- | :-: | :--- |
| 1 | "Saya ingin mengajukan surat keterangan aktif kuliah." | **Fungsional** (aksi transaksi utama sistem) | **Must** | Merupakan fungsi inti layanan; tanpa fitur pengajuan surat, sistem tidak memiliki tujuan bisnis utama. |
| 2 | "Saya ingin melihat status pengajuan saya." | **Fungsional** (penyajian informasi progres transaksi) | **Must** | Menggantikan kebutuhan mahasiswa datang ke loket untuk menanyakan progres surat, sehingga efisiensi layanan tercapai. |
| 3 | "Saya ingin menerima notifikasi saat surat siap diambil." | **Fungsional** (fitur pemberitahuan otomatis) | **Should** | Sangat meningkatkan pengalaman pengguna agar tepat waktu mengambil surat, namun sistem inti tetap dapat berjalan meski mahasiswa mengecek status secara manual terlebih dahulu. |

**User flow untuk kebutuhan Must (Mengajukan Surat & Melihat Status):**
1. Mahasiswa membuka aplikasi mobile pengajuan surat dan masuk ke Halaman Utama (Daftar Jenis Surat & Riwayat Pengajuan).
2. Mahasiswa memilih menu **"Surat Keterangan Aktif Kuliah"** lalu menekan tombol ajukan untuk membuka Halaman Form Pengajuan.
3. Mahasiswa mengisi formulir keperluan surat dan memverifikasi data diri.
4. Mahasiswa menekan tombol **"Kirim Pengajuan"**.
5. Sistem memvalidasi kelengkapan input; jika tidak valid, sistem menampilkan pesan kesalahan di bawah kolom input.
6. Jika valid, sistem menyimpan data pengajuan dengan status awal **"Menunggu Verifikasi"** dan menampilkan umpan balik konfirmasi (`SnackBar`).
7. Aplikasi kembali ke Halaman Utama dan menampilkan pengajuan baru tersebut beserta status terkininya pada daftar riwayat.

---

## Soal 5 — UI/UX Mobile (CPMK-2)

1. **Prinsip: Hierarki Visual & Keterbacaan pada Layar Terbatas**
   * **Keputusan desain:** Menampilkan setiap jenis surat dalam komponen `Card` + `ListTile` dengan judul jenis surat menggunakan ukuran font lebih besar dan tebal (`titleMedium`), sementara keterangan persyaratan menggunakan teks lebih kecil dan redup (`bodySmall`).
   * **Alasan:** Ukuran layar ponsel sempit; hierarki tipografi membantu mahasiswa memindai 20 jenis surat dengan cepat tanpa kelelahan mata.

2. **Prinsip: Ukuran Target Sentuh yang Memadai (*Touch Target Size*)**
   * **Keputusan desain:** Memberikan jarak antar-kartu (`margin`) yang cukup dan memastikan area klik item atau tombol aksi memiliki tinggi minimal `48dp` serta menempatkan tombol aksi utama pada jangkauan ibu jari (*thumb zone*).
   * **Alasan:** Interaksi mobile menggunakan jari yang lebih lebar daripada kursor tetikus, sehingga target sentuh yang memadai mencegah kesalahan ketuk (*mis-tap*) pada item surat yang berdekatan.

3. **Prinsip: Umpan Balik Status Cepat (*Immediate Visual Feedback*) untuk Sesi Singkat**
   * **Keputusan desain:** Menggunakan lencana `Chip` berwarna kontras untuk membedakan status ketersediaan/proses setiap surat dalam sekali lirik.
   * **Alasan:** Mahasiswa umumnya menggunakan aplikasi kampus dalam sesi singkat di sela pergantian jam kuliah, sehingga informasi status harus langsung dipahami tanpa membuka halaman detail satu per satu.

---

## Soal 6 — Navigasi dan Interaksi (CPMK-2)

**Metode navigasi dan kapan digunakan:**
* **`Navigator.push`:** Digunakan untuk berpindah maju ke layar baru dengan membangun rute langsung (`MaterialPageRoute`) dan menumpuknya di atas *stack* layar saat ini.
* **`Navigator.pushNamed`:** Digunakan untuk berpindah maju ke layar tujuan menggunakan nama rute string yang sudah didaftarkan secara terpusat di `MaterialApp` (misalnya `Navigator.pushNamed(context, '/form')` saat tombol ajukan ditekan, dan `Navigator.pushNamed(context, '/detail')` saat kartu riwayat diketuk). Pendekatan ini dipilih karena lebih rapi dan mudah dilacak ke peta *navigation flow*.
* **`Navigator.pop`:** Digunakan untuk menutup layar paling atas pada *stack* navigasi dan kembali ke layar sebelumnya (misalnya saat tombol kembali pada `AppBar`, tombol batal, atau setelah form berhasil dikirim).

**Pengiriman data jenis surat ke halaman form:**
Data jenis surat dikirimkan melalui parameter **`arguments`** saat memanggil `Navigator.pushNamed(context, '/form', arguments: jenisSurat)`. Pada halaman form, data tersebut dibaca menggunakan `ModalRoute.of(context)?.settings.arguments` disertai pemeriksaan tipe (`is String`) agar aman dari nilai `null`.

**Feedback setelah form dikirim:**
Setelah seluruh `TextFormField` lolos pemeriksaan `_formKey.currentState!.validate()`, sistem memanggil **`ScaffoldMessenger.of(context).showSnackBar(...)`** untuk memunculkan bilah pesan konfirmasi di bagian bawah layar sebelum menjalankan `Navigator.pop(context)`, sehingga pengguna yakin pengajuannya telah tercatat dan tidak menekan tombol kirim berulang kali.

---

## Soal 7 — Model Data dan State (CPMK-3)

* **Mengapa setiap field bersifat `final`:** Untuk menjamin sifat *immutability* (data tidak dapat diubah secara sembarangan setelah objek dibuat), sehingga perubahan data selalu terkontrol melalui pembuatan objek baru dan mencegah bug inkonsistensi state.
* **Mengapa `id` wajib ada:** Sebagai pengenal unik (*primary key*) yang membedakan satu transaksi pengajuan dengan pengajuan lainnya meskipun jenis surat dan tanggalnya sama, sehingga operasi pembaruan status maupun penghapusan selalu tepat sasaran.

**Perbedaan `StatelessWidget` dan `StatefulWidget`:**
`StatelessWidget` bersifat statis dan tidak memiliki objek `State` internal yang dapat berubah selama widget hidup, sedangkan `StatefulWidget` memiliki kelas `State` pendamping yang mampu menyimpan data dinamis dan membangun ulang tampilan ketika data berubah.
* **Halaman daftar menggunakan:** **`StatefulWidget`**.
* **Alasan:** Daftar pengajuan bersifat dinamis karena jumlah item bertambah saat ada pengajuan baru, berubah statusnya saat diproses, dan berkurang saat dihapus.

**Fungsi `setState` dan akibat jika tidak dipanggil:**
`setState` berfungsi memberi tahu framework Flutter bahwa data internal di dalam `State` telah berubah sehingga method `build()` perlu dijalankan ulang untuk memperbarui antarmuka. Jika data ditambahkan ke `List` tanpa `setState`, data memang bertambah di memori, tetapi tampilan daftar di layar tidak akan berubah (tetap menampilkan daftar lama).

---

## Soal 8 — CRUD Lokal (CPMK-3)

| Operasi | Method `List` / Mekanisme |
| :--- | :--- |
| **Create** | `list.add(objekBaru)` di dalam `setState()` untuk menambahkan entitas pengajuan baru dari form ke akhir daftar. |
| **Read** | Membaca panjang daftar (`list.length`) dan mengakses elemen per indeks (`list[index]`) pada `ListView.builder` di dalam `build()`. |
| **Update** | Mencari posisi indeks dengan `list.indexWhere((item) => item.id == id)`, lalu mengganti elemen pada indeks tersebut (`list[index] = objekBaru`) di dalam `setState()`. |
| **Delete** | Menghapus elemen yang cocok menggunakan `list.removeWhere((item) => item.id == id)` di dalam `setState()` setelah konfirmasi `AlertDialog`. |

**Mengapa `id` digunakan sebagai kunci dan konsekuensi memakai `index`:**
`id` bersifat tetap dan unik sepanjang siklus hidup data. Jika `index` daftar digunakan sebagai kunci operasi, ketika satu item dihapus, indeks seluruh item di bawahnya akan bergeser maju. Akibatnya, operasi ubah atau hapus berikutnya berisiko mengenai item yang salah atau menimbulkan error `RangeError` (indeks di luar jangkauan).

---

## Soal 9 — Persistensi Data Lokal (CPMK-3)

* **Perbedaan *in-memory* dan persistensi (`shared_preferences`):** Penyimpanan *in-memory* hanya menyimpan data pada variabel RAM selama aplikasi aktif; seluruh data langsung hilang saat aplikasi ditutup atau di-*refresh*. Sebaliknya, persistensi menggunakan `shared_preferences` menuliskan data (dalam format teks JSON melalui `setString`) ke penyimpanan permanen perangkat, sehingga data dapat dimuat kembali (`getString`) saat aplikasi dibuka ulang.
* **Mengapa bersifat asinkron (`Future`) dan akibat mengabaikan `await`:** Operasi baca/tulis ke media penyimpanan perangkat membutuhkan waktu I/O yang tidak instan sehingga dibungkus dalam `Future` agar tidak memblokir *UI thread* (layar tidak membeku). Jika kata kunci `await` diabaikan saat menyimpan data, eksekusi program langsung melompat ke baris berikutnya sebelum proses penulisan ke penyimpanan selesai, sehingga data berisiko tidak tersimpan apabila pengguna segera menutup layar.
* **Contoh situasi *in-memory* cukup:** Menyimpan kata kunci pencarian sementara (*search filter*) atau status tab aktif pada halaman katalog.
* **Contoh situasi persistensi mutlak diperlukan:** Menyimpan riwayat pengajuan surat mahasiswa atau draf formulir pengajuan agar tidak hilang ketika aplikasi ditutup atau perangkat mengalami *restart*.

---

## Soal 10 — Integrasi Konsep Lintas Pertemuan (CPMK-1 s.d. CPMK-3)

1. **Arsitektur:**
   Aplikasi mobile Flutter bertindak sebagai lapisan presentasi (*client*) di perangkat mahasiswa yang menyimpan sementara daftar riwayat peminjaman secara lokal (state & cache lokal agar responsif dan tetap terbaca saat offline), lalu berkomunikasi melalui protokol HTTP/REST API dengan backend Sistem Informasi Perpustakaan yang terhubung ke basis data pusat untuk memvalidasi stok buku dan mencatat transaksi resmi.

2. **Kebutuhan & Alur:**
   * **Dua kebutuhan *Must have*:** (1) `F-01`: Mahasiswa dapat mengajukan peminjaman buku dari katalog; (2) `F-02`: Mahasiswa dapat melihat daftar riwayat dan status peminjaman buku.
   * **Alur pengguna:** Mahasiswa membuka aplikasi (Halaman Utama Katalog Buku) → memilih buku atau menekan tombol **"Pinjam Buku"** untuk berpindah ke Halaman Form Peminjaman → mengisi NIM, nama, dan tanggal pengembalian lalu menekan **"Kirim Peminjaman"** → sistem memvalidasi input → menyimpan data peminjaman ke dalam state daftar (`Create`), menampilkan notifikasi `SnackBar`, dan kembali ke halaman riwayat untuk menampilkan buku yang baru dipinjam (`Read`).

3. **Struktur Komponen:**
   * **Halaman Katalog & Riwayat (`StatefulWidget`):** Menggunakan `Scaffold`, `AppBar`, `Column`, `Expanded`, `ListView.builder` (berisi `Card` + `ListTile` + `Chip` status), serta `FloatingActionButton.extended` untuk menuju form.
   * **Halaman Form Peminjaman (`StatefulWidget`):** Menggunakan `Scaffold`, `AppBar`, `Form` (`GlobalKey<FormState>`), `TextFormField` dengan validator, dan `FilledButton` untuk submit.
   * **Navigasi:** Dikelola menggunakan peta route bernama pada `MaterialApp` (`'/'` untuk katalog/riwayat, `'/pinjam'` untuk form peminjaman) dengan `Navigator.pushNamed(context, '/pinjam')` untuk maju dan `Navigator.pop(context)` setelah form valid dikirim.

4. **Data & State:**
   * **Definisi model data `Buku`:**
     ```dart
     class Buku {
       const Buku({
         required this.id,
         required this.judul,
         required this.penulis,
         required this.statusPinjam,
       });

       final String id;
       final String judul;
       final String penulis;
       final String statusPinjam;
     }
     ```
   * **Pengelolaan Create dan Read dalam state:** Daftar peminjaman disimpan dalam variabel state `final List<Buku> _daftarPinjaman = [];` di dalam kelas `State`. Pada operasi **Create**, objek `Buku` baru hasil input form ditambahkan menggunakan `setState(() { _daftarPinjaman.add(bukuBaru); });`. Pada operasi **Read**, method `build()` merender `ListView.builder` yang membaca `_daftarPinjaman.length` dan `_daftarPinjaman[index]` sehingga setiap kali `setState` dipanggil, tampilan riwayat langsung diperbarui.
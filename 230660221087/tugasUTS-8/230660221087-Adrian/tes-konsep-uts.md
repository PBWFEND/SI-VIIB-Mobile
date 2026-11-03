# Tes Konsep UTS — Adrian Nugraha 230660221087

## Soal 1 — Konsep Aplikasi Bergerak dalam SI
1. **Karakteristik**: Mobilitas dan Fleksibilitas Tinggi (Konteks Bergerak).
   **Contoh penerapan**: Mahasiswa dapat mengajukan surat keterangan dari mana saja (di kantin, kos, atau saat magang) tanpa harus terikat pada jam buka loket atau duduk di depan PC desktop kampus.
2. **Karakteristik**: Pemanfaatan Fitur Perangkat Keras (*Hardware Integration*).
   **Contoh penerapan**: Jika pengajuan surat membutuhkan bukti dokumen asli, mahasiswa dapat langsung menggunakan kamera ponsel untuk memfoto dan mengunggah dokumen tersebut, sesuatu yang merepotkan jika menggunakan web desktop.
3. **Karakteristik**: Personalisasi dan Notifikasi *Push*.
   **Contoh penerapan**: Aplikasi dapat mengirimkan notifikasi *push* (pemberitahuan langsung di layar ponsel) ketika surat keterangan mahasiswa tersebut telah selesai dicetak dan siap diambil, mempercepat siklus informasi.

## Soal 2 — Dasar Pemrograman Dart
- `List<String> daftarSurat = []`: Mendeklarasikan sebuah variabel bertipe *List* (kumpulan data) yang hanya boleh berisi teks (`String`), diinisialisasi sebagai daftar kosong.
- Parameter `String jenis`: Variabel lokal yang diterima oleh fungsi `tambahSurat` sebagai *input*, merepresentasikan nama atau jenis surat yang ingin ditambahkan.
- `jenis.isEmpty`: Properti (metode bantuan) pada tipe `String` di Dart yang mengevaluasi apakah teks tersebut kosong (tidak memiliki karakter).
- `return` pada kondisi *error*: Menghentikan eksekusi fungsi `tambahSurat` saat itu juga (keluar dari fungsi) sehingga kode penambahan surat di baris bawahnya tidak dijalankan jika teks kosong.
- `daftarSurat.add(jenis)`: Memasukkan (menambahkan) nilai *string* `jenis` ke bagian paling akhir dari *List* `daftarSurat`.
- Perulangan `for`: Mengiterasi setiap elemen di dalam `daftarSurat` berdasarkan panjang datanya, mulai dari indeks 0, untuk mencetak seluruh isi daftar ke layar.

**Kesalahan umum bila validasi `isEmpty` dihapus**:
Mahasiswa bisa secara tidak sengaja mengirimkan spasi atau teks kosong (tidak mengetik apa-apa) ke dalam form, yang mengakibatkan memori `daftarSurat` dipenuhi oleh data sampah (surat tanpa nama/kosong), yang pada akhirnya merusak integritas data sistem informasi.

## Soal 3 — Struktur Flutter dan Widget
- `MaterialApp`: Widget tingkat akar (*root*) yang membungkus seluruh aplikasi, menyediakan konfigurasi utama seperti tema, navigasi (routes), dan material desain standar.
- `Scaffold`: Kanvas dasar untuk satu layar penuh yang mengelola tata letak struktural (*layout*) tingkat tinggi, menyediakan slot khusus untuk *AppBar*, *body*, dan *FloatingActionButton*.
- `AppBar`: Bilah navigasi/judul yang berada di bagian paling atas layar `Scaffold` untuk memberikan konteks di halaman mana pengguna berada.
- `Column`: Widget tata letak (*layout*) yang menyusun anak-anaknya (*children*) secara vertikal dari atas ke bawah.
- `Text`: Widget paling dasar untuk merender sepotong teks statis atau dinamis di layar dengan gaya tertentu.
- `ListView.builder`: Widget penggulir (*scrollable*) efisien yang merender daftar item panjang secara dinamis (*on-demand*) hanya ketika item tersebut masuk ke dalam area pandang layar.

**Masalah bila `ListView.builder` di dalam `Column` tanpa `Expanded`**:
**Penyebab**: `Column` memberikan tinggi ruang tak terbatas (unconstrained height) secara vertikal kepada anak-anaknya. Namun, `ListView` juga mencoba mengambil ruang setinggi mungkin untuk digulir (infinite height). Pertemuan dua ruang tak terbatas ini menyebabkan *error* "*RenderFlex overflowed*" atau "*Vertical viewport was given unbounded height*".
**Perbaikan**: Bungkus `ListView.builder` dengan widget `Expanded` agar ia mematuhi dan mengambil sisa ruang pasti (terbatas) yang disediakan oleh tinggi layar, alih-alih mencoba melar hingga tak terbatas.

## Soal 4 — Analisis Kebutuhan dan User Flow
Klasifikasi dan prioritas:

| No. | Permintaan | Fungsional/Nonfungsional | Prioritas MoSCoW | Alasan |
|:---:|:-----------|:-------------------------|:----------------:|:-------|
| 1   | "Saya ingin mengajukan surat keterangan aktif kuliah." | Fungsional | Must | Merupakan proses inti dari tujuan aplikasi ini dibuat; tanpa fitur ini aplikasi kehilangan fungsinya sama sekali. |
| 2   | "Saya ingin melihat status pengajuan saya." | Fungsional | Must | Memberikan visibilitas kepada mahasiswa apakah surat ditolak/diproses/selesai, menekan angka pertanyaan berulang ke tata usaha. |
| 3   | "Saya ingin menerima notifikasi saat surat siap diambil." | Nonfungsional | Should | Fitur ini sangat meningkatkan kenyamanan UX, namun sistem masih bisa berjalan secara manual (mahasiswa proaktif mengecek via fitur nomor 2) jika waktu pengembangan terbatas. |

**User flow untuk kebutuhan Must (Mengajukan Surat)**:
1. Mulai: Pengguna membuka aplikasi.
2. Proses: Tampil Halaman Utama (Daftar Pengajuan Surat).
3. Proses: Pengguna menekan tombol "Ajukan Surat Baru".
4. Proses: Aplikasi menampilkan Halaman Form Pengajuan.
5. Keputusan: Apakah data diisi dengan valid (tidak kosong)?
6. Cabang 'Tidak': Tampil pesan *error* "Wajib diisi" di bawah kolom *input*, kembali ke langkah 4.
7. Cabang 'Ya' (Selesai): Data tersimpan, *SnackBar* "Berhasil" muncul, kembali ke Halaman Utama.

## Soal 5 — UI/UX Mobile
1. **Prinsip**: Hierarki Visual
   **Keputusan desain**: Nama surat dibuat menggunakan tipe teks `titleMedium` yang dicetak tebal (bold), sedangkan status pengajuan menggunakan teks reguler dengan warna lebih redup.
   **Alasan**: Memandu mata pengguna saat melakukan penelusuran (*scanning*) cepat pada 20 daftar untuk fokus pada judul surat terlebih dahulu, mengingat durasi pemakaian yang singkat.
2. **Prinsip**: Target Sentuh Memadai
   **Keputusan desain**: Tombol "Ajukan" tidak dibuat sebagai tautan *hyperlink* teks berukuran 12pt, melainkan dibentuk menggunakan `FilledButton` atau diwadahi dalam sebuah `Card` besar minimal ukuran 48x48 dp.
   **Alasan**: Jari pengguna tebal (sindrom *fat finger*). Target sentuh yang kecil akan membuat mereka frustrasi karena salah memencet item daftar yang lain.
3. **Prinsip**: Keterbacaan dan Kontras (*Feedback* Status)
   **Keputusan desain**: Status surat dibuat menggunakan widget `Chip` dengan warna latar belakang (*ternary*): hijau untuk "Selesai", oranye untuk "Diproses".
   **Alasan**: Pengguna tidak perlu membaca teks kecil untuk mengetahui status. Warna akan memberi tahu (*feedback*) status dengan sekali lirik dari kejauhan, sangat berguna untuk penggunaan *mobile* di sela-sela aktivitas.

## Soal 6 — Navigasi dan Interaksi
Metode navigasi dan kapan digunakan:
- `push`: Menambahkan halaman baru (route anonim) ke puncak tumpukan Navigator. Cocok digunakan pada aplikasi kecil yang halamannya sedikit, di mana pendaftaran route statis tidak terlalu krusial.
- `pushNamed`: Membuka halaman berdasarkan label rute (misal `'/form'`) yang terpusat di `MaterialApp`. Paling cocok digunakan di aplikasi SI agar alur dan peta halamannya terstruktur rapi.
- `pop`: Menyingkirkan (*destroy*) halaman yang sedang aktif saat ini dari tumpukan sehingga layar sebelumnya muncul kembali. Digunakan pada aksi kembali (tombol *back*) atau usai proses submit Form berhasil.

**Pengiriman data jenis surat ke halaman form**:
Data tidak diubah, melainkan dikirim menggunakan parameter `arguments` ketika fungsi `Navigator.pushNamed(context, '/detail', arguments: dataSurat)` dipanggil dari *ListView*. Halaman tujuan kemudian akan menangkapnya menggunakan `ModalRoute.of(context)?.settings.arguments` setelah melakukan pengecekan tipe `is`.

**Feedback setelah form dikirim**:
Aplikasi tidak boleh membisu. Begitu pengajuan selesai divalidasi, ia memanggil `ScaffoldMessenger.of(context).showSnackBar()` di bagian bawah layar selama beberapa detik untuk memberikan konfirmasi keberhasilan aksi pengguna, lalu memanggil `pop()` agar pengguna tidak melakukan pengiriman ganda.

## Soal 7 — Model Data dan State
**Mengapa setiap field bersifat final**: Memastikan *immutability* (kekekalan) data. Objek yang sudah dibuat tidak bisa diubah langsung di memori, mencegah perubahan status secara tidak sengaja oleh kode yang bocor.
**Mengapa id wajib ada**: `id` adalah satu-satunya kunci identifikasi unik (biasanya cap waktu *milliseconds*) yang menjamin agar saat operasi *Update* atau *Delete* dilakukan di memori, data yang dihapus benar-benar tepat sasaran, terlepas dari di mana posisinya berada di daftar.

**Perbedaan StatelessWidget dan StatefulWidget**:
`StatelessWidget` adalah struktur layar mati/statis yang tampilannya murni bergantung pada konfigurasi awal dan tidak bisa bereaksi terhadap perubahan data (*state*) secara mandiri. Sementara `StatefulWidget` memiliki siklus hidup (seperti *dispose*) dan dapat menggambar ulang tampilan layarnya (melalui `setState`) setiap kali terjadi perubahan data memori.
**Halaman daftar menggunakan**: `StatefulWidget`.
**Alasan**: Halaman daftar perlu bereaksi saat mahasiswa baru saja menambah pengajuan dari halaman form (*Create*), membatalkan surat (*Delete*), atau mengubah status surat. Semua operasi CRUD ini mengubah isi *List*, dan tampilan `ListView` harus dirender ulang untuk menyesuaikan *state* terbaru.

**Fungsi setState**:
Fungsi pemicu untuk memberi tahu Flutter bahwa sebuah *state* atau variabel internal telah diubah nilainya, sehingga perintah `build` ulang (*re-render*) harus segera dijalankan untuk memperbarui antarmuka pengguna.
**Apa yang terjadi bila data ditambah tanpa setState**:
Data di memori RAM (dalam bentuk List `daftarSurat`) sebenarnya sudah berhasil bertambah, namun UI atau antarmuka visual di layar tetap kaku menampilkan data lama. Pengguna akan berasumsi aplikasinya tidak bekerja atau *hang*.

## Soal 8 — CRUD Lokal
| Operasi | Method List / mekanisme |
|:--------|:------------------------|
| Create  | Menambahkan entri baru menggunakan `_daftar.add(objekBaru)`. |
| Read    | Merender UI dengan `ListView.builder` yang dikombinasikan dengan membaca ukuran (`itemCount: _daftar.length`). |
| Update  | Menggunakan kombinasi `indexWhere` untuk menemukan posisinya, lalu mengganti objek tersebut `_daftar[index] = objekBaru`. |
| Delete  | Menghapus elemen berdasarkan ID dari memori menggunakan `_daftar.removeWhere((item) => item.id == targetId)`. |

**Mengapa id digunakan sebagai kunci update dan delete**: 
ID merupakan pengenal unik murni yang menempel pada data tersebut, terlepas dari lokasi atau susunan indeks (urutan) datanya.
**Konsekuensi bila index digunakan sebagai kunci**:
Jika index `1` dihapus, maka sisa elemen di bawahnya (indeks 2, 3) akan bergeser naik. Jika pada saat bersamaan ada perintah pembaruan atau penghapusan lain yang menargetkan indeks `2`, ia berpotensi mengenai data yang salah (salah sasaran), sehingga menyebabkan kekacauan integritas daftar.

## Soal 9 — Persistensi Data Lokal
**Perbedaan in-memory dan persistensi**:
Penyimpanan *in-memory* (RAM) sangat cepat namun sifatnya sementara (volatile); datanya lenyap begitu aplikasi di-*close* (dimatikan) atau di-kill dari latar belakang. Persistensi (*shared_preferences* atau database SQL) menulis data ke memori permanen (*storage*/Harddisk), sehingga ketika aplikasi dibuka kembali keesokan harinya, riwayat pengajuan surat masih ada.

**Mengapa operasi shared_preferences asinkron (Future)**:
Menulis atau membaca dari penyimpanan fisik (*storage/disk*) memakan waktu proses (delay) yang jauh lebih lambat ketimbang baca-tulis RAM, sehingga perlu menggunakan `Future` (asinkron) agar layar tidak *freeze* atau hang menunggu proses penulisan selesai.
**Apa yang terjadi bila await diabaikan**:
Aplikasi akan berasumsi penyimpanan telah tuntas padahal proses penulisan ke disk masih berjalan di *background*. Jika pengguna segera menutup aplikasi sesaat setelah menekan tombol simpan tanpa `await`, data tersebut akan rusak atau hilang karena proses penyimpanannya terputus di tengah jalan.

**Contoh situasi in-memory sudah cukup**:
Penyimpanan sementara parameter pencarian filter (*search bar*), data hasil kalkulasi keranjang sementara sebelum di-*checkout*, atau navigasi tumpukan *route* layar, yang memang tidak masalah jika harus diulang dari awal saat aplikasi ditutup.
**Contoh situasi persistensi mutlak diperlukan**:
Menyimpan token *login*/autentikasi pengguna, pengaturan preferensi tema warna (gelap/terang) aplikasi, atau fitur *offline mode* yang membiarkan pegawai puskesmas melihat data daftar pasien yang sudah tersimpan meski tidak ada sinyal internet.

## Soal 10 — Integrasi Konsep Lintas Pertemuan
1. **Arsitektur**:
   Aplikasi mobile berfungsi sebagai *Client Interface* utama (UI/UX). Data peminjaman awalnya disimpan di penyimpanan lokal (*shared_preferences*) agar mahasiswa dapat melihat buku yang dipinjam meski sedang *offline*. Nanti (pada modul API), data dari aplikasi mobile akan disinkronkan (*push*) ke Backend Sistem Informasi melalui komunikasi REST API, sehingga admin web bisa memantau peminjaman secara terpusat.
2. **Kebutuhan & Alur**:
   - Dua kebutuhan Must have: Mampu melihat Daftar Buku Tersedia (F-01) dan Mampu Mengajukan Form Pinjam Buku (F-02).
   - Alur pengguna: Buka aplikasi -> Tampil Halaman Katalog (Read) -> Tap buku -> Tampil Detail Buku -> Tekan "Pinjam" -> Tampil Form Peminjaman (Create) -> Validasi input lama pinjam -> Sukses (*SnackBar*) -> Kembali ke katalog.
3. **Struktur Komponen**:
   - Halaman Katalog: `Scaffold` membungkus `ListView.builder` yang merender objek buku dengan `Card`.
   - Form Peminjaman: `Scaffold` membungkus form input menggunakan `TextFormField` (dengan *controller*), dibungkus `GlobalKey<FormState>`.
   - Navigasi: Disusun melalui `routes:` pada `MaterialApp`. Dari Katalog ke Form dipanggil menggunakan `Navigator.pushNamed(context, '/pinjam')`, dan dari form kembali ke katalog menggunakan `Navigator.pop(context)`.
4. **Data & State**:
   - Definisi Model: `DataBuku(final String id, final String judulBuku, final String status, final int lamaPinjam)`.
   - Operasi *Read* dikelola dengan `List<DataBuku>` di dalam `StatefulWidget` Halaman Katalog. Jika ada aksi *Create* (Peminjaman berhasil), form akan di-*pop* mengirim argumen model buku. Di halaman katalog, `setState()` dipanggil yang menyisipkan `DataBuku` tersebut ke daftar riwayat, yang memicu `ListView` untuk membangun ulang UI dan merender riwayat peminjaman terbaru ke layar.

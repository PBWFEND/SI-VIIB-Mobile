# Dokumen Analisis Fitur Perangkat — FasKampus

## 1. Identitas Fitur

| Bagian | Keterangan |
|---|---|
| Nama aplikasi | FasKampus |
| Nama fitur | Pemilihan Dokumen Lampiran |
| Fitur perangkat | File Picker |
| Package | `file_picker` |
| Bahasa pemrograman | Dart |
| Framework | Flutter |
| Platform target | Android |

## 2. Latar Belakang Pemilihan Fitur

FasKampus merupakan aplikasi untuk membantu organisasi mahasiswa dalam mengajukan peminjaman fasilitas kampus, seperti aula, ruang kelas, laboratorium, dan perlengkapan kegiatan.

Dalam proses pengajuan, pengguna perlu menyiapkan dokumen pendukung berupa surat izin atau proposal kegiatan. Dokumen tersebut biasanya sudah tersedia dalam penyimpanan perangkat pengguna.

Oleh karena itu, fitur pemilihan dokumen dari perangkat dipilih agar pengguna dapat mengambil dokumen yang sudah tersedia tanpa harus membuat dokumen baru melalui aplikasi.

Fitur ini lebih sesuai dengan kebutuhan FasKampus dibandingkan fitur kamera, karena dokumen pendukung yang dibutuhkan berupa berkas yang sudah dibuat sebelumnya, bukan foto kondisi fasilitas.

## 3. Tujuan Fitur

Tujuan penerapan fitur pemilihan dokumen adalah:

1. Memudahkan pengguna memilih surat izin atau proposal kegiatan dari perangkat.
2. Membantu pengguna menyiapkan dokumen pendukung sebelum mengirim pengajuan.
3. Menampilkan informasi dokumen yang telah dipilih.
4. Mengurangi kesalahan dalam memilih dokumen dengan menampilkan nama, tipe, dan ukuran file.
5. Memberikan informasi ketika pengguna membatalkan pemilihan atau terjadi kesalahan.

## 4. Analisis Aktor

**Aktor:** Pengurus BEM, HIMA, atau UKM yang mengajukan peminjaman fasilitas kampus.

Aktivitas aktor dalam menggunakan fitur:

1. Membuka halaman pengajuan atau halaman lampiran.
2. Menekan tombol pilih dokumen.
3. Memilih surat izin atau proposal kegiatan dari perangkat.
4. Memeriksa informasi dokumen yang dipilih.
5. Melanjutkan proses pengajuan setelah dokumen sesuai.

## 5. Data Masukan dan Keluaran

### 5.1 Data Masukan

Data masukan berasal dari dokumen yang dipilih oleh pengguna melalui pemilih file pada perangkat.

Jenis dokumen yang diterima:

- PDF
- DOC
- DOCX

### 5.2 Data Keluaran

Hasil pemilihan dokumen berupa objek `PlatformFile` dari package `file_picker`.

Informasi yang dapat digunakan aplikasi antara lain:

| Data | Keterangan |
|---|---|
| `name` | Nama dokumen |
| `extension` | Ekstensi atau tipe dokumen |
| `size` | Ukuran dokumen dalam byte |
| `bytes` | Data dokumen dalam bentuk byte jika tersedia |
| `path` | Lokasi file jika tersedia pada platform |

Data keluaran tersebut digunakan untuk menampilkan informasi dokumen kepada pengguna.

## 6. Package yang Digunakan

Package yang digunakan adalah `file_picker`.

Package ini membantu aplikasi membuka pemilih file bawaan platform sehingga pengguna dapat memilih dokumen dari perangkat.

Dependency ditambahkan melalui terminal menggunakan perintah:

```bash
flutter pub add file_picker
```

Pemanggilan fitur dilakukan menggunakan metode `pickFiles()`.

Contoh penggunaan pada service:

```dart
final hasil = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['pdf', 'doc', 'docx'],
  allowMultiple: false,
  withData: true,
);
```

Hasil pemilihan dapat berupa file yang dipilih pengguna atau `null` apabila pengguna membatalkan proses pemilihan.

## 7. Analisis Permission dan Akses Perangkat

Fitur ini membutuhkan akses terhadap dokumen yang dipilih pengguna.

Pada Android, pemilihan dokumen melalui system file picker menggunakan mekanisme akses dokumen yang diberikan berdasarkan pilihan pengguna. Karena itu, aplikasi tidak boleh langsung menganggap bahwa fitur ini membutuhkan izin akses seluruh penyimpanan perangkat.

Hal-hal yang perlu diperhatikan:

1. Pengguna harus memilih dokumen melalui pemilih file.
2. Aplikasi hanya menggunakan dokumen yang dipilih untuk kebutuhan lampiran.
3. Akses file mengikuti mekanisme dan konfigurasi platform serta versi package yang digunakan.
4. Jika akses dokumen tidak tersedia atau terjadi kesalahan, aplikasi menampilkan pesan kepada pengguna.
5. Pengujian dilakukan pada perangkat Android atau emulator untuk memastikan fitur berjalan sesuai target.

Konfigurasi permission tambahan harus diperiksa berdasarkan dokumentasi versi package dan platform yang benar-benar digunakan. Tidak menambahkan permission penyimpanan secara sembarangan merupakan bagian dari penerapan akses perangkat yang sesuai kebutuhan.

## 8. Alur Kerja Fitur

Alur kerja pemilihan dokumen pada FasKampus:

1. Pengguna membuka halaman lampiran.
2. Aplikasi menampilkan tombol **Pilih Dokumen**.
3. Pengguna menekan tombol tersebut.
4. Aplikasi menampilkan pemilih dokumen perangkat.
5. Pengguna memilih dokumen dengan format yang didukung.
6. Service menerima hasil pemilihan dokumen.
7. Halaman menampilkan informasi dokumen yang dipilih.
8. Pengguna memeriksa dokumen sebelum melanjutkan proses pengajuan.

Alur apabila pengguna membatalkan pemilihan:

1. Pengguna membuka pemilih dokumen.
2. Pengguna menekan tombol kembali atau membatalkan pemilihan.
3. Pemilih dokumen mengembalikan hasil `null`.
4. Aplikasi tidak menampilkan kondisi error.
5. Dokumen sebelumnya tetap dipertahankan apabila sudah ada.

## 9. Penanganan Lifecycle dan Kondisi

Fitur harus menangani beberapa kondisi agar tidak hanya berjalan ketika pemilihan berhasil.

| Kondisi | Penjelasan | Penanganan |
|---|---|---|
| Initial | Pengguna belum memilih dokumen | Menampilkan petunjuk untuk memilih dokumen |
| Loading | Aplikasi sedang membuka pemilih dokumen | Menampilkan indikator loading |
| Success | Pengguna berhasil memilih dokumen | Menampilkan nama, tipe, dan ukuran file |
| Cancel | Pengguna membatalkan pemilihan | Mempertahankan dokumen sebelumnya |
| Akses tidak tersedia | Dokumen tidak dapat diakses | Menampilkan informasi kepada pengguna |
| Error | Terjadi kesalahan saat proses pemilihan | Menampilkan pesan dan menyediakan percobaan ulang |

Pembatalan pemilihan tidak boleh dianggap sebagai kesalahan karena pengguna memang dapat memilih untuk tidak melanjutkan proses tersebut.

## 10. Pemisahan Service dan Widget

Implementasi dibagi menjadi dua bagian utama.

### 10.1 `lampiran_service.dart`

File ini bertanggung jawab menangani proses pemilihan dokumen menggunakan package `file_picker`.

Tanggung jawabnya:

- Membuka pemilih dokumen perangkat.
- Membatasi jenis dokumen yang dapat dipilih.
- Mengembalikan hasil pemilihan berupa `PlatformFile`.
- Mengembalikan `null` apabila pengguna membatalkan pemilihan.

### 10.2 `halaman_lampiran.dart`

File ini bertanggung jawab menampilkan antarmuka fitur kepada pengguna.

Tanggung jawabnya:

- Menampilkan tombol pilih dokumen.
- Menampilkan indikator loading.
- Menampilkan informasi dokumen yang dipilih.
- Menampilkan pesan ketika terjadi kesalahan.
- Memberikan kesempatan kepada pengguna untuk mencoba kembali.

Pemisahan ini dilakukan agar kode proses pemilihan dokumen tidak bercampur dengan kode tampilan.

## 11. Hubungan Fitur dengan Proses Bisnis FasKampus

Fitur pemilihan dokumen menjadi bagian dari proses pengajuan peminjaman fasilitas kampus.

Alur proses bisnis:

```text
Pengguna membuka aplikasi
          |
          v
Memilih fasilitas kampus
          |
          v
Mengisi tanggal dan waktu
          |
          v
Mengisi tujuan kegiatan
          |
          v
Memilih surat izin/proposal
          |
          v
Memeriksa dokumen lampiran
          |
          v
Melanjutkan pengajuan
```

Dengan adanya fitur ini, pengguna dapat menyiapkan dokumen pendukung sebelum pengajuan dikirimkan.

## 12. Batasan Fitur

Implementasi fitur pada Tugas 11 memiliki beberapa batasan:

1. Fitur hanya digunakan untuk memilih satu dokumen dalam satu proses.
2. Format dokumen dibatasi pada PDF, DOC, dan DOCX.
3. Fitur belum melakukan upload dokumen ke server.
4. Fitur belum menyimpan dokumen secara permanen ke database.
5. Fitur belum melakukan pemeriksaan isi dokumen.
6. Pengujian utama ditujukan pada platform Android.

Batasan tersebut dibuat agar implementasi tetap berfokus pada kebutuhan utama Tugas 11, yaitu penggunaan fitur perangkat secara tepat.

## 13. Kesimpulan

Berdasarkan kebutuhan aplikasi FasKampus, fitur pemilihan dokumen menggunakan package `file_picker` merupakan fitur perangkat yang sesuai untuk mendukung proses pengajuan peminjaman fasilitas kampus.

Fitur ini membantu pengguna memilih surat izin atau proposal kegiatan dari perangkat, menampilkan informasi dokumen, serta menangani kondisi loading, berhasil, pembatalan, dan kesalahan.

Pemisahan antara service dan widget juga membuat kode lebih terstruktur dan memudahkan pengembangan fitur pada tahap berikutnya.
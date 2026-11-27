# Tugas 11 — Integrasi Fitur Perangkat

## FasKampus: Pemilihan Dokumen Lampiran

**Mata Kuliah:** Pemrograman Aplikasi Bergerak  
**Milestone:** M6 — Fitur Perangkat  
**CPMK:** CPMK-3  
**Fitur Perangkat:** Pemilihan dokumen dari perangkat menggunakan package `file_picker`.

## 1. Latar Belakang

FasKampus merupakan aplikasi yang digunakan untuk mengajukan peminjaman fasilitas kampus oleh organisasi mahasiswa seperti BEM, HIMA, dan UKM.

Dalam proses pengajuan peminjaman fasilitas, pemohon perlu melampirkan dokumen pendukung berupa surat izin atau proposal kegiatan. Oleh karena itu, fitur pemilihan dokumen dari perangkat diperlukan agar pengguna dapat memilih dokumen yang sudah tersedia pada perangkatnya.

Fitur ini dipilih karena memiliki hubungan langsung dengan proses bisnis aplikasi FasKampus.

## 2. Tujuan Fitur

Tujuan penerapan fitur pemilihan dokumen adalah:

1. Memudahkan pengguna memilih surat izin atau proposal kegiatan dari perangkat.
2. Menampilkan informasi dokumen yang telah dipilih.
3. Membantu proses persiapan pengajuan peminjaman fasilitas kampus.
4. Menangani kondisi ketika pengguna membatalkan pemilihan atau terjadi kesalahan.

## 3. Aktor dan Data Keluaran

| Bagian | Keterangan |
|---|---|
| Aktor | Pengurus BEM, HIMA, atau UKM |
| Tujuan | Memilih dokumen pendukung pengajuan |
| Input | Dokumen dari perangkat pengguna |
| Output | Nama file, ekstensi, ukuran, dan data file jika tersedia |
| Package | `file_picker` |
| Platform target | Android |

Format dokumen yang diterima pada implementasi ini adalah PDF, DOC, dan DOCX.

## 4. Struktur Folder

```text
tugas-11/
├── lib/
│   ├── main.dart
│   ├── halaman_lampiran.dart
│   └── services/
│       └── lampiran_service.dart
├── pubspec.yaml
├── README.md
├── dokumen-fitur-perangkat.md
├── skenario-pengujian.md
└── refleksi.md
```

## 5. Dependency

Package yang digunakan adalah `file_picker`.

Untuk menambahkan dependency, jalankan perintah berikut pada terminal di direktori project Flutter:

```bash
flutter pub add file_picker
flutter pub get
```

Perintah tersebut akan menambahkan dependency ke dalam `pubspec.yaml`.

## 6. Permission dan Platform

Fitur pemilihan dokumen menggunakan pemilih file yang disediakan oleh platform.

Pada penggunaan system file picker, akses dokumen diberikan berdasarkan file yang dipilih oleh pengguna. Kebutuhan konfigurasi dapat berbeda berdasarkan versi Android, iOS, package, dan platform yang digunakan.

Pengujian utama dilakukan pada perangkat Android fisik atau emulator. Pengujian melalui Chrome tidak menggantikan pengujian pada perangkat Android karena dukungan fitur dapat berbeda.

## 7. Alur Penggunaan Fitur

1. Pengguna membuka halaman lampiran FasKampus.
2. Pengguna menekan tombol **Pilih Dokumen**.
3. Aplikasi membuka pemilih dokumen perangkat.
4. Pengguna memilih dokumen PDF, DOC, atau DOCX.
5. Service menerima hasil pemilihan dokumen.
6. Halaman menampilkan nama, tipe, dan ukuran dokumen.
7. Jika pengguna membatalkan pemilihan, aplikasi mempertahankan dokumen sebelumnya.
8. Jika terjadi kesalahan, aplikasi menampilkan pesan dan menyediakan tombol untuk mencoba kembali.

## 8. Penanganan Kondisi

| Kondisi | Penanganan |
|---|---|
| Loading | Menampilkan indikator proses dan menonaktifkan tombol |
| Berhasil | Menampilkan informasi dokumen |
| Dibatalkan | Tidak dianggap sebagai error dan mempertahankan pilihan sebelumnya |
| Akses tidak tersedia | Menampilkan informasi kepada pengguna |
| Error | Menampilkan pesan kesalahan dan menyediakan pilihan mencoba kembali |

## 9. Pemisahan Service dan Widget

Implementasi fitur dibagi menjadi dua bagian:

- `lampiran_service.dart` bertugas menangani proses pemilihan dokumen menggunakan package `file_picker`.
- `halaman_lampiran.dart` bertugas menampilkan tombol, indikator loading, informasi dokumen, dan pesan kesalahan.

Pemisahan ini bertujuan agar proses penggunaan package tidak bercampur dengan kode tampilan aplikasi.

## 10. Batasan Implementasi

Pada Tugas 11 ini, fitur yang diterapkan berfokus pada pemilihan dokumen dan penampilan informasi file.

Fitur ini belum melakukan upload dokumen ke server, belum menyimpan dokumen secara permanen, dan belum menggabungkan dokumen dengan data pengajuan pada REST API.

Pengembangan upload dokumen dapat dilakukan pada tahap berikutnya apabila backend FasKampus sudah menyediakan endpoint untuk mengirim berkas.

## 11. Cara Menjalankan Aplikasi

Jalankan perintah berikut dari direktori project Flutter:

```bash
flutter pub get
flutter analyze
flutter run
```

Pastikan pengujian dilakukan pada perangkat Android fisik atau emulator yang mendukung fitur pemilihan dokumen.

## 12. Kesimpulan

Fitur pemilihan dokumen menggunakan `file_picker` dipilih karena mendukung kebutuhan aplikasi FasKampus, yaitu melampirkan surat izin atau proposal kegiatan dalam proses pengajuan peminjaman fasilitas kampus.

Melalui implementasi ini, aplikasi dapat menerima pilihan dokumen dari perangkat dan menampilkan informasi dokumen kepada pengguna. Penanganan loading, berhasil, pembatalan, dan error juga diterapkan agar penggunaan fitur lebih terarah.

## 13. Deklarasi Penggunaan AI

ChatGPT digunakan sebagai alat bantu dalam menyusun kerangka implementasi, dokumentasi, dan skenario pengujian. Kode dan konfigurasi tetap diperiksa, dipahami, dijalankan, serta diuji sebelum dikumpulkan.
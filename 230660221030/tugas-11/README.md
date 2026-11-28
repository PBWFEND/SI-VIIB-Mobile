
# PustakaKu – Tugas 11

## 1. Deskripsi Aplikasi

PustakaKu merupakan aplikasi perpustakaan berbasis Flutter yang digunakan untuk mengelola data buku dan peminjaman buku.

Pada Tugas 11, aplikasi dikembangkan dengan menambahkan integrasi fitur perangkat berupa pemilihan foto sampul buku melalui galeri.

## 2. Fitur yang Dikembangkan

- Memilih foto sampul buku dari galeri.
- Menampilkan foto pada katalog buku.
- Menampilkan foto pada halaman detail buku.
- Mengganti foto sampul buku.
- Menyimpan foto menggunakan IndexedDB.
- Menambahkan data buku baru.
- Menyimpan data buku menggunakan IndexedDB.

## 3. Teknologi dan Dependensi

- Flutter
- Dart
- image_picker
- sembast
- sembast_web
- IndexedDB

## 4. Target Platform

Platform pengujian: Google Chrome (Flutter Web).

Pemilihan foto dilakukan melalui file picker pada browser.

## 5. Penyimpanan Data

Aplikasi menggunakan IndexedDB melalui Sembast Web untuk menyimpan:
- Data buku.
- Foto sampul buku.

Data tersimpan pada browser yang digunakan dan dapat bertahan setelah halaman di-refresh.

## 6. Cara Menjalankan Aplikasi

1. Buka folder proyek PustakaKu.
2. Jalankan terminal pada VS Code.
3. Jalankan perintah:

   flutter pub get

4. Jalankan aplikasi:

   flutter run -d chrome

## 7. Batasan Pengujian

- Pengujian dilakukan menggunakan Google Chrome.
- Pemilihan foto bergantung pada file picker browser.
- Fitur kamera langsung tidak digunakan.
- Data IndexedDB tersimpan pada browser dan origin yang digunakan.
- Data tidak otomatis tersinkronisasi ke perangkat lain.

## 8. Hasil Pengujian

Hasil pengujian fitur dicatat dalam tabel pengujian Tugas 11.

## 9. Refleksi

Pengembangan fitur ini memberikan pengalaman dalam mengintegrasikan fitur perangkat pada aplikasi Flutter, menggunakan pemrograman asynchronous, menangani pembatalan pemilihan file, serta menyimpan data secara lokal menggunakan IndexedDB.

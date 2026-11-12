# Tugas 9 – Integrasi REST API SIPORA

## 1. Identitas

- **Nama:** Intan Kartika
- **NIM:** 230660221018
- **Mata Kuliah:** Pemrograman Aplikasi Bergerak
- **Nama Aplikasi:** SIPORA (Sistem Informasi Pengajuan Surat Observasi dan Riset Akademik)

## 2. Deskripsi Aplikasi

SIPORA merupakan aplikasi mobile yang dikembangkan untuk membantu mahasiswa mengajukan surat observasi dan riset akademik. Pada Tugas 9, aplikasi diintegrasikan dengan RESTful API Dev untuk mengambil dan mengirim data pengajuan menggunakan metode HTTP GET dan POST.

## 3. Fitur yang Diimplementasikan

- Mengambil daftar pengajuan melalui HTTP GET.
- Mengirim pengajuan baru melalui HTTP POST.
- Mengolah respons JSON menggunakan model `PengajuanApi`.
- Menampilkan kondisi loading, success, dan error.
- Menyediakan tombol untuk mencoba kembali ketika permintaan gagal.
- Menonaktifkan tombol submit selama proses pengiriman berlangsung.

## 4. Teknologi yang Digunakan

- Flutter dan Dart.
- RESTful API Dev.
- HTTP dan JSON.
- Android Studio dan Google Chrome.

## 5. Cara Menjalankan Aplikasi

Jalankan aplikasi melalui terminal menggunakan perintah berikut:

```powershell
flutter run -d chrome -t lib/main_tugas9.dart '--dart-define=SIPORA_API_KEY=API_KEY_SAYA'
```

Ganti `API_KEY_SAYA` dengan API Key yang dimiliki. API Key tidak dicantumkan secara langsung dalam source code maupun repositori.

## 6. Dokumentasi Pengujian

Hasil pengujian aplikasi dilampirkan dalam bentuk screenshot:

- `screenshot-loading.png` – Tampilan saat proses pengambilan data.
- `screenshot-sukses.png` – Tampilan ketika data berhasil ditampilkan.
- `screenshot-error.png` – Tampilan ketika terjadi kesalahan koneksi.

## 7. Refleksi

Melalui tugas ini, saya memahami cara menghubungkan aplikasi Flutter dengan REST API menggunakan metode GET dan POST. Saya juga mempelajari proses pengolahan data JSON serta penanganan kondisi loading, success, dan error. Pengalaman ini membantu saya memahami pentingnya integrasi API dalam pengembangan aplikasi yang dinamis dan terhubung dengan server.
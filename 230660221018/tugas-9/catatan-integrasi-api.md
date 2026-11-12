# Catatan Integrasi API SIPORA

## 1. Layanan API

Aplikasi SIPORA menggunakan **RESTful API Dev** sebagai layanan penyimpanan data pengajuan surat. Integrasi dilakukan melalui protokol HTTP dengan format pertukaran data JSON.

- **Nama koleksi:** `pengajuan-sipora`
- **Base URL:** `https://api.restful-api.dev/collections/pengajuan-sipora/objects`
- **Autentikasi:** API Key melalui header `x-api-key`.
- **Format data:** JSON.

## 2. Endpoint yang Digunakan

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/collections/pengajuan-sipora/objects` | Mengambil daftar pengajuan surat. |
| POST | `/collections/pengajuan-sipora/objects` | Mengirim data pengajuan surat baru. |

Permintaan POST menggunakan header `Content-Type: application/json` dan mengirimkan data dengan struktur `name` dan `data`.

## 3. Alur Integrasi

1. Halaman API SIPORA dibuka dan menjalankan proses GET untuk mengambil data pengajuan.
2. Data respons JSON diproses menggunakan model `PengajuanApi` melalui fungsi `fromJson()`.
3. Data yang berhasil diambil ditampilkan dalam daftar menggunakan `ListView.builder`.
4. Pengguna dapat membuka formulir untuk membuat pengajuan baru.
5. Data formulir dikonversi menjadi objek `PengajuanApi`, kemudian dikirim melalui metode POST.
6. Jika pengiriman berhasil, data baru ditampilkan pada daftar pengajuan.

## 4. Penanganan Kondisi dan Kesalahan

Integrasi API dilengkapi dengan beberapa kondisi berikut:

- **Loading:** menampilkan indikator selama proses pengambilan data berlangsung.
- **Success:** menampilkan daftar pengajuan yang berhasil diterima dari server.
- **Error:** menampilkan informasi ketika permintaan API gagal.
- **Retry:** menyediakan tombol untuk mengulangi proses pengambilan data.
- **Submit:** tombol pengiriman dinonaktifkan sementara proses POST berlangsung untuk mencegah pengiriman berulang.

Penanganan kesalahan menggunakan `try-catch`, pemeriksaan HTTP status code, dan timeout pada proses komunikasi dengan server.

## 5. Keamanan dan Pengujian

API Key disimpan melalui konfigurasi `String.fromEnvironment('SIPORA_API_KEY')` dan diberikan saat aplikasi dijalankan menggunakan `--dart-define`. API Key tidak dicantumkan secara langsung dalam kode maupun dokumentasi yang diunggah ke repositori publik.

Pengujian integrasi mencakup pengambilan data (GET), pengiriman data (POST), tampilan loading, serta penanganan kesalahan koneksi. Hasil pengujian didokumentasikan melalui tiga screenshot, yaitu `screenshot-loading.png`, `screenshot-sukses.png`, dan `screenshot-error.png`.

**Catatan:** Penggunaan `--dart-define` ditujukan untuk kebutuhan pengujian tugas. Untuk aplikasi produksi, API Key perlu dikelola melalui mekanisme backend yang lebih aman.
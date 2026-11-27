# Catatan Integrasi API — Tugas 9

## 1. Endpoint yang Digunakan

| Operasi | Metode HTTP | URL Endpoint | Payload Request |
|:--------|:-----------|:-------------|:----------------|
| Ambil daftar | GET | https://jsonplaceholder.typicode.com/posts | — |
| Kirim data baru | POST | https://jsonplaceholder.typicode.com/posts | {"title": "Minggu Opini", "body": "Konten dalam tahap editing akhir", "userId": 4, "divisi": "DIVISI REDAKSI", "tanggal": "25 November 2026", "status": "Progres"}` |

## 2. Struktur Model Data

| Field | Tipe Dart | Key JSON | Sumber Nilai |
|:------|:----------|:---------|:-------------|
| `id` | `String` | `"id"` | Server (dikonversi dari `id` JSON server menjadi `String`) |
| `judul` | `String` | `"title"` | Server (saat `GET`) / Input Form Pengguna (saat `POST`) |
| `divisi` | `String` | `"divisi"` / `"userId"` | Mapping dari `"userId"` server (saat `GET`) / Pilihan Dropdown Form (saat `POST`) |
| `tanggal` | `String` | `"tanggal"` | Nilai default `"20 November 2026"` (saat `GET`) / Input Form Pengguna (saat `POST`) |
| `status` | `String` | `"status"` / `"id"` | Mapping dari `"id"` server (`Tayang`, `Progres`, `Terkendala`) / Pilihan Dropdown Form (saat `POST`) |
| `catatan` | `String` | `"body"` | Server (saat `GET`) / Input Form Pengguna (saat `POST`) |

## 3. Penanganan Error
1. **Strategi `try-catch` dan Validasi Status HTTP (`lib/service-api.dart`):**
   Seluruh permintaan jaringan (`http.get` dan `http.post`) dibungkus di dalam blok `try-catch` untuk menangkap gangguan koneksi internet maupun kesalahan server. Pada operasi `GET`, kode status selain `200 OK` langsung dilempar sebagai `Exception` dengan pesan spesifik (misalnya HTTP `404` menampilkan *"Endpoint jadwal tidak ditemukan di server (HTTP 404)"*). Pada operasi `POST`, aplikasi memeriksa kode status `201 Created`; jika berbeda, sistem melempar `Exception` gagal mengirim data beserta kode statusnya.

2. **Batas Waktu Tunggu (*Timeout*):**
   Setiap permintaan HTTP dilengkapi `.timeout(const Duration(seconds: 10))`. Apabila server tidak memberikan respons dalam waktu 10 detik, blok `on TimeoutException` akan menangkapnya dan mengirimkan pesan informatif bahwa waktu tunggu habis agar pengguna memeriksa koneksi internetnya.

3. **Pesan Error dan Pemulihan di Antarmuka Pengguna (`lib/halaman-api.dart`):**
   * **Saat gagal memuat daftar (`GET`):** State `_pesanError` diisi dengan keterangan kesalahan dan `_sedangMemuat` diubah menjadi `false`. Layar menampilkan ikon awan terputus, judul **"Gagal Memuat Jadwal"**, detail penyebab error, serta tombol **"Coba Lagi"** yang memicu pemanggilan ulang `_muatDataDariApi()`. Tombol tambah jadwal (`+`) juga disembunyikan sementara selama kondisi error.
   * **Saat gagal mengirim jadwal baru (`POST`):** State `_sedangMengirim` dikembalikan ke `false` agar tombol **"Kirim Jadwal"** kembali aktif, dan pengguna mendapatkan notifikasi `SnackBar` merah berisi pesan kesalahan tanpa kehilangan teks yang sudah diketik di form.
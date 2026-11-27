# Tugas 10 — Integrasi Data dan Proses Bisnis

## FasKampus

### Identitas
- **Nama:** Muhammad Andre Nugraha
- **NIM:** 230660221113
- **Program Studi:** Sistem Informasi
- **Fakultas:** Teknologi Informasi
- **Universitas:** Universitas Sebelas April
- **Mata Kuliah:** Pemrograman Aplikasi Bergerak
- **Kelas:** SI-VIIB
- **Dosen Pengampu:** Bapak Agun Guntara

## 1. Deskripsi Aplikasi

FasKampus merupakan aplikasi yang dibuat untuk membantu mahasiswa dan organisasi kampus dalam memperoleh informasi serta mengajukan peminjaman fasilitas kampus.

Pada Tugas 10, aplikasi dikembangkan dengan menambahkan fitur integrasi data dari beberapa endpoint API. Data pengguna dan data pengajuan diambil dari API, kemudian digabungkan agar informasi pengajuan dapat ditampilkan bersama identitas pemohonnya.

## 2. Tujuan Pengerjaan

Tujuan pengerjaan Tugas 10 adalah:

1. Mengambil data dari lebih dari satu endpoint API.
2. Membuat model Dart untuk mengolah data JSON.
3. Menggabungkan data berdasarkan identifier.
4. Memisahkan proses pengambilan data dari tampilan aplikasi.
5. Menampilkan kondisi loading, data, empty, dan error.
6. Menyediakan fitur untuk mencoba kembali ketika terjadi kesalahan.

## 3. Teknologi yang Digunakan

- Flutter
- Dart
- Package `http`
- JSONPlaceholder sebagai API simulasi
- `Future` dan `async/await`
- `Future.wait`

## 4. Endpoint API

Aplikasi menggunakan dua endpoint dari JSONPlaceholder.

| Endpoint | Metode | Fungsi |
|---|---|---|
| `/users` | GET | Mengambil data pengguna atau pemohon |
| `/posts` | GET | Mengambil data pengajuan simulasi |

Base URL:

`https://jsonplaceholder.typicode.com`

## 5. Pemetaan Data JSON ke Model Dart

### A. Data Pengguna

Endpoint: `GET /users`

Model: `DataPengguna`

| Field JSON | Properti Dart | Keterangan |
|---|---|---|
| `id` | `id` | ID pengguna |
| `name` | `nama` | Nama pengguna |
| `email` | `email` | Email pengguna |
| `username` | `username` | Nama akun pengguna |

### B. Data Pengajuan

Endpoint: `GET /posts`

Model: `DataPengajuan`

| Field JSON | Properti Dart | Keterangan |
|---|---|---|
| `id` | `id` | ID pengajuan simulasi |
| `userId` | `userId` | ID pengguna yang mengajukan |
| `title` | `judul` | Judul pengajuan |
| `body` | `deskripsi` | Deskripsi pengajuan |
| Tidak tersedia | `status` | Menggunakan nilai default `menunggu` |

## 6. Proses Penggabungan Data

Penggabungan data dilakukan menggunakan identifier `userId` dari data pengajuan dan `id` dari data pengguna.

Langkah penggabungan:

1. Aplikasi mengambil data pengguna dari endpoint `/users`.
2. Aplikasi mengambil data pengajuan dari endpoint `/posts`.
3. Kedua request dijalankan menggunakan `Future.wait` karena tidak saling bergantung.
4. Data pengguna disusun dalam pencarian berdasarkan ID.
5. Setiap data pengajuan dicocokkan menggunakan `userId`.
6. Data yang cocok digabungkan menjadi objek `DataPengajuanRingkas`.
7. Hasil integrasi dikirimkan ke halaman untuk ditampilkan.

Jika pengguna tidak ditemukan, data pengajuan tersebut dilewati agar tidak menampilkan informasi pemohon yang tidak cocok.

## 7. Struktur File

```text
lib/
├── main.dart
├── halaman_utama.dart
├── halaman_api.dart
├── halaman_integrasi.dart
├── form_interaksi.dart
├── models/
│   ├── data_pengguna.dart
│   ├── data_pengajuan.dart
│   └── data_pengajuan_ringkas.dart
└── services/
    └── integrasi_service.dart
```

File dokumentasi Tugas 10:

```text
tugas-10/
├── README.md
├── diagram-integrasi.md
└── refleksi.md
```

## 8. Pembagian Tanggung Jawab File

| File | Fungsi |
|---|---|
| `data_pengguna.dart` | Model data pengguna |
| `data_pengajuan.dart` | Model data pengajuan |
| `data_pengajuan_ringkas.dart` | Model hasil penggabungan |
| `integrasi_service.dart` | Mengambil, mengolah, dan menggabungkan data API |
| `halaman_integrasi.dart` | Menampilkan hasil integrasi dan kondisi proses |
| `main.dart` | Mengatur aplikasi dan navigasi |
| `halaman_utama.dart` | Menampilkan halaman utama FasKampus |

## 9. Kondisi Tampilan Aplikasi

Halaman integrasi memiliki empat kondisi utama:

- **Loading:** Menampilkan indikator proses ketika data sedang diambil.
- **Data:** Menampilkan daftar pengajuan beserta nama dan email pemohon.
- **Empty:** Menampilkan pesan ketika hasil integrasi tidak memiliki data.
- **Error:** Menampilkan pesan kesalahan dan tombol Coba Lagi.

Pengguna juga dapat memuat ulang data menggunakan tombol refresh atau menarik daftar ke bawah.

## 10. Cara Menjalankan Aplikasi

Pastikan Flutter sudah terpasang dan koneksi internet tersedia.

Jalankan perintah berikut dari direktori proyek Flutter:

```bash
flutter pub get
flutter analyze
flutter run -d chrome
```

Untuk membuka halaman integrasi, jalankan aplikasi kemudian pilih ikon Integrasi Data pada AppBar halaman utama FasKampus.

## 11. Keterbatasan API

API JSONPlaceholder digunakan sebagai simulasi karena tidak menyediakan backend khusus peminjaman fasilitas kampus.

Beberapa keterbatasannya:

1. Endpoint `/posts` bukan data pengajuan peminjaman fasilitas yang sebenarnya.
2. Data pengguna dan pengajuan merupakan data contoh.
3. Field `status` tidak tersedia pada response `/posts`, sehingga aplikasi memberikan nilai default `menunggu`.
4. Data yang ditampilkan belum tersimpan sebagai pengajuan nyata di server kampus.
5. Aplikasi belum menggunakan autentikasi pengguna.

## 12. Kesimpulan

Melalui Tugas 10 ini, aplikasi FasKampus sudah dikembangkan dengan konsep integrasi data dari dua endpoint API. Data pengguna dan data pengajuan digabungkan berdasarkan identifier sehingga informasi dapat ditampilkan dalam satu halaman.

Pengerjaan ini membantu memahami penggunaan beberapa request asynchronous, parsing JSON, pemisahan service dan tampilan, serta penanganan kondisi data dalam aplikasi Flutter.

## 13. Penggunaan AI

Dalam pengerjaan tugas ini, AI digunakan sebagai alat bantu untuk memahami materi, menyusun model data, membantu pembuatan service integrasi, memperbaiki kode, dan menyusun dokumentasi. Kode tetap diperiksa dan diuji kembali pada proyek Flutter.
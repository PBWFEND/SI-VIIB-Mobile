# Laporan Progress Project UTS (Milestone M4)

| | |
|:--|:--|
| **Nama** | Annisa Nur Sabariyah |
| **NIM** | 230660221085 |
| **Kelas** | SI-VIIB |
| **Domain SI** | Sistem Informasi Peminjaman Buku Perpustakaan |
| **Judul Aplikasi** | Aplikasi Peminjaman Buku Perpustakaan (MVP Data Lokal) |
| **Tautan Repository** | [https://github.com/PBWFEND/SI-VIIB-Mobile](https://github.com/PBWFEND/SI-VIIB-Mobile) |

---

## 1. Ringkasan Eksekutif Project

Aplikasi Peminjaman Buku Perpustakaan dirancang untuk mengatasi permasalahan antrian fisik, keterlambatan pencatatan, dan ketidakjelasan status ketersediaan buku yang sering dihadapi mahasiswa dan petugas perpustakaan kampus. Melalui aplikasi ini, mahasiswa dapat melihat katalog buku, memeriksa status ketersediaan, serta mengajukan peminjaman secara langsung dari smartphone mereka.

Solusi aplikasi mobile dipilih karena memberikan fleksibilitas akses yang tinggi, mendukung interaksi sentuh yang cepat di sela-sela jadwal perkuliahan, serta memungkinkan pemberian umpan balik dan notifikasi secara langsung kepada pengguna.

---

## 2. Ketercapaian Milestone (M1 s.d. M3)

| Milestone | Deliverable | Status (Selesai / Sebagian) | Catatan / Bukti |
|:----------|:------------|:----------------------------|:----------------|
| M1: Kebutuhan | Dokumen kebutuhan + User Flow | Selesai | File `dokumen-kebutuhan.md` di folder `tugas-4/` |
| M2: UI/UX | Wireframe + Navigasi | Selesai | File `information-architecture.md`, `wiraframe.jpg` di `tugas-5/` dan `navigation-flow.md` di `tugas-6/` |
| M3: MVP Awal | Model data + CRUD lokal | Selesai | File `crud-lokal.dart` dan `model-data.md` di folder `tugas-7/` |

---

## 3. Matriks Kebutuhan ke Implementasi

| ID Kebutuhan | Deskripsi Kebutuhan | Prioritas MoSCoW | Halaman Pemenuh | Operasi Data Terkait |
|:-------------|:-------------------|:----------------:|:----------------|:---------------------|
| F-01 | Mahasiswa dapat mengajukan peminjaman buku | Must | Halaman Form Peminjaman | Create |
| F-02 | Petugas/Sistem dapat mengubah status ketersediaan buku | Must | Halaman Utama (Katalog) | Update |
| F-03 | Mahasiswa dapat melihat daftar dan status peminjaman buku | Must | Halaman Utama (Katalog) | Read |
| F-04 | Mahasiswa/Petugas dapat menghapus data peminjaman | Should | Halaman Utama (Katalog) | Delete |

---

## 4. Tangkapan Layar Aplikasi Berjalan

Tangkapan layar bukti aplikasi berjalan tersimpan di folder `tugas-7/`:

| No. | File Tangkapan Layar | Deskripsi Bukti |
|:---:|:---------------------|:----------------|
| 1 | `screenshot-daftar.png` | Halaman utama yang menampilkan daftar peminjaman data lokal (`ListView.builder`) |
| 2 | `screenshot-hapus.png` | Dialog konfirmasi hapus data (`AlertDialog`) dan feedback hapus (`SnackBar`) |

---

## 5. Kendala dan Solusi Teknis

1. **Kendala Layout Overflow (`RenderFlex overflowed`):**
   * *Masalah:* Saat menempatkan `ListView.builder` di dalam `Column` pada halaman utama, terjadi error layout overflow vertikal.
   * *Solusi:* Membungkus widget `ListView.builder` dengan widget `Expanded` agar `ListView` secara eksplisit mengambil sisa ruang kosong yang tersedia pada `Column`.

2. **Kendala Konsistensi Kunci Operasi Update dan Delete:**
   * *Masalah:* Menggunakan indeks daftar sebagai kunci penghapusan memicu kesalahan data (data mismatch) ketika posisi daftar bergeser.
   * *Solusi:* Mengimplementasikan field `id` unik berbasis timestamp (`DateTime.now().millisecondsSinceEpoch.toString()`) pada model `DataBuku` dan memanfaatkan method `indexWhere` serta `removeWhere` berdasarkan `id`.

---

## 6. Rencana Pengembangan Milestone M5 (REST API)

Pada Minggu 9–10 (Milestone M5), pengelolaan data yang saat ini bersifat *in-memory* akan diintegrasikan dengan **REST API Backend Sistem Informasi Perpustakaan**. Data buku dan peminjaman nantinya akan diambil secara asinkron dari server backend menggunakan HTTP Client (`http` package), di-parse dari format JSON ke model `DataBuku`, serta dilengkapi dengan penanganan *loading state* dan *error handling* jaringan.

---

## 7. Refleksi Pembelajaran Tengah Semester

Selama pembelajaran Minggu 1–7, saya memahami pentingnya keterhubungan antara tahap analisis kebutuhan, perancangan UI/UX, dan implementasi kode Flutter. Penyusunan model data dan manajemen state berbasis `StatefulWidget` menuntut ketelitian agar perubahan data pada state dapat langsung terefleksi secara visual di antarmuka antarmuka pengguna melalui `setState`. Tantangan terbesar dalam membangun aplikasi mobile adalah merancang alur yang ringkas serta menjaga konsistensi arsitektur data lokal sebelum dihubungkan ke backend server.

---

## 8. Deklarasi Penggunaan AI

Deklarasi penggunaan AI: Gemini — membantu merumuskan draf struktur dokumen kebutuhan, memeriksa alur logika widget Flutter, serta mengecek tata bahasa pada laporan; perbaikan kode, pengujian aplikasi, dan penulisan akhir dilakukan serta diverifikasi oleh penulis.
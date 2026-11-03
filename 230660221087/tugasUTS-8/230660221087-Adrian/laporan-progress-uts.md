# Laporan Progress Project UTS (Milestone M4)

| | |
|:--|:--|
| **Nama** | Adrian Nugraha |
| **NIM** | 230660221087 |
| **Kelas** | SI-VIIB |
| **Domain SI** | Sistem Informasi Kepegawaian Puskesmas |
| **Judul Aplikasi** | Mobile Absensi Puskesmas |
| **Tautan Repository** | [Masukkan Tautan GitHub Anda] |

---

## 1. Ringkasan Eksekutif Project
Aplikasi "Mobile Absensi Puskesmas" dirancang untuk menyelesaikan permasalahan inefisiensi pelaporan kehadiran bagi perawat dan tenaga medis yang sering berdinas luar ruangan (Puskesmas Keliling/Kunjungan Lansia). Dengan menggunakan sistem manual, data kehadiran tidak *real-time*. 
Solusi aplikasi *mobile* dipilih agar selaras dengan mobilitas perawat, memanfaatkan sensor lokasi (*GPS*) perangkat, dan memungkinkan pengiriman serta visualisasi data secara cepat (tanpa harus singgah ke komputer balai induk).

## 2. Ketercapaian Milestone (M1 s.d. M3)

| Milestone | Deliverable | Status (Selesai / Sebagian) | Catatan / Bukti |
|:----------|:------------|:----------------------------|:----------------|
| M1: Kebutuhan | Dokumen kebutuhan + User Flow | Selesai | File `dokumen-kebutuhan.md` di Tugas 4 |
| M2: UI/UX | Wireframe + Navigasi | Selesai | File *prototype* & navigasi di Tugas 5 & 6 |
| M3: MVP Awal | Model data + CRUD lokal | Selesai | File `crud-lokal.dart` di Tugas 7 |

## 3. Matriks Kebutuhan ke Implementasi

| ID Kebutuhan | Deskripsi Kebutuhan | Prioritas MoSCoW | Halaman Pemenuh | Operasi Data Terkait |
|:-------------|:-------------------|:----------------:|:----------------|:---------------------|
| F-01 | Mengirimkan Form Absensi (GPS & Catatan) | Must | Halaman Form | Create |
| F-03 | Melihat riwayat kehadiran pribadi (Daftar Absen) | Must | Halaman Riwayat Pegawai | Read |
| F-04 | Pemantauan / Verifikasi Status TU | Should | Halaman Riwayat Pegawai | Update |
| F-02 | Antisipasi input *human error* / batal | Could | Halaman Riwayat Pegawai | Delete |

## 4. Tangkapan Layar Aplikasi Berjalan
*(Bukti visual ini diambil dari pengerjaan MVP pada Tugas 7)*

- **screenshot-daftar.png**: Layar utama (*Read*) yang memperlihatkan daftar setelah proses absen (*Create*) berhasil dilakukan.
- **screenshot-form.png**: Form validasi interaktif.
- **screenshot-hapus.png**: Dialog peringatan *AlertDialog* sesaat sebelum operasi *Delete* dieksekusi.

## 5. Kendala dan Solusi Teknis

| No. | Kendala | Cara Mengatasinya |
|:---:|:--------|:------------------|
| 1 | **Tampilan Layar Daftar (*List*) tidak berubah** setelah *Form* absen dikirimkan. | Karena saya hanya menangkap nilai dengan `await Navigator.pushNamed()` namun lupa membungkus perintah penambahan `_daftar.add()` ke dalam blok `setState()`. Setelah dibungkus `setState()`, UI langsung sinkron. |
| 2 | **Error *RenderFlex Overflow* (garis kuning/hitam)** ketika *keyboard* muncul untuk mengisi catatan absensi. | Mengubah penggunaan `Column` menjadi `ListView` di dalam Form, sehingga seluruh elemen dapat digulir (*scrollable*) saat area layar dikurangi oleh *keyboard*. |

## 6. Rencana Pengembangan Milestone M5 (REST API)
Pada pertemuan ke-9 nanti, logika `List` *in-memory* ini akan diganti. Operasi aksi absen (*Create*) akan mengirimkan *payload JSON* melalui metode HTTP POST ke *backend server* Puskesmas. Sementara Halaman Utama (*Read*) akan melakukan HTTP GET untuk mengunduh, me-*decode* (*jsonDecode*), dan menampilkan data murni yang telah tervalidasi dari server pusat agar bisa dipantau secara lintas departemen (Admin TU).

## 7. Refleksi Pembelajaran Tengah Semester
Memasuki pertengahan semester, saya baru benar-benar menyadari bahwa desain UI/UX yang indah sama sekali tidak berguna jika tidak diiringi dengan manajemen *State* yang baik di bawah kap mesinnya (*under the hood*). Sinkronisasi antara siklus `StatefulWidget`, model data statis murni, dan perintah navigasi `push` memicu saya untuk harus berpikir sebagai "Sutradara" (yang mengatur perpindahan data ke mana dan kapan), bukan sekadar penata letak (*layouting*). Konsep ini menantang tapi sangat mencerahkan.

## 8. Deklarasi Penggunaan AI
Deklarasi penggunaan AI: Asisten berbasis AI — membantu merumuskan poin penjelasan pada *tes konsep* dan mengurai matriks kendala-solusi pada laporan *progress*; setiap poin argumentasi dipelajari, direvisi dari segi keterkaitan ke kasus Puskesmas, serta dievaluasi mandiri oleh penulis.

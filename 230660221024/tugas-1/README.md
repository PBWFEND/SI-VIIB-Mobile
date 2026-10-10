# Tugas 1 — Identifikasi Kebutuhan Aplikasi Bergerak

- **Nama:** Ridho Akmal Aulia
- **NIM:** 230660221024
- **Kelas:** SI-VIIB
- **Mata Kuliah:** Pemrograman Aplikasi Bergerak
- **Program Studi:** Sistem Informasi

## Deskripsi Sistem

Aplikasi Absensi Organisasi Mahasiswa merupakan aplikasi mobile yang ditujukan bagi anggota organisasi untuk melakukan check-in dan memeriksa status kehadiran, serta bagi panitia untuk membantu pencatatan kehadiran kegiatan di lingkungan kampus. Saat ini, pencatatan kehadiran masih menggunakan daftar hadir kertas sehingga catatan dari setiap kegiatan berpotensi tersimpan secara terpisah dan menyulitkan pengumpulan data untuk rekapitulasi. Aplikasi ini dirancang untuk memusatkan proses pencatatan kehadiran secara digital, sedangkan penyimpanan dan pengelolaan data dilakukan melalui backend Sistem Informasi agar pengurus dapat mengakses rekap sesuai kewenangannya. Bentuk aplikasi mobile dipilih karena interaksi sentuh memudahkan anggota melakukan check-in melalui ponsel dan sesi penggunaan yang singkat menuntut proses absensi yang sederhana serta cepat.

## Tabel Kebutuhan

| No. | Permintaan | Pengguna | Karakteristik Mobile yang Terkait | Fitur Aplikasi | Materi Pemenuh |
|---:|---|---|---|---|---|
| 1 | Anggota dapat melihat daftar kegiatan organisasi yang memiliki sesi absensi. | Anggota | Layar kecil dan sesi penggunaan singkat. | Halaman daftar kegiatan dengan ringkasan nama dan jadwal kegiatan. | Minggu 3, 5 |
| 2 | Anggota dapat melihat informasi kegiatan dan waktu sesi absensi sebelum check-in. | Anggota | Layar kecil dan interaksi sentuh. | Halaman detail kegiatan yang menampilkan nama, jadwal, lokasi, dan status sesi. | Minggu 3, 5–6 |
| 3 | Anggota dapat mencatat kehadiran dengan tombol check-in pada kegiatan yang dipilih. | Anggota | Interaksi sentuh dan sesi penggunaan singkat. | Tombol check-in, indikator proses, serta pesan keberhasilan atau kegagalan. Validasi sesi dan duplikasi dilakukan backend. | Minggu 3, 5–6, 9–10 |
| 4 | Anggota dapat memeriksa bahwa kehadirannya sudah tercatat serta melihat riwayat absensi. | Anggota | Sesi penggunaan singkat. | Halaman status dan riwayat kehadiran yang mengambil data dari backend. | Minggu 3, 5–6, 9–10 |
| 5 | Panitia dapat membuat, membuka, dan menutup sesi absensi melalui aplikasi yang sama dengan hak akses khusus. | Panitia | Interaksi sentuh dan layar kecil. | Formulir pengelolaan sesi absensi yang hanya tersedia bagi panitia berwenang. Backend memvalidasi hak akses. | Minggu 3, 5–6, 9–10 |
| 6 | Panitia dapat melihat daftar anggota yang tercatat hadir pada kegiatan. | Panitia | Layar kecil dan interaksi sentuh. | Daftar kehadiran dengan nama anggota, waktu check-in, dan status pencatatan. | Minggu 3, 5–6, 9–10 |
| 7 | Data kehadiran berbagai kegiatan dikumpulkan dan disimpan secara terpusat agar bisa direkap. | Pengurus dan panitia sebagai pengguna rekap. | Konektivitas memengaruhi pengiriman serta pengambilan data dari server. | Di luar lingkup implementasi aplikasi mobile: penyimpanan terpusat, validasi bisnis, penggabungan data, dan pengolahan rekap ditangani backend SI dan database. Aplikasi menampilkan data sesuai hak akses. | Minggu 9–10; backend SI dan database |

## Refleksi Fitur Perangkat

Fitur perangkat yang relevan untuk pengembangan berikutnya adalah notifikasi pengingat jadwal kegiatan dan sesi absensi. Notifikasi dapat membantu anggota agar tidak melewatkan waktu check-in, tetapi fitur ini masih berupa ide pengembangan dan belum diimplementasikan pada Tugas 1. Selain itu, konektivitas jaringan perlu diperhatikan karena aplikasi mobile bergantung pada backend untuk mengirim dan mengambil data kehadiran.

## Referensi Artefak dan Bukti Environment

- `diagram.mmd` — sumber diagram arsitektur.
- `diagram.png` — hasil ekspor diagram arsitektur.
- `flutter-doctor/sebelum.png` — bukti `flutter doctor -v` sebelum perbaikan atau kondisi awal yang valid.
- `flutter-doctor/sesudah.png` — bukti `flutter doctor -v` setelah perbaikan yang benar-benar dilakukan.
- `aplikasi.png` — screenshot aplikasi Flutter berjalan di Chrome.
- Flutter SDK: `C:\src\flutter`; Flutter 3.47.7 stable; Dart 3.13.5; Git 2.52.0.windows.1; target Chrome.
- Catatan: Android toolchain dan Visual Studio belum tersedia, tetapi target Tugas 1 adalah Chrome.

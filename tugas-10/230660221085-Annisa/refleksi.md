# Refleksi Pembelajaran — Tugas 10

## 1. Bagian Integrasi Data yang Paling Sulit
Bagian yang paling sulit dipahami dan dikerjakan adalah menyusun logika penggabungan (*join*) data dari tiga endpoint berbeda (`/users`, `/comments`, dan `/posts`) yang struktur field-nya berasal dari API simulasi publik. Mengonversi daftar objek pengguna dan ruangan ke dalam struktur lookup `Map<int, Model>` sebelum dipetakan ke dalam model ringkas (`DataPengajuanRingkas`) memerlukan ketelitian tinggi agar pencocokan identifier (`userId` dan `roomId`) tidak menghasilkan *null error* saat ada ID yang tidak cocok.

## 2. Cara Menangani Response Kosong atau Error
Response kosong dan error ditangani secara terpisah antara lapisan service (`IntegrasiService`) dan lapisan antarmuka (`HalamanDaftarTerintegrasi`). Jika proses `Future.wait` gagal akibat koneksi terputus (`SocketException`), batas waktu habis (`TimeoutException`), atau HTTP status code di luar 200, service melempar pesan error yang ramah pengguna dan tampilan memunculkan tombol **Coba Lagi** untuk memicu request ulang. Sebaliknya, apabila request ke server berhasil tetapi daftar hasil penyaringan status kosong, halaman menampilkan ilustrasi *empty state* tanpa pesan kesalahan merah agar pengguna tahu sistem berjalan normal.

## 3. Alasan Pemisahan Service dan Widget
Pemisahan `IntegrasiService` dari widget antarmuka dilakukan agar kode tampilan tetap bersih dan hanya berfokus pada pengelolaan *state* UI (loading, sukses, kosong, error) serta interaksi filter. Seluruh kompleksitas pemanggilan HTTP paralel, batas waktu *timeout*, parsing JSON melalui `fromJson`, penggabungan ID, serta penetapan status proses bisnis terisolasi di satu tempat sehingga lebih mudah diuji, digunakan ulang, dan mencegah pemanggilan ulang API saat widget di-render ulang.

## Deklarasi Penggunaan AI
Deklarasi penggunaan AI: Gemini — membantu menjelaskan struktur penggabungan data paralel menggunakan `Future.wait` dan pemetaan lookup `Map` berdasarkan identifier; seluruh penyesuaian model bisnis, pengujian state antarmuka, dan dokumentasi dilakukan serta diverifikasi oleh penulis.
# Refleksi Tugas 10 — Integrasi Data dan Proses Bisnis

## 1. Kesulitan yang Dihadapi

Kesulitan yang saya hadapi dalam pengerjaan Tugas 10 adalah memahami cara mengambil data dari beberapa endpoint API dan menggabungkannya menjadi satu informasi yang dapat ditampilkan pada aplikasi.

Saya perlu memahami hubungan antara `id` pada data pengguna dan `userId` pada data pengajuan. Selain itu, saya juga perlu memastikan bahwa response JSON dapat diubah menjadi model Dart dengan benar.

Penggunaan `Future.wait` juga menjadi hal yang perlu dipahami karena kedua request dijalankan secara asynchronous.

## 2. Cara Menangani Data Kosong dan Error

Untuk menangani kondisi data kosong, saya menggunakan pemeriksaan pada hasil integrasi. Jika daftar pengajuan kosong, aplikasi menampilkan pesan bahwa belum ada data pengajuan.

Untuk menangani error, proses pengambilan data menggunakan `try-catch`, pengecekan status HTTP, dan batas waktu request atau timeout.

Ketika terjadi kesalahan, aplikasi menampilkan pesan error dan menyediakan tombol Coba Lagi agar pengguna dapat mengulangi proses pengambilan data.

## 3. Alasan Memisahkan Service dan Widget

Saya memisahkan service dan widget agar kode aplikasi lebih terstruktur dan mudah dipahami.

`IntegrasiService` bertugas mengambil data dari API, melakukan parsing JSON, dan menggabungkan data. Sementara itu, `HalamanIntegrasi` bertugas menampilkan hasil pengolahan data kepada pengguna.

Dengan pemisahan ini, kode tampilan tidak perlu menangani proses request API secara langsung. Jika proses pengambilan data perlu diperbaiki, perubahan dapat dilakukan pada bagian service tanpa harus mengubah seluruh tampilan aplikasi.

## 4. Hal yang Dipelajari

Dari pengerjaan Tugas 10, saya mempelajari beberapa hal:

1. Mengambil data dari lebih dari satu endpoint API.
2. Mengubah response JSON menjadi model Dart menggunakan `fromJson`.
3. Menggunakan `Future.wait` untuk menjalankan beberapa request asynchronous.
4. Menggabungkan data berdasarkan identifier.
5. Memisahkan service dan tampilan aplikasi.
6. Menangani kondisi loading, data, empty, dan error pada Flutter.

## 5. Penggunaan AI

Dalam pengerjaan tugas ini, saya menggunakan AI sebagai alat bantu untuk memahami materi, menyusun struktur model Dart, membantu membuat service integrasi, memperbaiki kode Flutter, dan menyusun dokumentasi.

Saya tetap mempelajari kembali kode yang diberikan, menyesuaikannya dengan struktur proyek FasKampus, serta menjalankan pemeriksaan menggunakan `flutter analyze` dan pengujian aplikasi.

AI digunakan sebagai pendamping pengerjaan, bukan sebagai pengganti proses memahami dan menguji kode.

## 6. Kesimpulan Pribadi

Setelah mengerjakan Tugas 10, saya menjadi lebih memahami bahwa sebuah aplikasi tidak hanya mengambil data dari satu sumber, tetapi juga dapat menggabungkan data dari beberapa endpoint agar informasi yang ditampilkan lebih lengkap.

Saya juga memahami pentingnya memisahkan proses pengolahan data dari tampilan aplikasi serta menyediakan penanganan error agar aplikasi lebih mudah digunakan.

Ke depannya, konsep integrasi ini dapat dikembangkan pada FasKampus dengan menggunakan API khusus yang menyediakan data pengguna, fasilitas kampus, dan pengajuan peminjaman secara nyata.
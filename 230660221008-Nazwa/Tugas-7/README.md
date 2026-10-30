# Tugas 7: Data Lokal dan CRUD - Pengaduan Fasilitas Kampus

* **Nama**: Nazwa Umaira Nanindia Ramdhani
* **NIM**: 230660221008
* **Domain SI**: Pengaduan Fasilitas Kampus

---

## Deskripsi Aplikasi MVP

Aplikasi MVP Pengaduan Fasilitas Kampus ini menyediakan fungsi pengelolaan data lokal in-memory untuk mencatat, menampilkan, memperbarui status, dan menghapus laporan kerusakan fasilitas di lingkungan kampus. Aplikasi menggunakan `StatefulWidget` dan `setState` dalam mengelola daftar entitas laporan secara dinamis.

---

## Refleksi 3 Kalimat

Bagian yang paling sulit dipertahankan konsistensinya adalah menyelaraskan immutability objek model data dengan pembaruan array state saat operasi Update dan Delete berlangsung. Hal ini terjadi karena setiap perubahan atribut seperti status laporan membutuhkan instansiasi ulang objek baru serta pencarian indeks berbasis `id` unik yang cermat. Kendala ini berhasil diatasi dengan memanfaatkan ID timestamp serta membungkus setiap perubahan daftar di dalam pemanggilan fungsi `setState()`[cite: 33].

---

## Deklarasi AI

Deklarasi penggunaan AI: Gemini — membantu merancang struktur kode Flutter CRUD lokal in-memory dan menyusun dokumentasi Markdown; seluruh kode dan dokumentasi diperiksa serta disesuaikan ulang oleh mahasiswa.
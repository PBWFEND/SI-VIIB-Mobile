# Refleksi Tugas 10 — Integrasi Data dan Proses Bisnis

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## 1. Bagian Integrasi Data yang Paling Sulit

Bagian yang paling menantang adalah **menggabungkan dua hasil `Future` dari `Future.wait` dan mencocokkan kunci relasi `userId` dengan `id` pemesan secara aman** tanpa menimbulkan kesalahan tipe data (*type casting*) maupun kegagalan apabila terdapat `userId` yang tidak ditemukan pada daftar pemesan.

## 2. Cara Menangani Response Kosong atau Error

Aplikasi memisahkan secara jelas antara **kondisi error jaringan/HTTP** (ditangani dengan `try-catch`, `.timeout(Duration(seconds: 10))`, serta menampilkan ikon jaringan terputus, pesan kesalahan ramah pengguna, dan tombol **"Coba Lagi"**) dengan **kondisi data kosong** (ditampilkan menggunakan ikon kotak kosong dan teks informasi saat hasil filter status tidak memiliki data, bukan sebagai pesan error).

## 3. Alasan Pemisahan Service dan Widget

Pemisahan logika pemanggilan HTTP, penguraian JSON (`fromJson`), penggabungan relasi data, dan aturan transisi status ke dalam class **`IntegrasiKantinService`** membuat kode pada widget **`HalamanIntegrasiPesanan`** tetap ringkas dan berfokus pada pengelolaan state tampilan (*loading*, *sukses*, *kosong*, *error*), sehingga lebih mudah diuji dan dirawat apabila URL endpoint berubah.

---

Deklarasi penggunaan AI: Gemini — membantu menjelaskan struktur penggabungan dua endpoint menggunakan `Future.wait` dan pemetaan relasi `userId` ke model `PesananTerintegrasi`; seluruh kode, pengujian pada Chrome, dan dokumentasi diverifikasi oleh penulis.
# Quiz Pertemuan 10 — Integrasi Data dan Proses Bisnis Sistem Informasi

* **Mata Kuliah:** Pemrograman Aplikasi Bergerak
* **Pertemuan:** 10 | **CPMK:** CPMK-3
* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Project:** Kantin Kampus Digital

---

## Soal 1 — Integrasi Data

**Jawaban:**
Integrasi data pada aplikasi mobile adalah proses menggabungkan dan menyelaraskan data yang berasal dari beberapa sumber atau endpoint REST API yang terpisah ke dalam satu kesatuan model informasi yang utuh untuk mendukung suatu proses bisnis Sistem Informasi[cite: 22, 23].

* **Contoh pada Project (Kantin Kampus Digital):** Pada layar daftar antrean pesanan untuk pengelola stan, informasi pesanan yang masuk dari endpoint `/posts` hanya memuat rincian menu serta kode pengenal pemesan (`userId`), sedangkan identitas lengkap mahasiswa (nama dan email) tersimpan secara terpisah pada endpoint pengguna (`/users`). Aplikasi mengintegrasikan kedua sumber data tersebut agar pengelola stan dapat melihat nama lengkap mahasiswa beserta menu yang dipesannya dalam satu kartu antrean.
* **Identifier Penghubung:** Data dihubungkan melalui relasi kunci **`userId`** pada entitas `DataPesanan` yang dicocokkan dengan kunci utama **`id`** pada entitas `DataPemesan`.

---

## Soal 2 — `Future.wait`

**Jawaban:**
* **Kapan `Future.wait` digunakan:** `Future.wait` digunakan ketika aplikasi perlu menjalankan **beberapa request asynchronous secara bersamaan (paralel)** karena kedua request tersebut **bersifat independen** (tidak saling bergantung satu sama lain). Pada project *Kantin Kampus Digital*, request `ambilDaftarPemesan()` (`GET /users`) dan `ambilDaftarPesanan()` (`GET /posts`) dijalankan secara paralel menggunakan `Future.wait` sehingga total waktu tunggu jaringan jauh lebih singkat dibandingkan memanggil keduanya satu per satu secara berurutan.
* **Kondisi yang mengharuskan request dijalankan secara berurutan (*sequential*):** Request wajib dijalankan secara berurutan apabila **request kedua membutuhkan data atau identifier yang baru diperoleh dari hasil respons request pertama**. Contohnya, jika aplikasi harus melakukan request `GET /users/login` terlebih dahulu untuk mendapatkan `userId` mahasiswa yang sedang masuk, baru kemudian memanggil `GET /orders?userId={id}` menggunakan ID hasil respons pertama tersebut.

---

## Soal 3 — Model dan `fromJson`

**Jawaban:**
* **Field yang dibutuhkan model `DataPesanan`:**
  1. `id` (`int`): Nomor unik transaksi pesanan.
  2. `userId` (`int`): *Foreign key* (identifier penghubung) yang merujuk pada `id` mahasiswa pada model `DataPemesan`.
  3. `namaMenu` (`String`): Nama menu makanan/minuman yang dipesan.
  4. `catatan` (`String`): Rincian porsi dan catatan tambahan pesanan.
  5. `status` (`StatusPesanan` / `String`): Status progres pesanan (`menunggu`, `diproses`, `siapDiambil`).
* **Cara `fromJson` menangani field yang tidak tersedia pada response:** Factory constructor `fromJson` menerapkan mekanisme *null-aware casting* dan **operator *null-coalescing* (`??`)** untuk memberikan nilai cadangan (*default value*) yang aman apabila key JSON tidak ditemukan atau bernilai `null` dari server[cite: 24]. Misalnya:
  ```dart
  userId: json['userId'] as int? ?? 0,
  namaMenu: json['title'] as String? ?? 'Menu Tidak Diketahui',
  catatan: json['body'] as String? ?? '-',
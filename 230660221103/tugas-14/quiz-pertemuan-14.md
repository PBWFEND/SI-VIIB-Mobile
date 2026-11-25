# Quiz Pertemuan 14 — Integrasi Project dan Penyempurnaan UI/UX

* **Mata Kuliah:** Pemrograman Aplikasi Bergerak
* **Pertemuan:** 14 | **CPMK:** CPMK-5
* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Project:** Kantin Kampus Digital

---

## Soal 1 — Integrasi Fitur

**Jawaban:**
Integrasi fitur memerlukan satu kontrak model data yang dipakai bersama agar seluruh halaman berbicara dengan struktur data, nama field, dan tipe status yang seragam ketika saling bertukar informasi.

* **Risiko apabila setiap halaman memiliki model sendiri:**
  1. **Ketidakcocokan tipe data dan pemetaan berulang:** Jika halaman daftar memakai `enum StatusPesanan` sementara halaman form memakai `String` bebas, pengembang harus menulis kode konversi manual di setiap perpindahan halaman yang rawan salah ketik (*typo*).
  2. **Sinkronisasi data terputus:** Perubahan data pada halaman detail tidak otomatis memperbarui daftar karena struktur objek dan pengenal unik (`id`) tidak konsisten antarhalaman.

---

## Soal 2 — Sumber Data

**Jawaban:**
* **Pengertian satu sumber data (*Single Source of Truth*):** Seluruh data entitas disimpan dan dikelola pada satu lokasi terpusat (satu service/repository atau state induk bersama), bukan diduplikasi secara terpisah di tiap halaman.
* **Hubungan antara Service, State Halaman, dan Widget:**
  1. **Service / Repository:** Mengambil, menyimpan, dan memperbarui data dari backend atau penyimpanan utama.
  2. **State Halaman (`StatefulWidget`):** Memegang salinan data terkini dari service untuk dirender dan memperbaruinya melalui `setState()` setiap kali terjadi transaksi baru atau perubahan status.
  3. **Widget UI:** Bersifat pasif menampilkan data dari state halaman serta meneruskan aksi pengguna (seperti klik simpan atau ubah status) kembali ke state/service.

---

## Soal 3 — Tata Letak Responsif

**Jawaban:**
* **Kapan `LayoutBuilder` lebih tepat daripada `MediaQuery.sizeOf`:** `LayoutBuilder` lebih tepat digunakan ketika keputusan tata letak bergantung pada **ruang lebar aktual yang diberikan oleh widget induk (`constraints.maxWidth`)**, bukan ukuran keseluruhan layar perangkat — misalnya ketika komponen berada di dalam panel, dialog, atau jendela web yang ukurannya dapat diubah pengguna.
* **Contoh kasus pada halaman daftar dan detail:** Pada halaman utama *Kantin Kampus Digital*, `LayoutBuilder` memeriksa `constraints.maxWidth >= 720`. Jika lebar kurang dari `720px` (layar ponsel sempit), aplikasi merender **1 kolom** daftar pesanan dan membuka detail melalui navigasi layar baru (`Navigator.push`); jika lebar `>= 720px` (layar tablet/desktop lebar), aplikasi merender **2 kolom berdampingan** (daftar pesanan di kiri dan panel detail di kanan).

---

## Soal 4 — Keadaan Antarmuka

**Jawaban:**
* **Alasan ketiga keadaan harus dibedakan:**
  1. **Keadaan Memuat (*Loading*):** Memberi sinyal bahwa sistem sedang memproses permintaan sehingga pengguna menunggu dan tidak menekan tombol berulang kali.
  2. **Keadaan Kosong (*Empty*):** Menandakan komunikasi berhasil dan sistem normal, hanya saja data memang belum ada (atau hasil filter nihil), sehingga tindakan yang ditawarkan adalah **menambah data atau mereset filter**.
  3. **Keadaan Gagal (*Error*):** Menandakan terjadi gangguan teknis (koneksi terputus/server gagal), sehingga tindakan yang ditawarkan adalah **tombol Coba Lagi (*retry*)**[cite: 25].
* **Akibat jika ketiganya ditampilkan dengan pesan yang sama:** Pengguna akan kebingungan — apabila kegagalan jaringan ditampilkan sebagai daftar kosong, mahasiswa akan mengira pesanannya hilang atau tidak pernah masuk, dan tidak memiliki tombol pemulihan untuk memuat ulang data[cite: 25].

---

## Soal 5 — Aksesibilitas

**Jawaban:**
Tiga pemeriksaan aksesibilitas dasar beserta target praktis dan penerapannya:
1. **Ukuran Target Sentuh (*Touch Target Size*):**
   * *Target praktis:* Minimal **48 x 48 piksel**[cite: 25].
   * *Cara menerapkan:* Mengatur `minimumSize: const Size.fromHeight(48)` pada `FilledButton` / `OutlinedButton` serta memberi jarak antar-elemen klik agar mudah ditekan oleh ibu jari tanpa salah ketuk[cite: 25].
2. **Kontras Warna dan Tidak Bergantung pada Warna Saja:**
   * *Target praktis:* Rasio kontras minimal **4.5:1** untuk teks normal dan informasi status tidak hanya dibedakan lewat warna[cite: 25].
   * *Cara menerapkan:* Menggunakan pasangan warna resmi dari `Theme.of(context).colorScheme` (seperti `primaryContainer` dengan `onPrimaryContainer`) serta selalu menyertakan teks label status di dalam `Chip`[cite: 25].
3. **Label Aksi untuk Pembaca Layar (*Screen Reader*):**
   * *Target praktis:* Setiap tombol ikon memiliki deskripsi teks yang dapat dibaca teknologi bantu[cite: 25].
   * *Cara menerapkan:* Menambahkan properti `tooltip` pada setiap `IconButton` (misalnya `tooltip: 'Simulasi Keadaan Gagal'`)[cite: 25].

---

## Soal 6 — Candidate Release

**Jawaban:**
* **Komponen catatan rilis *candidate release*:** Nomor versi (misal `1.0.0-rc.1`), tanggal build, platform target (Web/Android), daftar fitur utama, daftar perbaikan dari versi sebelumnya, batasan pengujian yang masih ada, serta cara menjalankan aplikasi[cite: 25].
* **Alasan versi bertanda `rc` perlu dicatat dan diuji pihak lain sebelum final:** Penanda `rc` (*release candidate*) menunjukkan bahwa aplikasi sudah terintegrasi dan siap diuji sebagai kandidat rilis, tetapi masih berpotensi memiliki kekurangan alur atau tampilan dari sudut pandang pengguna baru. Pencatatan versi memudahkan pelacakan apabila ditemukan bug baru (`rc.1` → `rc.2`), sedangkan pengujian oleh pihak lain (*peer review* / uji penerima) mengungkap kesalahan asumsi pengembang sebelum versi dinyatakan final[cite: 25].
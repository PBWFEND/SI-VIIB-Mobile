# Tugas 6: Navigation Flow dan Interaksi

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Deskripsi Singkat Tugas

Tugas ini menghubungkan rancangan antarmuka dari Tugas 5 menjadi alur aplikasi bernavigasi pada domain **Kantin Kampus Digital** menggunakan `Navigator` dengan peta route bernama (`'/'`, `'/detail'`, `'/pesan'`), pengiriman data objek `DataMenu` melalui `arguments` yang diperiksa tipenya, formulir pemesanan berbasis `StatefulWidget` dengan validasi tiap kolom dan siklus `dispose()`, serta umpan balik interaksi menggunakan pesan validator dan `SnackBar`[cite: 24, 25].

---

## 2. Daftar Berkas

* `navigation-flow.md` — Daftar route dari IA, diagram alur navigasi Mermaid, dan alasan pemilihan `initialRoute`[cite: 24, 25].
* `form-interaksi.dart` — Kode lengkap implementasi navigasi bernama, pengiriman arguments, form tervalidasi, dan feedback `SnackBar`[cite: 24, 25].
* `screenshot-alur.png` — Tangkapan layar layar detail menu saat terbuka membawa data dari katalog[cite: 24, 25].
* `screenshot-feedback.png` — Tangkapan layar `SnackBar` konfirmasi setelah form pemesanan valid dikirimkan[cite: 24, 25].
* `catatan-keputusan-navigasi.md` — Tabel keputusan penamaan route, pengiriman data, validasi, dan umpan balik interaksi[cite: 24, 25].

---

## 3. Refleksi

Bagian yang paling sulit dipertahankan konsistensinya adalah **menyelaraskan penamaan route, tipe data `arguments` yang dikirim antarlayar, serta urutan alur validasi hingga `SnackBar` antara diagram navigation flow dan kode implementasi**[cite: 24, 25]. Pemeriksaan tipe data `args is DataMenu` pada layar detail serta memastikan seluruh `TextEditingController` dibersihkan pada method `dispose()` membutuhkan ketelitian ekstra agar aplikasi bebas dari *runtime error* maupun kebocoran memori. Melalui pengerjaan ini, saya memahami bahwa merancang peta route sejak awal mencegah terjadinya navigasi buntu atau layar tertutup secara tidak terduga[cite: 24].

---

Deklarasi penggunaan AI: Gemini — membantu memvalidasi struktur pengiriman `arguments` dengan pemeriksaan tipe `is` dan urutan eksekusi validasi form sebelum `SnackBar` dan `Navigator.pop`; seluruh kode dan dokumen disesuaikan kembali oleh penulis[cite: 24, 25].
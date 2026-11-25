# Tugas 7: MVP Awal dengan Data Lokal

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Deskripsi Singkat Tugas

Tugas ini mengembangkan aplikasi **Kantin Kampus Digital** menjadi MVP awal yang mengelola data secara dinamis di perangkat menggunakan class model **`DataPesanan`**, state lokal pada `StatefulWidget` dengan `setState()`, serta operasi **CRUD lengkap** (*Create* dari form tervalidasi, *Read* melalui `ListView.builder`, *Update* status pesanan dengan penggantian objek berdasarkan `id`, dan *Delete* dengan konfirmasi `AlertDialog`)[cite: 26, 27].

---

## 2. Daftar Berkas

* `model-data.md` — Spesifikasi entitas `DataPesanan`, tipe data, sumber nilai setiap field, dan keterkaitannya dengan kebutuhan Tugas 4[cite: 26, 27].
* `crud-lokal.dart` — Kode implementasi model data, `StatefulWidget`, dan operasi CRUD lokal lengkap[cite: 26, 27].
* `screenshot-daftar.png` — Tangkapan layar daftar pesanan setelah penambahan data baru melalui form berhasil dilakukan[cite: 26, 27].
* `screenshot-hapus.png` — Tangkapan layar dialog konfirmasi (`AlertDialog`) saat tombol hapus ditekan[cite: 26, 27].
* `catatan-keputusan-data.md` — Tabel alasan pemilihan struktur field, kunci unik `id`, pemetaan CRUD, dan strategi persistensi[cite: 26, 27].

---

## 3. Refleksi

Bagian yang paling sulit dipertahankan konsistensinya adalah **menjaga keselarasan antara field model data, input formulir, serta operasi pembaruan objek (*immutable update*) menggunakan `id` unik** agar setiap perubahan data langsung tercermin di antarmuka melalui `setState()`[cite: 26, 27]. Membiasakan diri memakai `indexWhere` dan `removeWhere` berbasis `id` ketimbang indeks posisi daftar juga membutuhkan ketelitian agar operasi hapus maupun ubah status tidak mengenai entri yang keliru. Melalui pengerjaan Tugas 7 ini, aplikasi yang semula hanya menampilkan data statis kini berfungsi sebagai prototipe interaktif yang siap diuji pada evaluasi UTS.

---

Deklarasi penggunaan AI: Gemini — membantu memvalidasi pola penggantian objek *immutable* pada operasi Update serta struktur konfirmasi `AlertDialog` pada operasi Delete berbasis `id`; seluruh model data dan kode disesuaikan kembali oleh penulis[cite: 26, 27].
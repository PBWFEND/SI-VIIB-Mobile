# Tugas 1: Identifikasi Kebutuhan Aplikasi Bergerak

* **Nama:** <Nama Lengkap Anda>
* **NIM:** 230660221103
* **Kelas:** <SI-VIIA / SI-VIIB>
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Deskripsi Sistem

Sistem Informasi Pemesanan Kantin Kampus dirancang untuk digunakan oleh **mahasiswa dan dosen** sebagai pemesan makanan, serta **penjual/pengelola kantin** sebagai pengelola pesanan[cite: 10]. Masalah utama saat ini adalah penumpukan antrean fisik saat jam istirahat kuliah yang memakan waktu lama, ketidakjelasan ketersediaan menu yang masih ada, serta sering terjadinya kesalahan pencatatan pesanan manual oleh penjual[cite: 10]. Solusi berbentuk **aplikasi mobile** sangat tepat karena menyesuaikan dengan karakteristik **sesi penggunaan singkat** (pemesan dapat memesan makanan dalam hitungan detik dari ruang kelas sebelum jam istirahat tiba) serta **konteks bergerak dan interaksi sentuh** (pengguna berpindah lokasi menuju kantin dan hanya memerlukan beberapa ketukan layar tanpa mengetik panjang untuk memilih menu dan memantau status pesanan).

---

## 2. Diagram Arsitektur

*(Diagram terlampir pada berkas `diagram.png` dan `diagram.mmd`)*

Alur komunikasi berjalan dua arah (client–server): Aplikasi Mobile (Flutter) mengirimkan HTTP Request (JSON) berisi permintaan daftar menu atau pembuatan pesanan baru menuju Backend SI Kantin (REST API), yang kemudian memvalidasi dan menyimpan transaksi ke Database Kantin, lalu mengembalikan HTTP Response (JSON) berupa data menu terbaru atau status antrean ke perangkat pengguna.

---

## 3. Tabel Kebutuhan Aplikasi

| No. | Permintaan | Pengguna | Karakteristik Mobile yang Terkait | Fitur Aplikasi | Materi Pemenuh |
| :-: | :--- | :--- | :--- | :--- | :--- |
| 1 | Melihat daftar makanan/minuman beserta harga dan detail menu[cite: 10] | Mahasiswa / Dosen | **Layar kecil dan variatif** — informasi menu perlu disusun ringkas agar mudah dipindai pada layar ponsel | Halaman Katalog Menu (ListView/Grid) & Halaman Detail Menu | Minggu 3 & 5 |
| 2 | Mencari menu makanan berdasarkan kategori atau nama | Mahasiswa / Dosen | **Sesi penggunaan singkat** — pemesan ingin menemukan makanan favorit secepat mungkin saat jeda kuliah | Kolom Pencarian (*Search Bar*) & Filter Kategori | Minggu 5–6 |
| 3 | Memasukkan menu ke keranjang dan mengirim pesanan (*checkout*) | Mahasiswa / Dosen | **Interaksi sentuh** — tombol tambah/kurang porsi berukuran minimal 48x48 piksel agar mudah ditekan satu tangan | Halaman Keranjang & Form Konfirmasi Pesanan | Minggu 6 & 9–10[cite: 9] |
| 4 | Menyimpan riwayat pesanan dan daftar menu terakhir agar tetap bisa dilihat saat sinyal di dalam gedung lemah[cite: 9] | Mahasiswa / Dosen | **Konektivitas terbatas** — jaringan seluler sering tidak stabil di dalam ruang kelas/gedung kampus[cite: 9] | Penyimpanan Lokal (*Local Storage / Cache*)[cite: 9] | Minggu 7[cite: 9] |
| 5 | Menerima pemberitahuan otomatis ketika pesanan sudah selesai dimasak dan siap diambil[cite: 9] | Mahasiswa / Dosen | **Konteks bergerak** — pemesan tidak perlu menunggu di depan stan dan bisa datang tepat saat makanan siap[cite: 9] | *Local / Push Notification* Status Pesanan[cite: 9] | Minggu 11[cite: 9] |
| 6 | Mengunggah foto bukti transfer pembayaran atau memindai QRIS stan kantin | Mahasiswa / Dosen | **Pemanfaatan kapabilitas perangkat** — kamera ponsel digunakan langsung di lokasi tanpa perlu perangkat tambahan[cite: 9] | Akses Kamera / Pemindai QR[cite: 9] | Minggu 11[cite: 9] |
| 7 | Mengelola master data stok bahan baku, mengubah harga menu, dan merekap laporan keuangan harian kantin | Penjual / Pengelola Kantin | *Tidak relevan untuk layar kecil (membutuhkan layar lebar dan input tabel masif)* | **Di luar lingkup aplikasi mobile (dikelola melalui Web Admin / Backend SI)**[cite: 10] | Backend SI[cite: 9] |

---

## 4. Refleksi

Fitur perangkat yang paling relevan untuk domain Pemesanan Kantin Kampus adalah **notifikasi perangkat (*notification*)** dan **kamera**. Fitur notifikasi sangat krusial karena memungkinkan mahasiswa menunggu di ruang kelas atau selasar dengan tenang dan baru berjalan menuju stan kantin tepat ketika pesanan mereka selesai disiapkan, sehingga mengurangi kerumunan fisik. Selain itu, fitur kamera sangat mendukung proses transaksi nontunai di tempat kejadian melalui pemindaian kode QR pembayaran atau unggah bukti bayar secara instan.
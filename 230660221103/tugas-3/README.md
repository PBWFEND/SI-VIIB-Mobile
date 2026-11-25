# Tugas 3: Halaman Aplikasi Sederhana

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Nama Aplikasi:** Kantin Kampus Digital
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Deskripsi Halaman

Halaman utama aplikasi **Kantin Kampus Digital** merupakan halaman katalog menu yang memudahkan mahasiswa maupun dosen melihat daftar makanan dan minuman yang dijual di berbagai stan kantin kampus secara cepat. Halaman ini dibangun menggunakan `MaterialApp` dan `Scaffold` yang terdiri atas `AppBar` di bagian atas, area konten utama (*body*) yang dibungkus dengan `Padding`, susunan vertikal menggunakan `Column` untuk menampilkan teks sapaan dan daftar menu, serta `ListView.builder` yang dibungkus `Expanded` untuk merender 5 entri data menu secara efisien. Setiap baris kartu menu disusun secara horizontal menggunakan `Row` yang memuat ikon makanan, informasi nama menu beserta stan dan harganya, serta indikator status ketersediaan (`Tersedia` atau `Habis`) dengan perbedaan warna kontras, dilengkapi dengan `FloatingActionButton` di sudut kanan bawah untuk akses cepat menuju keranjang pesanan.

---

## 2. Diagram Widget Tree & Bukti Tampilan

* **Diagram Widget Tree:** `widget-tree.png` (sumber: `widget-tree.mmd`)
* **Tangkapan Layar Aplikasi:** `screenshot-halaman.png`

---

## 3. Refleksi

Widget layout yang paling menantang untuk dirangkai adalah kombinasi antara `Column` dan `ListView.builder` karena menempatkan `ListView` secara langsung di dalam `Column` menyebabkan error *RenderFlex overflow* akibat tinggi daftar yang tidak terbatas. Masalah tersebut dapat diselesaikan dengan membungkus `ListView.builder` menggunakan widget `Expanded` agar ruang vertikal yang tersisa pada layar teralokasi dengan tepat. Selain itu, pengaturan posisi horizontal di dalam `Row` membutuhkan ketelitian dalam menggunakan `Expanded` pada bagian teks judul menu agar tidak bertabrakan dengan label status di sisi kanan saat teks terlalu panjang.
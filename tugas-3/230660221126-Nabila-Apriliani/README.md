# Tugas 3 — Halaman Aplikasi Sederhana

**Nama:** Nabila Apriliani  
**NIM:** 230660221126  
**Kelas:** SI-VIIB  

---

## Deskripsi Halaman

Aplikasi **Travel Booking App** merupakan antarmuka sederhana untuk menampilkan daftar paket layanan wisata dalam sistem pemesanan travel. Halaman ini menyajikan katalog informasi perjalanan yang mencakup nama paket, kategori tour, status ketersediaan, serta harga layanan.

**Domain Sistem Informasi:** Sistem Informasi Reservasi & Pelayanan Travel.

---

## Refleksi

Widget layout yang paling sulit saya rangkai adalah penyusunan `ListView.builder` di dalam `Column` karena kerap memicu terjadinya error *RenderFlex overflow* akibat batasan tinggi yang tidak terdefinisi. Masalah tersebut berhasil diatasi dengan membungkus widget `ListView.builder` menggunakan widget `Expanded` agar daftar dapat mengambil ruang vertikal yang tersisa secara fleksibel. Pembagian tata letak menggunakan kombinasi `Row` dan `Padding` di dalam elemen *Card* juga memerlukan ketelitian ekstra agar tampilan teks serta lencana status tetap rapi di berbagai ukuran layar.

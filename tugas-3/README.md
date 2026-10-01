# Tugas 3: Halaman Aplikasi Sederhana

**Nama:** Annisa  
**NIM:** 230660221085  
**Domain SI:** Sistem Informasi Armada Mobil  

---

## Deskripsi Halaman
Halaman utama aplikasi ini menampilkan daftar katalog kendaraan armada mobil beserta kategori dan status ketersediaannya secara real-time melalui komponen kartu interaktif.

## Refleksi
Widget layout yang paling sulit dirangkai adalah kombinasi antara `Column` dan `ListView.builder` karena sempat menyebabkan error `RenderFlex overflow`. Masalah tersebut terjadi karena `ListView` membutuhkan batasan tinggi yang jelas saat berada di dalam widget berorientasi vertikal. Masalah ini berhasil diatasi dengan membungkus `ListView.builder` menggunakan widget `Expanded`.
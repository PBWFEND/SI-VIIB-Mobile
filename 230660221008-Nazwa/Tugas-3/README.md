# Aplikasi Pengaduan Fasilitas Kampus

**Domain SI:** Pengaduan Fasilitas

**Deskripsi Halaman:**
Halaman utama aplikasi ini berfungsi sebagai dasbor awal bagi pengguna untuk melihat daftar keluhan fasilitas kampus yang sudah masuk. Halaman ini dirancang menggunakan tata letak `Column` untuk memisahkan judul utama dan daftar laporan, serta menggunakan `ListView.builder` untuk menampilkan susunan berbasis kartu (`Card`). Di dalam setiap kartu tersebut, tata letak `Row` dimanfaatkan untuk menyandingkan rincian nama fasilitas dengan status kerusakannya agar informasi lebih padat dan mudah dibaca secara cepat.

**Refleksi:**
Widget layout yang paling sulit saya rangkai adalah `Row` ketika disisipkan ke dalam susunan `Card`, karena saya sempat kesulitan memikirkan bagaimana caranya agar teks kategori dan teks status bisa saling berjauhan rata di ujung kiri dan kanan. Selain itu, penggunaan `Expanded` sebagai pembungkus `ListView.builder` juga awalnya cukup membingungkan karena jika terlupa ditambahkan, layar aplikasinya langsung mengalami *error overflow* akibat kehabisan batasan ruang. Namun setelah mempraktikkannya secara langsung, saya menjadi paham bahwa kombinasi *layout* tersebut sangat penting agar daftar keluhan yang panjang dapat digulir (*scroll*) dengan aman tanpa merusak struktur antarmuka utama.
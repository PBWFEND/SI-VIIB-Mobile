# Tugas 3: Halaman Aplikasi Sederhana

**Nama**: Adrian Nugraha  
**NIM**: 230660221087  
**Kelas**: SI-VIIB  
**Domain SI**: Sistem Informasi Kepegawaian Puskesmas Berbasis Mobile  

## Deskripsi Halaman
Halaman ini adalah "Dasbor Kepegawaian" yang berfungsi sebagai tampilan utama (beranda) dari aplikasi Sistem Informasi Kepegawaian Puskesmas. Halaman ini dirancang untuk menampilkan status kehadiran pegawai secara seketika (*real-time*). Struktur tata letak dibangun menggunakan `Column` untuk membagi area *header* sapaan dan daftar kehadiran, `Padding` dan `Row` untuk mengatur posisi judul serta ikon kalender agar rapi, serta `ListView.builder` (yang dibungkus dalam `Expanded`) untuk me-*render* daftar status pegawai secara efisien tanpa mengalami *overflow* pada layar.

## Refleksi
Widget layout yang paling sulit saya rangkai adalah `ListView.builder` saat ditempatkan di dalam sebuah `Column`. Awalnya saya menaruhnya secara langsung sehingga memunculkan galat *RenderFlex overflowed* di layar terminal, karena `Column` tidak memberikan batas tinggi maksimum bagi `ListView`. Setelah saya pelajari kembali, barulah saya menyadari bahwa saya wajib membungkus `ListView.builder` tersebut dengan widget `Expanded` agar daftar tersebut hanya memakan sisa ruang kosong yang tersedia secara dinamis.

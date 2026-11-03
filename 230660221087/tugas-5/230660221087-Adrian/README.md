# Tugas 5: Prototype UI/UX

**Nama**: Adrian Nugraha  
**NIM**: 230660221087  
**Kelas**: SI-VIIB  

## Deskripsi Tugas
Repositori ini memuat *Information Architecture*, gambar *wireframe*, implementasi layar utama di Flutter (menggunakan *Material 3 Theme*), dan Catatan Keputusan UI/UX untuk aplikasi Sistem Informasi Kepegawaian Puskesmas Berbasis Mobile.

## Refleksi
Bagian yang paling sulit dipertahankan konsistensinya adalah pemetaan antara anotasi fungsi pada *wireframe* dengan struktur widget di kode Flutter, khususnya saat merancang keadaan kosong (*empty state*). Awalnya di *wireframe* saya hanya berfokus menggambar daftar absensi terisi, sehingga saya terpaksa merancang ulang skema layarnya agar selaras dengan prinsip UI mobile yang mencegah pengguna kebingungan melihat layar putih *blank*. Selain itu, menyesuaikan palet warna terpusat menggunakan `ColorScheme.fromSeed` menuntut saya beradaptasi agar tidak menempelkan kode statis (seperti `Colors.green`) secara acak di setiap *widget*.

## Deklarasi penggunaan AI
Deklarasi penggunaan AI: AI *Assistant* — membantu menguraikan format tabel Keputusan UI/UX serta memberikan referensi implementasi widget `Chip` yang terhubung dengan `ThemeData` Flutter; hasilnya dipahami, diubah penamaannya, dan diimplementasikan secara mandiri oleh penulis sesuai konteks absensi puskesmas.

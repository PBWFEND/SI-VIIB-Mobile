# Tugas 7: MVP Awal dengan Data Lokal (CRUD)

**Nama**: Adrian Nugraha  
**NIM**: 230660221087  
**Kelas**: SI-VIIB  

## Deskripsi Tugas
Repositori ini memuat implementasi *Minimum Viable Product* (MVP) untuk aplikasi Sistem Informasi Kepegawaian Puskesmas. Terdiri dari deklarasi *Model Data*, manajemen state lokal dengan `StatefulWidget`, serta operasi lengkap CRUD (*Create, Read, Update, Delete*) In-Memory melalui perantara List yang diikat ke tampilan UI menggunakan `setState`. 

## Refleksi
Bagian yang paling sulit dipertahankan konsistensinya adalah mengelola *state* daftar absensi saat berpindah layar tanpa bergantung pada *state management* eksternal. Saya harus memastikan pengembalian data dari halaman *form* ditangkap dengan kombinasi `await Navigator.pushNamed()` dan dimasukkan ke dalam blok `setState()` agar antarmuka utama langsung diperbarui. Hal ini menuntut kehati-hatian ekstra agar siklus sinkronisasi antara aksi pengguna di layar anak dan pembaruan struktur List di layar induk tidak terputus.

## Deklarasi penggunaan AI
Deklarasi penggunaan AI: AI *Assistant* — digunakan untuk membantu menstrukturkan file *Markdown* dan memberi rekomendasi sintaks *toggle string* sederhana pada saat melakukan operasi *Update* status; pola operasi *Update* beserta referensi *indexWhere* diadopsi dan diimplementasikan secara mandiri oleh penulis.

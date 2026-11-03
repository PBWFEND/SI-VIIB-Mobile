# Tugas 6: Navigation Flow dan Interaksi

**Nama**: Adrian Nugraha  
**NIM**: 230660221087  
**Kelas**: SI-VIIB  

## Deskripsi Tugas
Repositori ini memuat rancangan alur navigasi (*Navigation Flow*), diagram alur Mermaid, implementasi pengiriman data antarlayar (argument), validasi *Form*, `dispose` untuk mencegah *memory leak*, dan manajemen umpan balik interaksi pengguna melalui API Navigator bawaan Flutter untuk aplikasi Sistem Informasi Kepegawaian Puskesmas.

## Refleksi
Bagian yang paling sulit dipertahankan konsistensinya adalah sinkronisasi antara nama *route* pada dokumen diagram Mermaid dengan deklarasi `routes` di dalam struktur `MaterialApp` Flutter. Kesalahan sekecil apa pun dalam penulisan *case-sensitive* (seperti `/Form` alih-alih `/form`) akan mengakibatkan pesan *error "Could not find a generator for route"* saat tombol ditekan. Oleh karena itu, membiasakan diri menjadikan `navigation-flow.md` sebagai sumber kebenaran tunggal (*Single Source of Truth*) sangat vital sebelum menyentuh kode sama sekali.

## Deklarasi penggunaan AI
Deklarasi penggunaan AI: AI *Assistant* — digunakan untuk membantu menyusun kerangka *Markdown* tabel keputusan dan memvalidasi penggunaan blok *try-catch null fallback* pada penerimaan *arguments*; hasilnya dipahami dan diadaptasi ulang oleh penulis ke dalam bentuk pengecekan tipe statis (`is`) sesuai anjuran modul praktikum.

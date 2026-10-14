# Tugas 5 — Prototype UI/UX

## Identitas
- **Nama:** Ghatan Zalfaa Kautsar
- **NIM:** 230660221001
- **Mata Kuliah:** Pemrograman Aplikasi Bergerak (PAB)
- **Pertemuan:** 5
- **Domain:** Sistem Penjualan Beras di Pabrik BSM

## Deskripsi Tugas
Tugas ini berisi prototype UI/UX untuk aplikasi Sistem Penjualan Beras BSM, mencakup information architecture (inventaris layar + diagram), wireframe low-fidelity, implementasi layar utama Flutter (Katalog Beras), tangkapan layar, dan catatan keputusan UI/UX. Layar utama yang diimplementasikan memenuhi kebutuhan F-01 (melihat daftar beras) dan menjadi titik masuk ke F-02 (tambah ke keranjang).

## Berkas
- `information-architecture.md` — Inventaris layar dan peta IA
- `wireframe.png` — Wireframe low-fidelity (2 layar)
- `halaman-utama.dart` — Implementasi Flutter layar utama
- `screenshot-halaman.png` — Tangkapan layar hasil
- `catatan-keputusan-ui.md` — Keputusan desain beserta alasan
- `README.md` — Berkas ini

## Refleksi
Bagian yang paling sulit saya pertahankan konsistensinya adalah antara **wireframe dan kode Flutter**, karena setiap area pada wireframe harus dapat ditelusuri kembali ke widget tertentu dan kebutuhan spesifik — bila saya menambahkan widget di luar wireframe, saya harus kembali dan memperbarui rancangan agar tetap konsisten. Saya juga sempat tergoda menuliskan warna langsung di setiap widget, namun prinsip tema terpusat memaksa saya menurunkan semua warna dari `ColorScheme.fromSeed` yang sama. Setelah menyelesaikannya, saya memahami bahwa catatan keputusan UI/UX berfungsi sebagai jembatan yang menjaga konsistensi antara analisis, rancangan, dan implementasi.

## Deklarasi Penggunaan AI
```text
Deklarasi penggunaan AI: Claude — membantu menyusun kerangka IA, memeriksa
penerapan prinsip UI mobile pada wireframe, dan membantu menerjemahkan
wireframe ke widget Flutter; keputusan akhir dan implementasi dirumuskan
ulang dan diverifikasi oleh penulis.
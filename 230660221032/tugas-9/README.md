# Tugas 9: Integrasi REST API (HTTP GET & POST)

**Nama**  : Deyna Angeliawati Zahara  
**NPM**   : 230660221032  
**Kelas** : SI VII B  

## 1. Deskripsi Singkat Tugas 9
Tugas 9 merupakan lanjutan pengembangan aplikasi **RadiAct (UNSAP Radio)** pada mata kuliah Pemrograman Aplikasi Bergerak. Pada tahap ini, aplikasi dihubungkan dengan layanan REST API menggunakan paket `http` untuk mengambil daftar jadwal (`HTTP GET`), mengirim jadwal baru (`HTTP POST`), melakukan konversi JSON, serta menangani kondisi antarmuka (*loading*, *sukses*, dan *error*).

## 2. Komponen Tugas (Hasil)
- **[service-api.dart](./service-api.dart)** — Mengatur struktur data jadwal (`DataJadwal`), menerjemahkan data JSON dari server, serta menjalankan pengambilan (`GET`) dan pengiriman (`POST`) data ke API.
- **[halaman-api.dart](./halaman-api.dart)** — Antarmuka utama dan formulir tambah jadwal dengan pengelolaan state *loading*, *sukses*, serta *error*.
- **[catatan-integrasi-api.md](./catatan-integrasi-api.md)** — Catatan teknis mengenai endpoint, struktur model data JSON, dan penanganan error.
- **Bukti Tangkapan Layar Aplikasi:**
  - `screenshot-loading.png` — Tampilan indikator loading saat memuat data dari server.
  - `screenshot-sukses.png` — Tampilan daftar jadwal yang berhasil dimuat dari REST API.
  - `screenshot-error.png` — Tampilan pesan error beserta tombol **Coba Lagi** saat koneksi/endpoint gagal.

## 3. Deklarasi Penggunaan AI dan Refleksi
Dalam pengerjaan Tugas 9 ini, saya memanfaatkan bantuan AI (Gemini) sebagai rekan diskusi untuk membantu memecahkan error kode dan memperjelas konsep kerja REST API, sementara penyusunan struktur proyek dan pengujian langsung tetap dilakukan mandiri.

Dari tahapan ini, saya jadi paham cara kerja API sebagai penghubung pertukaran data di balik layar agar aplikasi bisa berkomunikasi dengan server, termasuk cara mengelola tampilan saat data sedang dimuat maupun ketika terjadi gangguan koneksi.

## 4. Struktur Folder
```text
tugas-9/
├── catatan-integrasi-api.md
├── halaman-api.dart
├── README.md
├── screenshot-error.png
├── screenshot-loading.png
├── screenshot-sukses.png
└── service-api.dart
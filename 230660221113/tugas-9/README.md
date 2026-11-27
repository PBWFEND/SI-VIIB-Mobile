# Tugas 9 — Integrasi REST API FasKampus

## Identitas Mahasiswa

| Keterangan | Identitas |
|---|---|
| Nama | Muhammad Andre Nugraha |
| NIM | 230660221113 |
| Program Studi | Sistem Informasi |
| Fakultas | Fakultas Teknologi Informasi |
| Universitas | Universitas Sebelas April Sumedang |
| Mata Kuliah | Pemrograman Aplikasi Bergerak |
| Kelas | SI-VIIB |
| Dosen Pengampu | Bapak Agun Guntara |

## Deskripsi Tugas

Tugas 9 merupakan pengembangan aplikasi FasKampus dengan menerapkan integrasi REST API menggunakan Flutter dan Dart.

Pada tugas ini, aplikasi menggunakan API JSONPlaceholder untuk mempraktikkan proses pengambilan data menggunakan HTTP GET dan pengiriman data menggunakan HTTP POST.

Aplikasi juga dilengkapi dengan indikator loading, tampilan data berhasil dimuat, serta pesan error dan tombol coba lagi apabila proses pengambilan data mengalami kegagalan.

## Struktur Folder

```text
tugas-9/
├── service_api.dart
├── halaman_api.dart
├── screenshot-loading.png
├── screenshot-sukses.png
├── screenshot-error.png
├── catatan-integrasi-api.md
└── README.md
```

## Fitur yang Dikerjakan

1. **HTTP GET** — Mengambil daftar data dari JSONPlaceholder.
2. **HTTP POST** — Mengirim data pengajuan fasilitas melalui form.
3. **Loading State** — Menampilkan indikator ketika aplikasi sedang mengambil data dari server.
4. **Success State** — Menampilkan daftar data setelah berhasil diterima dari API.
5. **Error State** — Menampilkan pesan kegagalan dan tombol untuk mencoba mengambil data kembali.
6. **Form Pengajuan** — Mengirim data fasilitas, tanggal, waktu, dan tujuan kegiatan.

## Dokumentasi Screenshot

| Nama File | Keterangan |
|---|---|
| `screenshot-loading.png` | Tampilan indikator loading ketika mengambil data dari API. |
| `screenshot-sukses.png` | Tampilan daftar data setelah berhasil dimuat dari API. |
| `screenshot-error.png` | Tampilan pesan error ketika aplikasi gagal mengambil data dari server. |

## Refleksi

Melalui tugas ini, saya mempelajari cara menghubungkan aplikasi Flutter dengan REST API menggunakan HTTP GET dan POST. Saya juga memahami bahwa proses pengambilan data perlu dilengkapi dengan kondisi loading, berhasil, dan error agar pengguna mendapatkan informasi yang jelas. Dari pengerjaan ini, saya menjadi lebih memahami cara mengolah data JSON dan menerapkannya dalam aplikasi FasKampus.

## Deklarasi Penggunaan AI

Dalam pengerjaan tugas ini, saya menggunakan ChatGPT sebagai alat bantu untuk memahami konsep integrasi REST API, membantu menyusun dan memeriksa kode program, serta merapikan dokumentasi tugas. Seluruh kode dan hasil pengerjaan tetap saya periksa, jalankan, dan sesuaikan kembali dengan kebutuhan aplikasi FasKampus. Pengujian aplikasi dan pengambilan screenshot dilakukan secara langsung oleh saya.


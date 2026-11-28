# Dokumentasi Perangkat dan Fitur PustakaKu

## 1. Nama Fitur

Pemilihan Foto Sampul Buku dari Galeri Perangkat.

## 2. Deskripsi Fitur

Fitur ini digunakan untuk memilih foto sampul buku dari perangkat pengguna melalui galeri atau file picker browser. Foto yang dipilih akan digunakan sebagai sampul buku dan ditampilkan pada kartu katalog serta halaman detail buku.

Fitur dikembangkan menggunakan package `image_picker` dan penyimpanan lokal IndexedDB melalui Sembast Web.

## 3. Aktor

Admin atau pengelola perpustakaan yang memiliki akses untuk mengelola data buku pada aplikasi PustakaKu.

## 4. Tujuan Fitur

1. Memudahkan admin menambahkan foto sampul buku.
2. Memudahkan admin mengganti foto sampul buku.
3. Membuat tampilan katalog buku lebih informatif.
4. Menyimpan foto agar tetap tersedia setelah halaman browser dimuat ulang.

## 5. Data Masukan

Data yang digunakan dalam fitur ini adalah:
- Foto sampul buku yang dipilih dari perangkat.
- ID buku sebagai identitas penyimpanan foto.

## 6. Data Keluaran

- File gambar yang telah dipilih.
- Data gambar dalam bentuk bytes.
- Foto sampul yang ditampilkan pada katalog buku.
- Foto sampul yang ditampilkan pada halaman detail buku.

## 7. Package yang Digunakan

| Package | Fungsi |
|---|---|
| `image_picker` | Mengambil atau memilih gambar dari galeri perangkat |
| `sembast` | Mengelola penyimpanan data lokal |
| `sembast_web` | Menghubungkan Sembast dengan IndexedDB pada Flutter Web |

## 8. Izin Akses Perangkat

Fitur menggunakan file picker browser untuk memilih gambar dari perangkat.

Pada platform Google Chrome, pemilihan gambar dilakukan melalui jendela pemilihan file yang disediakan browser. Pengguna menentukan sendiri gambar yang akan digunakan.

Fitur kamera langsung tidak digunakan dalam implementasi ini.

## 9. Platform Target

| Aspek | Keterangan |
|---|---|
| Framework | Flutter |
| Bahasa Pemrograman | Dart |
| Platform | Flutter Web |
| Browser Pengujian | Google Chrome |
| Fitur Perangkat | Pemilihan foto dari galeri |
| Media Penyimpanan | IndexedDB |

## 10. Alur Kerja Fitur

1. Admin membuka halaman katalog buku.
2. Admin memilih buku yang akan ditambahkan atau diganti foto sampulnya.
3. Admin menekan ikon tambah foto.
4. Browser menampilkan file picker.
5. Admin memilih foto dari perangkat.
6. Aplikasi membaca file gambar menjadi bytes.
7. Foto disimpan ke IndexedDB berdasarkan ID buku.
8. Aplikasi memperbarui tampilan katalog.
9. Foto juga dapat ditampilkan pada halaman detail buku.

## 11. Penanganan Kondisi

| Kondisi | Perilaku Aplikasi |
|---|---|
| Foto berhasil dipilih | Foto dibaca dan disimpan ke IndexedDB |
| Pengguna membatalkan pemilihan | Proses dihentikan tanpa menyimpan foto baru |
| Gagal membaca atau menyimpan foto | Aplikasi menampilkan pesan kegagalan |
| Foto berhasil disimpan | Aplikasi menampilkan pesan keberhasilan |

## 12. Penyimpanan Data

Foto sampul buku disimpan menggunakan IndexedDB melalui Sembast Web. Setiap foto disimpan berdasarkan ID buku sehingga dapat dikaitkan dengan data buku yang sesuai.

Penyimpanan bersifat lokal pada browser dan origin yang digunakan. Data dapat tetap tersedia setelah halaman dimuat ulang selama penyimpanan browser tidak dihapus.

## 13. Batasan Fitur

1. Pemilihan gambar dilakukan melalui file picker browser.
2. Fitur kamera langsung tidak diimplementasikan.
3. Data tersimpan secara lokal pada browser.
4. Data tidak otomatis tersinkronisasi ke perangkat lain.
5. Pengujian fitur dilakukan menggunakan Google Chrome.

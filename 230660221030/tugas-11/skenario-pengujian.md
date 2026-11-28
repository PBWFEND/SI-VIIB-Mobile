# Skenario Pengujian Fitur Perangkat PustakaKu

## 1. Tujuan Pengujian

Pengujian dilakukan untuk memastikan fitur pemilihan foto sampul buku dari galeri perangkat menggunakan `image_picker` dapat berjalan dengan baik, terintegrasi dengan katalog dan halaman detail buku, serta mampu menangani kondisi pemilihan dan pembatalan foto. Pengujian juga dilakukan untuk memastikan foto dan data buku dapat tersimpan menggunakan IndexedDB.

## 2. Skenario Pengujian

| No. | Skenario | Hasil yang Diharapkan | Hasil |
|---|---|---|---|
| 1 | Membuka halaman Katalog Buku | Halaman katalog tampil dengan normal | Berhasil |
| 2 | Memilih foto dari galeri | Foto terpilih dan ditampilkan pada kartu buku | Berhasil |
| 3 | Membatalkan pemilihan foto | Aplikasi tetap berjalan normal dan tidak menyimpan foto baru | Berhasil |
| 4 | Mengganti foto sampul buku | Foto lama berhasil diganti dengan foto baru | Berhasil |
| 5 | Membuka Detail Buku | Foto sampul dan informasi buku tampil pada halaman detail | Berhasil |
| 6 | Melakukan refresh halaman Chrome | Foto sampul tetap tersimpan dan ditampilkan | Berhasil |
| 7 | Menambahkan buku baru | Data buku berhasil ditambahkan dan tampil pada katalog | Berhasil |
| 8 | Melakukan refresh setelah menambahkan buku | Data buku tetap tersedia setelah halaman dimuat ulang | Berhasil |

## 3. Hasil Pengujian

Berdasarkan pengujian yang dilakukan pada aplikasi PustakaKu menggunakan Google Chrome, fitur pemilihan foto sampul buku berhasil dijalankan. Pengguna dapat memilih foto dari galeri, membatalkan pemilihan, mengganti foto sampul, serta melihat foto pada katalog dan halaman detail buku.

Selain itu, data foto dan buku berhasil disimpan menggunakan IndexedDB sehingga tetap tersedia setelah halaman Chrome dimuat ulang. Fitur penambahan buku juga dapat digunakan untuk memasukkan data buku baru ke dalam katalog.

Hasil pengujian menunjukkan bahwa fitur perangkat berupa pemilihan foto dari galeri telah terintegrasi dengan pengelolaan katalog buku pada aplikasi PustakaKu.

## 4. Platform Pengujian

| Aspek | Keterangan |
|---|---|
| Aplikasi | PustakaKu |
| Platform | Flutter Web |
| Browser | Google Chrome |
| Fitur yang diuji | Pemilihan foto dari galeri perangkat |
| Penyimpanan | IndexedDB |
| Status pengujian | Berhasil |

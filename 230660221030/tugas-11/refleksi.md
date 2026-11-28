
# Refleksi Pengembangan Fitur Perangkat PustakaKu

## 1. Pengalaman Pengembangan

Pada Tugas 11, saya mengembangkan fitur pemilihan foto sampul buku dari galeri perangkat pada aplikasi PustakaKu menggunakan Flutter. Fitur ini dibuat agar pengguna dapat menambahkan dan mengganti foto sampul buku sehingga tampilan katalog menjadi lebih informatif.

Dalam proses pengembangan, saya menggunakan package `image_picker` untuk memilih foto dari galeri serta Sembast Web dan IndexedDB untuk menyimpan foto dan data buku secara lokal pada browser.

Saya juga mengembangkan fitur penambahan buku baru melalui formulir yang berisi judul, penulis, deskripsi, dan stok buku. Foto sampul yang dipilih dapat ditampilkan pada kartu katalog maupun halaman detail buku.

## 2. Kendala yang Dihadapi

Selama proses pengembangan, terdapat beberapa kendala yang dihadapi, yaitu:

1. Memahami cara mengintegrasikan package `image_picker` ke dalam aplikasi Flutter.
2. Menyesuaikan penggunaan fitur pemilihan foto dengan platform Flutter Web.
3. Memahami proses membaca file gambar menjadi bytes agar dapat disimpan ke IndexedDB.
4. Menghubungkan penyimpanan foto dengan data buku berdasarkan ID buku.
5. Menyesuaikan kode agar data buku dan foto tetap tersedia setelah halaman browser dimuat ulang.
6. Memperbaiki kesalahan kode yang muncul selama proses implementasi.

Kendala tersebut diselesaikan secara bertahap melalui pemeriksaan kode, analisis menggunakan `flutter analyze`, dan pengujian langsung pada Google Chrome.

## 3. Pembelajaran yang Diperoleh

Melalui tugas ini, saya memperoleh pemahaman mengenai integrasi fitur perangkat pada aplikasi Flutter, khususnya pemilihan gambar dari galeri.

Saya juga mempelajari penggunaan pemrograman asynchronous dengan `Future` dan `async/await`, penanganan kondisi ketika pengguna membatalkan pemilihan gambar, serta penggunaan IndexedDB untuk penyimpanan data secara lokal pada browser.

Selain itu, saya memahami bahwa pengembangan aplikasi tidak hanya berfokus pada tampilan dan fungsi, tetapi juga perlu memperhatikan penyimpanan data, penanganan kesalahan, dan pengujian fitur.

## 4. Kesimpulan

Berdasarkan proses pengembangan dan pengujian, fitur pemilihan foto sampul buku dari galeri berhasil diintegrasikan ke dalam aplikasi PustakaKu. Foto dapat ditampilkan pada katalog dan halaman detail buku, diganti, serta tetap tersedia setelah halaman Google Chrome dimuat ulang.

Pengembangan ini memberikan pengalaman dalam mengintegrasikan fitur perangkat, mengelola data lokal, dan menyelesaikan kendala selama proses pembuatan aplikasi Flutter.

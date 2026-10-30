# Catatan Keputusan Navigasi dan Interaksi PustakaKu

## 1. Tujuan

Catatan ini menjelaskan keputusan navigasi dan interaksi yang diterapkan pada aplikasi PustakaKu dalam pengerjaan Tugas 6. Perancangan dilakukan agar pengguna dapat melihat katalog buku, membaca detail buku, mengisi form peminjaman, dan melihat data peminjaman yang telah dikirim.

## 2. Keputusan Navigasi dan Interaksi

| No. | Aspek | Keputusan | Alasan |
|---|---|---|---|
| 1 | Halaman awal | Menggunakan route `/` untuk halaman Katalog Buku. | Katalog menjadi halaman utama karena pengguna perlu melihat daftar buku sebelum melakukan peminjaman. |
| 2 | Navigasi detail buku | Menggunakan `Navigator.pushNamed()` dengan route `/detail`. | Pengguna dapat membuka informasi buku yang dipilih tanpa kehilangan halaman katalog. |
| 3 | Pengiriman data buku | Mengirim objek `Buku` melalui parameter `arguments`. | Halaman detail dapat menampilkan informasi sesuai buku yang dipilih, bukan data yang ditentukan secara tetap. |
| 4 | Navigasi form peminjaman | Menggunakan route `/form` yang dapat diakses dari katalog maupun halaman detail buku. | Pengguna dapat mengajukan peminjaman melalui tombol pada katalog atau tombol pada detail buku. |
| 5 | Pengecekan arguments | Memeriksa data menggunakan `is Buku` dan menyediakan kondisi ketika arguments bernilai `null` atau memiliki tipe yang tidak sesuai. | Menghindari kesalahan ketika halaman detail menerima data yang tidak sesuai. |
| 6 | Validasi form | Menggunakan `GlobalKey<FormState>` dan validator pada kolom Nama Peminjam, NIM, dan Judul Buku. | Memastikan setiap kolom wajib diisi sebelum data peminjaman dikirim. |
| 7 | Pengelolaan controller | Menggunakan `TextEditingController` pada setiap kolom dan membersihkannya melalui `dispose()`. | Mengelola input pengguna dan menghindari penggunaan controller yang tidak diperlukan setelah halaman ditutup. |
| 8 | Penyimpanan data | Menggunakan `ValueNotifier<List<Peminjaman>>` untuk menyimpan data peminjaman sementara. | Data yang dikirim dapat langsung ditampilkan pada halaman Daftar Peminjaman tanpa menggunakan database. |
| 9 | Halaman daftar peminjaman | Menggunakan route `/daftar-peminjaman` dan menampilkan data dalam bentuk card. | Memudahkan pengguna melihat informasi nama, NIM, judul buku, tanggal, dan status peminjaman. |
| 10 | Feedback setelah pengiriman | Menampilkan SnackBar setelah data berhasil ditambahkan ke daftar peminjaman. | Memberikan informasi kepada pengguna bahwa data peminjaman berhasil ditambahkan. |

## 3. Alasan Pemilihan Alur Navigasi

Halaman Katalog Buku dipilih sebagai halaman awal (`initialRoute`) karena menjadi titik utama pengguna dalam mencari dan memilih buku. Dari halaman tersebut, pengguna dapat membuka Detail Buku atau langsung menuju Form Peminjaman.

Halaman Detail Buku digunakan untuk menampilkan informasi buku yang dipilih melalui pengiriman arguments. Selanjutnya, pengguna dapat menuju Form Peminjaman apabila buku masih tersedia.

Setelah form diisi dengan benar dan dikirim, data peminjaman ditambahkan ke dalam daftar sementara menggunakan `ValueNotifier`. Aplikasi kemudian mengarahkan pengguna ke halaman Daftar Peminjaman agar data yang telah dimasukkan dapat dilihat dalam bentuk card.

## 4. Keputusan Validasi dan Feedback

Validasi diterapkan pada ketiga kolom form, yaitu Nama Peminjam, NIM, dan Judul Buku. Apabila terdapat kolom yang belum diisi atau tidak memenuhi ketentuan, aplikasi akan menampilkan pesan validasi sehingga pengguna dapat memperbaiki input terlebih dahulu.

Setelah seluruh data memenuhi validasi, aplikasi menambahkan data ke daftar peminjaman dan menampilkan SnackBar sebagai feedback. Setiap data peminjaman juga memiliki tombol Detail untuk melihat informasi lebih lengkap.

## 5. Kesesuaian dengan Information Architecture

Implementasi navigasi dan interaksi disesuaikan dengan struktur halaman aplikasi PustakaKu yang telah dirancang sebelumnya. Setiap halaman memiliki fungsi masing-masing, mulai dari pencarian buku hingga penampilan data peminjaman.

Penggunaan named routes membantu menjaga konsistensi perpindahan halaman, sedangkan pengiriman arguments memastikan informasi buku dapat diteruskan ke halaman yang membutuhkan. Dengan demikian, alur navigasi, implementasi kode, dan kebutuhan pengguna tetap saling berkaitan.

## 6. Catatan Implementasi

Data peminjaman pada aplikasi ini masih disimpan sementara menggunakan `ValueNotifier` dan belum menggunakan database. Data hanya tersedia selama aplikasi berjalan dan akan hilang apabila aplikasi ditutup atau dimuat ulang. Status peminjaman **Diproses** merupakan status simulasi untuk kebutuhan demonstrasi interaksi aplikasi.
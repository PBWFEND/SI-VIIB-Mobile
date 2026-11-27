# Quiz Pertemuan 10 --- Integrasi Data dan Proses Bisnis Sistem Informasi

**Mata Kuliah:** Pemrograman Aplikasi Bergerak\
**Pertemuan:** 10\
**CPMK:** CPMK-3

## Jawaban Soal 1 --- Integrasi Data

Integrasi data pada aplikasi mobile adalah proses menggabungkan data
dari beberapa sumber atau endpoint agar menjadi satu informasi yang
saling berhubungan dan dapat digunakan oleh aplikasi.

Contohnya pada project FasKampus, aplikasi mengambil data pengguna dari
endpoint `/users` dan data pengajuan dari endpoint `/posts` pada
JSONPlaceholder. Kedua data tersebut kemudian digabungkan agar informasi
pengajuan dapat menampilkan nama dan email pemohon.

Identifier yang digunakan adalah `id` pada data pengguna dan `userId`
pada data pengajuan. Kedua field tersebut digunakan untuk mencocokkan
siapa pemilik atau pembuat pengajuan.

## Jawaban Soal 2 --- `Future.wait`

`Future.wait` digunakan ketika aplikasi perlu menjalankan beberapa
request secara bersamaan dan request tersebut tidak saling bergantung.
Contohnya pada FasKampus, pengambilan data pengguna dari `/users` dan
data pengajuan dari `/posts` dapat dilakukan secara bersamaan karena
masing-masing endpoint bisa diakses tanpa menunggu hasil endpoint
lainnya.

Dengan `Future.wait`, waktu tunggu bisa lebih efisien dibandingkan
menjalankan request satu per satu.

Request harus dijalankan secara berurutan apabila request berikutnya
membutuhkan hasil dari request sebelumnya. Contohnya, aplikasi harus
mendapatkan ID pengguna terlebih dahulu sebelum menggunakan ID tersebut
untuk mengambil data pengajuan milik pengguna tertentu.

## Jawaban Soal 3 --- Model dan `fromJson`

Model `DataPengajuan` pada project FasKampus membutuhkan beberapa field,
yaitu:

-   `id`: ID dari pengajuan.
-   `userId`: ID pengguna yang membuat pengajuan.
-   `judul`: Judul pengajuan.
-   `deskripsi`: Keterangan atau isi pengajuan.
-   `status`: Status pengajuan.

Field `userId` penting karena digunakan untuk menghubungkan data
pengajuan dengan data pengguna melalui `id`.

Fungsi `fromJson` digunakan untuk mengubah data JSON dari API menjadi
objek Dart. Jika terdapat field yang tidak tersedia pada response,
aplikasi dapat memberikan nilai default agar proses pembacaan data tidak
langsung gagal.

Contohnya pada project saya, field `status` tidak tersedia pada response
JSONPlaceholder `/posts`, sehingga diberikan nilai default `'menunggu'`
menggunakan operator `??`.

## Jawaban Soal 4 --- Service Layer

Service layer bertanggung jawab untuk mengelola proses komunikasi dengan
API, seperti mengirim request HTTP, menerima response, mengubah JSON
menjadi model, menangani error, dan menggabungkan data dari beberapa
endpoint.

Sedangkan widget bertanggung jawab untuk menampilkan data kepada
pengguna, seperti daftar pengajuan, indikator loading, pesan error, dan
tombol untuk mencoba kembali.

Penggabungan data sebaiknya tidak ditulis langsung di dalam widget
karena akan membuat kode menjadi terlalu panjang dan sulit dikelola.
Dengan memisahkan service layer dan widget, kode menjadi lebih rapi,
mudah diperbaiki, serta proses pengambilan data dapat digunakan kembali.

Pada project FasKampus, proses tersebut dikerjakan di
`integrasi_service.dart`, sedangkan tampilannya dikelola oleh
`halaman_integrasi.dart`.

## Jawaban Soal 5 --- Status Halaman

Halaman integrasi data perlu menangani empat state utama, yaitu:

1.  **Loading**: Ditampilkan ketika aplikasi sedang mengambil data dari
    API. Biasanya menggunakan `CircularProgressIndicator`.
2.  **Data**: Ditampilkan ketika proses pengambilan data berhasil dan
    terdapat data yang bisa ditampilkan.
3.  **Empty**: Ditampilkan ketika request berhasil, tetapi tidak ada
    data yang ditemukan.
4.  **Error**: Ditampilkan ketika terjadi kegagalan, misalnya koneksi
    internet bermasalah, server tidak merespons, atau response API tidak
    sesuai format.

Kondisi data kosong harus dibedakan dari kondisi error karena keduanya
memiliki arti yang berbeda. Data kosong berarti request berhasil
dilakukan, tetapi hasilnya memang tidak memiliki data. Sementara itu,
error berarti aplikasi gagal mendapatkan atau memproses data.

Pembedaan ini penting agar pengguna mengetahui kondisi aplikasi dan
dapat menentukan tindakan yang tepat. Misalnya, pada kondisi error
pengguna dapat menekan tombol **Coba Lagi**, sedangkan pada kondisi data
kosong aplikasi cukup menampilkan informasi bahwa belum ada data
pengajuan.

------------------------------------------------------------------------

**Catatan:** Jawaban ini disesuaikan dengan implementasi FasKampus yang
menggunakan endpoint JSONPlaceholder `/users` dan `/posts`. Data
`/posts` merupakan data simulasi, bukan data pengajuan fasilitas kampus
yang sebenarnya.

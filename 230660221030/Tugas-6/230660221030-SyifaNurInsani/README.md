# Tugas 6 – Navigation Flow dan Interaksi PustakaKu

## Deskripsi Aplikasi

PustakaKu merupakan aplikasi katalog buku sederhana yang dikembangkan menggunakan Flutter. Pada Tugas 6, aplikasi ini dilengkapi dengan fitur navigasi antarhalaman dan interaksi form peminjaman buku.

Fitur yang dikembangkan meliputi:

- **Katalog Buku:** Menampilkan daftar buku beserta informasi ketersediaannya.
- **Detail Buku:** Menampilkan informasi buku yang dipilih dari katalog.
- **Form Peminjaman:** Menyediakan input nama peminjam, NIM, dan judul buku dengan validasi pada setiap kolom.
- **Daftar Peminjaman:** Menampilkan data peminjaman yang telah dikirim dalam bentuk card.
- **Detail Peminjaman:** Menampilkan informasi lengkap dari data peminjaman.
- **Feedback:** Menampilkan SnackBar setelah data peminjaman berhasil ditambahkan.

Navigasi aplikasi menggunakan named routes Flutter, yaitu `Navigator.pushNamed()` untuk berpindah halaman dan `Navigator.pop()` untuk kembali ke halaman sebelumnya. Data buku dikirim melalui arguments, sedangkan data peminjaman disimpan sementara menggunakan `ValueNotifier` selama aplikasi berjalan.

## Struktur File

```text
tugas-6/
└── nim-nama/
    ├── README.md
    ├── navigation-flow.md
    ├── form-interaksi.dart
    ├── screenshot-alur.png
    ├── screenshot-feedback.png
    └── catatan-keputusan-navigasi.md
```

## Refleksi

Hal yang paling menantang dalam pengerjaan Tugas 6 adalah memastikan alur navigasi pada diagram sesuai dengan implementasi kode dan catatan keputusan navigasi. Tantangan lainnya adalah mengatur pengiriman data antarhalaman agar informasi buku dan data peminjaman dapat ditampilkan dengan benar. Dari pengerjaan ini, saya memahami bahwa navigasi dan interaksi form perlu dirancang secara konsisten agar aplikasi dapat digunakan dengan lebih mudah.

## Deklarasi Penggunaan AI

Dalam pengerjaan tugas ini, saya menggunakan bantuan AI untuk memahami konsep navigasi Flutter, menyusun kode, serta memperbaiki implementasi interaksi form. Seluruh kode dan hasil pengerjaan tetap diperiksa dan disesuaikan dengan kebutuhan aplikasi PustakaKu.

# Refleksi Tugas 11 — Fitur Perangkat FasKampus

## 1. Pengalaman Pengerjaan

Pada Tugas 11 ini, saya mempelajari bagaimana mengintegrasikan fitur perangkat ke dalam aplikasi Flutter. Fitur yang saya pilih untuk aplikasi FasKampus adalah pemilihan dokumen menggunakan package `file_picker`.

Saya memilih fitur tersebut karena sesuai dengan kebutuhan aplikasi FasKampus. Dalam proses pengajuan peminjaman fasilitas kampus, pengguna perlu melampirkan surat izin atau proposal kegiatan. Dengan adanya fitur pemilihan dokumen, pengguna dapat mengambil berkas yang sudah tersedia di perangkat tanpa harus membuat dokumen baru melalui aplikasi.

## 2. Pemahaman yang Diperoleh

Dari pengerjaan tugas ini, saya memahami beberapa hal, yaitu:

1. Fitur perangkat sebaiknya dipilih berdasarkan kebutuhan aplikasi, bukan hanya untuk menambah tampilan atau fungsi.
2. Package `file_picker` dapat digunakan untuk membuka pemilih dokumen pada perangkat.
3. Hasil pemilihan dokumen dapat digunakan untuk memperoleh informasi seperti nama file, ekstensi, ukuran, dan data file jika tersedia.
4. Proses pemilihan dokumen dapat dibatalkan oleh pengguna, sehingga hasil `null` perlu ditangani sebagai pembatalan, bukan langsung dianggap sebagai error.
5. Pemisahan service dan widget membuat kode lebih terstruktur karena proses pemilihan dokumen tidak dicampur dengan kode tampilan.
6. Aplikasi perlu menangani kondisi loading, berhasil, pembatalan, dan kesalahan agar pengguna mendapatkan informasi yang jelas.

## 3. Alasan Pemilihan Fitur

Saya memilih fitur File Picker dibandingkan kamera karena kebutuhan utama FasKampus adalah melampirkan dokumen pendukung pengajuan.

Dokumen seperti surat izin dan proposal kegiatan biasanya sudah dibuat sebelumnya dan disimpan pada perangkat pengguna. Oleh karena itu, fitur pemilihan dokumen lebih sesuai dengan alur penggunaan aplikasi.

Fitur ini juga dapat dikembangkan lebih lanjut agar dokumen yang dipilih bisa dikirim bersama data pengajuan ke server.

## 4. Kendala dan Solusi

Beberapa hal yang perlu diperhatikan selama pengerjaan fitur ini adalah:

| Kendala | Solusi atau Penanganan |
|---|---|
| Memahami penggunaan package `file_picker` | Mempelajari fungsi `pickFiles()` dan hasil yang dikembalikan |
| Menangani hasil pemilihan yang kosong | Memeriksa apakah hasil pemilihan bernilai `null` |
| Menampilkan informasi dokumen | Menggunakan data dari objek `PlatformFile` |
| Menangani proses asynchronous | Menggunakan `async` dan `await` |
| Memisahkan proses dan tampilan | Membuat service khusus untuk pemilihan dokumen |
| Perbedaan dukungan antarplatform | Melakukan pengujian pada platform target, yaitu Android |

## 5. Evaluasi dan Pengembangan Selanjutnya

Menurut saya, fitur pemilihan dokumen dapat membantu proses pengajuan peminjaman fasilitas pada aplikasi FasKampus. Namun, implementasi ini masih memiliki beberapa keterbatasan karena berfokus pada pemilihan dan penampilan informasi dokumen.

Untuk pengembangan selanjutnya, beberapa hal yang dapat dilakukan adalah:

1. Menghubungkan dokumen yang dipilih dengan data pengajuan peminjaman fasilitas.
2. Menambahkan validasi ukuran dokumen.
3. Menyimpan dokumen pada server agar dapat diperiksa oleh pihak pengelola fasilitas.
4. Menampilkan status upload dokumen.
5. Menambahkan fitur untuk mengganti atau menghapus dokumen yang sudah dipilih.

## 6. Kesimpulan Pembelajaran

Melalui Tugas 11 ini, saya mendapatkan pemahaman bahwa penggunaan fitur perangkat dalam aplikasi harus memiliki tujuan yang jelas dan sesuai dengan kebutuhan pengguna.

Pemilihan dokumen menggunakan `file_picker` merupakan salah satu fitur yang mendukung proses bisnis FasKampus, khususnya ketika pengguna perlu melampirkan surat izin atau proposal kegiatan.

Saya juga memahami pentingnya penanganan kondisi pembatalan, loading, dan error agar aplikasi dapat digunakan dengan lebih baik.

## 7. Deklarasi Penggunaan AI

Dalam pengerjaan Tugas 11 ini, saya menggunakan ChatGPT sebagai alat bantu untuk memahami konsep fitur perangkat, menyusun struktur kode, membuat dokumentasi, dan menyiapkan skenario pengujian.

Hasil bantuan tersebut saya gunakan sebagai referensi dalam proses pengerjaan. Saya tetap bertanggung jawab untuk mempelajari, memeriksa, menyesuaikan, menjalankan, dan menguji implementasi agar sesuai dengan kebutuhan aplikasi FasKampus dan materi perkuliahan.
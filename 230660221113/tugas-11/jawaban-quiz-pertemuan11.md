# Jawaban Quiz Pertemuan 11 — Fitur Perangkat Sesuai Kebutuhan

**Mata Kuliah:** Pemrograman Aplikasi Bergerak  
**Pertemuan:** 11  
**CPMK:** CPMK-3  
**Nama:** Muhammad Andre Nugraha  
**Program Studi:** Sistem Informasi  

---

## Soal 1 — Pemilihan Fitur

Dalam memilih fitur perangkat, saya mempertimbangkan kebutuhan pengguna dan proses bisnis yang berjalan di dalam aplikasi. Fitur yang dipilih harus benar-benar membantu pengguna menyelesaikan pekerjaannya, bukan hanya sekadar menambahkan teknologi ke dalam aplikasi.

Pada proyek **FasKampus**, saya memilih fitur pemilihan file atau *file picker*. Fitur ini digunakan untuk membantu pengguna melampirkan dokumen persyaratan, seperti surat izin kegiatan atau proposal ketika mengajukan peminjaman fasilitas kampus.

Alasan memilih fitur tersebut adalah karena dalam proses pengajuan peminjaman fasilitas, pengguna perlu menyertakan dokumen pendukung. Dengan adanya file picker, pengguna dapat mengambil dokumen yang sudah tersedia di perangkat tanpa harus membuat dokumen baru atau menggunakan kamera untuk memotretnya.

Jadi, fitur ini dipilih karena sesuai dengan kebutuhan pengguna dan mendukung proses pengajuan peminjaman fasilitas di FasKampus.

## Soal 2 — Permission

Permission merupakan izin yang diperlukan aplikasi untuk mengakses fitur atau sumber daya tertentu pada perangkat pengguna. Permission diperlukan untuk menjaga keamanan dan privasi pengguna agar aplikasi tidak mengakses data atau fitur perangkat tanpa persetujuan.

Ketika aplikasi menggunakan fitur perangkat, ada beberapa kondisi yang harus ditangani:

1. **Permission diberikan:** Aplikasi dapat melanjutkan proses menggunakan fitur perangkat sesuai izin yang diberikan.
2. **Permission ditolak:** Aplikasi harus memberikan informasi kepada pengguna bahwa izin belum diberikan dan menjelaskan fungsi izin tersebut.
3. **Permission tidak tersedia:** Aplikasi harus menampilkan pesan bahwa fitur atau akses yang dibutuhkan tidak tersedia, kemudian memberikan alternatif jika memungkinkan.

Pada FasKampus, fitur yang digunakan adalah file picker untuk memilih dokumen. Pada beberapa platform, pemilihan file melalui pemilih dokumen bawaan sistem tidak memerlukan permission penyimpanan secara luas karena pengguna sendiri yang menentukan file yang akan dipilih. Namun, aplikasi tetap harus menangani kemungkinan akses gagal atau fitur tidak tersedia.

## Soal 3 — Pembatalan Pemilihan

Nilai `XFile?` yang bernilai `null` berarti pengguna membatalkan proses pemilihan gambar atau tidak memilih gambar apa pun.

Tanda `?` pada `XFile?` menunjukkan bahwa variabel tersebut dapat berisi objek `XFile` atau nilai `null`.

Aplikasi harus menangani kondisi tersebut agar tidak terjadi error ketika hasil pemilihan gambar tidak tersedia. Jika pengguna membatalkan pemilihan, aplikasi sebaiknya tetap berada pada halaman sebelumnya, mempertahankan data yang sudah diisi, dan tidak menampilkan pesan bahwa gambar berhasil dipilih.

Contoh penanganan:

```dart
final XFile? gambar = await ImagePicker().pickImage(
  source: ImageSource.gallery,
);

if (gambar == null) {
  // Pengguna membatalkan pemilihan gambar.
  return;
}

// Gambar berhasil dipilih.
```

Pada proyek FasKampus, saya menggunakan package `file_picker`, bukan `image_picker`. Konsep pembatalannya sama, yaitu hasil pemilihan file yang bernilai `null` berarti pengguna membatalkan pemilihan dokumen.

## Soal 4 — Service Layer

Service layer merupakan bagian aplikasi yang bertanggung jawab mengelola proses penggunaan fitur tertentu, seperti pemanggilan package, akses fitur perangkat, dan penanganan hasil maupun kesalahan.

Pada FasKampus, service layer dapat digunakan untuk memisahkan proses pemilihan dokumen dari tampilan form pengajuan. Misalnya, proses pemilihan dokumen PDF, DOC, dan DOCX dikelola melalui `LampiranService`.

Pemanggilan package dan pengelolaan fitur perangkat sebaiknya tidak seluruhnya ditulis langsung di dalam widget karena beberapa alasan:

1. **Memisahkan tanggung jawab:** Widget berfokus pada tampilan dan interaksi pengguna, sedangkan service mengelola proses fitur perangkat.
2. **Mempermudah pemeliharaan:** Jika proses pemilihan file berubah, pengubahan dapat dilakukan pada service tanpa harus mengubah banyak bagian tampilan.
3. **Mempermudah pengujian:** Proses fitur perangkat dapat diuji secara terpisah dari tampilan aplikasi.
4. **Mengurangi kode berulang:** Service dapat digunakan kembali oleh beberapa halaman yang membutuhkan fitur serupa.

Dengan pemisahan tersebut, struktur kode FasKampus menjadi lebih teratur dan mudah dikembangkan.

## Soal 5 — State Fitur Perangkat

Dalam menggunakan fitur perangkat, aplikasi perlu menangani beberapa state agar pengguna mengetahui proses yang sedang berlangsung.

State minimal yang perlu ditangani antara lain:

1. **Idle:** Kondisi awal ketika belum ada proses penggunaan fitur perangkat.
2. **Loading:** Kondisi ketika aplikasi sedang menjalankan proses pemilihan atau mengakses fitur perangkat.
3. **Success:** Kondisi ketika fitur berhasil digunakan dan menghasilkan data.
4. **Cancelled:** Kondisi ketika pengguna membatalkan proses pemilihan.
5. **Permission Denied:** Kondisi ketika pengguna menolak izin yang dibutuhkan.
6. **Error atau Unavailable:** Kondisi ketika terjadi kesalahan atau fitur perangkat tidak tersedia.

Perbedaan perlakuan pada setiap kondisi adalah sebagai berikut:

- **Berhasil:** Aplikasi menampilkan hasil yang diperoleh dan memperbarui tampilan. Pada FasKampus, nama dokumen yang dipilih ditampilkan pada form pengajuan.
- **Dibatalkan:** Aplikasi tidak melanjutkan proses dan tidak menganggap pembatalan sebagai kesalahan. Data yang sudah diisi pengguna tetap dipertahankan.
- **Permission ditolak:** Aplikasi memberikan informasi bahwa izin belum diberikan dan menjelaskan langkah yang dapat dilakukan pengguna jika akses tersebut memang diperlukan.

Dengan menangani state tersebut, penggunaan fitur perangkat menjadi lebih aman, terarah, dan mudah dipahami oleh pengguna.

---

## Kesimpulan

Berdasarkan materi Pertemuan 11, penggunaan fitur perangkat harus disesuaikan dengan kebutuhan pengguna dan proses bisnis aplikasi. Pada proyek FasKampus,
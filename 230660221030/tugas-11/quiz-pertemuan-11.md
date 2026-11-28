
# Jawaban Quiz Pertemuan 11 — Fitur Perangkat Sesuai Kebutuhan

**Mata Kuliah:** Pemrograman Aplikasi Bergerak  
**Pertemuan:** 11  
**CPMK:** CPMK-3  
**Project:** PustakaKu

## 1. Pemilihan Fitur

Pemilihan fitur perangkat harus disesuaikan dengan kebutuhan pengguna dan proses bisnis aplikasi. Fitur yang dipilih sebaiknya dapat membantu pengguna menyelesaikan pekerjaan dengan lebih mudah dan sesuai dengan fungsi aplikasi.

Pada project PustakaKu, fitur yang dipilih adalah pemilihan foto sampul buku dari galeri perangkat. Fitur ini dipilih karena admin membutuhkan foto sampul untuk melengkapi informasi buku pada katalog perpustakaan. Dengan adanya fitur tersebut, admin dapat memilih dan mengganti foto sampul buku sehingga tampilan katalog menjadi lebih informatif. Fitur ini diimplementasikan menggunakan package `image_picker`.

## 2. Permission

Permission diperlukan karena fitur perangkat membutuhkan akses terhadap sumber daya atau data yang berada pada perangkat pengguna. Penggunaan permission bertujuan agar akses dilakukan sesuai izin dan kendali pengguna.

Pada project PustakaKu, pemilihan foto dilakukan melalui file picker pada Google Chrome. Pengguna memilih sendiri gambar yang ingin digunakan.

Beberapa kondisi yang perlu ditangani aplikasi yaitu:

- **Permission diberikan atau akses tersedia:** aplikasi melanjutkan proses pemilihan dan pengolahan gambar.
- **Permission ditolak:** aplikasi tidak memaksakan akses dan memberikan informasi kepada pengguna.
- **Permission atau fitur tidak tersedia:** aplikasi menampilkan pesan bahwa fitur tidak dapat digunakan dan tidak menyebabkan aplikasi berhenti secara tiba-tiba.

## 3. Pembatalan Pemilihan

`XFile?` merupakan tipe data yang digunakan untuk menampung hasil pemilihan file gambar. Tanda `?` menunjukkan bahwa variabel tersebut dapat bernilai `null`.

Ketika pengguna membatalkan pemilihan gambar, package `image_picker` akan mengembalikan nilai `null`. Artinya, tidak ada gambar yang dipilih oleh pengguna.

Pada project PustakaKu, kondisi tersebut ditangani menggunakan pemeriksaan:

```dart
if (foto == null) return;
```

Kode tersebut membuat proses pemilihan langsung dihentikan apabila pengguna membatalkannya. Dengan demikian, aplikasi tidak melanjutkan proses membaca dan menyimpan gambar serta tetap berjalan normal.

## 4. Service Layer

Service layer merupakan bagian aplikasi yang bertanggung jawab menangani proses atau logika penggunaan fitur tertentu, seperti pemanggilan package, pengambilan data, dan pengelolaan proses penyimpanan.

Pada project PustakaKu, service layer diterapkan melalui class `FotoBukuService` yang terdapat pada file `foto-buku-service.dart`. Class tersebut bertugas menangani proses pemilihan gambar menggunakan package `image_picker`.

Pemisahan service layer dari widget bertujuan agar kode lebih terstruktur, mudah dipahami, dan mudah dipelihara. Widget cukup menangani tampilan serta interaksi pengguna, sedangkan proses pemilihan gambar ditangani oleh service. Dengan demikian, kode tidak menumpuk dalam satu bagian dan lebih mudah dikembangkan apabila terdapat perubahan fitur.

## 5. State Fitur Perangkat

State minimal yang perlu ditangani saat menggunakan fitur perangkat meliputi:

1. **Idle:** kondisi awal ketika belum ada proses pemilihan gambar.
2. **Loading:** kondisi ketika aplikasi sedang memproses atau menyimpan gambar.
3. **Success:** kondisi ketika gambar berhasil dipilih dan disimpan.
4. **Cancelled:** kondisi ketika pengguna membatalkan pemilihan gambar.
5. **Error:** kondisi ketika terjadi kesalahan selama proses pemilihan atau penyimpanan gambar.
6. **Permission Denied:** kondisi ketika akses perangkat ditolak sehingga fitur tidak dapat digunakan.

Perbedaan penanganannya adalah:

- **Berhasil:** aplikasi membaca gambar, menyimpannya ke IndexedDB, kemudian memperbarui tampilan katalog.
- **Dibatalkan:** aplikasi menghentikan proses tanpa menyimpan gambar baru dan tetap mempertahankan tampilan sebelumnya.
- **Permission ditolak:** aplikasi tidak melanjutkan akses dan memberikan informasi kepada pengguna mengenai kendala yang terjadi.

Pada project PustakaKu, penanganan pembatalan dan kesalahan sudah diterapkan menggunakan kondisi `foto == null` dan blok `try-catch`.

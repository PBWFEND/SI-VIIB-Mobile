# Model Data — PustakaKu

## 1. Deskripsi

Model data PustakaKu pada Tugas 7 berfokus pada pengelolaan data peminjaman buku secara lokal. Model ini digunakan untuk menyimpan informasi mahasiswa yang melakukan peminjaman, buku yang dipinjam, tanggal peminjaman, serta status peminjaman.

Penyusunan model data mengacu pada dokumen kebutuhan Tugas 4, khususnya kebutuhan F-04 (mengajukan peminjaman buku), F-05 (melihat status peminjaman), dan F-08 (memperbarui status peminjaman).

## 2. Daftar Entitas

### Entitas: Peminjaman

| Field | Tipe Data | Keterangan | Kebutuhan Terkait |
|---|---|---|---|
| `id` | String | Identitas unik setiap data peminjaman | F-04, F-05, F-08 |
| `nama` | String | Nama mahasiswa yang melakukan peminjaman | F-04 |
| `nim` | String | Nomor Induk Mahasiswa peminjam | F-04, F-05 |
| `judulBuku` | String | Judul buku yang dipinjam | F-04 |
| `tanggal` | DateTime | Tanggal data peminjaman dibuat | F-04, F-05 |
| `status` | String | Status proses peminjaman buku | F-05, F-08 |

## 3. Sumber Nilai Setiap Field

| Field | Sumber Nilai | Penjelasan |
|---|---|---|
| `id` | Sistem | Dibuat secara otomatis ketika data peminjaman ditambahkan untuk membedakan setiap data. |
| `nama` | Form | Diisi oleh mahasiswa melalui form peminjaman. |
| `nim` | Form | Diisi oleh mahasiswa melalui form peminjaman. |
| `judulBuku` | Sistem | Diambil dari buku yang dipilih mahasiswa pada halaman katalog atau detail buku. |
| `tanggal` | Sistem | Diambil dari tanggal saat data peminjaman dibuat. |
| `status` | Sistem | Diberikan nilai awal "Diproses" dan dapat diperbarui melalui operasi Update. |

## 4. Hubungan Model Data dengan Kebutuhan Fungsional

| ID Kebutuhan | Kebutuhan Fungsional | Implementasi pada Model Data |
|---|---|---|
| F-04 | Mahasiswa dapat mengajukan peminjaman buku yang tersedia. | Data nama, NIM, judul buku, tanggal, dan status disimpan sebagai data peminjaman baru. |
| F-05 | Mahasiswa dapat melihat status peminjaman yang telah diajukan. | Data peminjaman dibaca dan ditampilkan dalam daftar beserta statusnya. |
| F-08 | Petugas dapat memperbarui status peminjaman mahasiswa. | Field `status` diperbarui sesuai perubahan kondisi peminjaman. |

## 5. Operasi Pengelolaan Data

Pengelolaan data PustakaKu pada Tugas 7 menerapkan empat operasi CRUD:

1. **Create:** Menambahkan data peminjaman baru melalui form.
2. **Read:** Menampilkan seluruh data peminjaman menggunakan daftar.
3. **Update:** Memperbarui status peminjaman berdasarkan identitas unik (`id`).
4. **Delete:** Menghapus data peminjaman berdasarkan `id` setelah pengguna memberikan konfirmasi.

Operasi Delete diterapkan untuk memenuhi ketentuan CRUD pada Tugas 7. Operasi ini merupakan bagian dari pengelolaan data lokal dan bukan kebutuhan fungsional tersendiri yang tercantum pada Tugas 4.

## 6. Keputusan Penyimpanan Data

Data peminjaman dikelola menggunakan `List<Peminjaman>` pada `State` dari sebuah `StatefulWidget`. Setiap perubahan data dilakukan menggunakan `setState()` agar tampilan diperbarui sesuai kondisi data terbaru.

Penyimpanan pada tahap ini bersifat sementara (in-memory), sehingga data akan kembali ke kondisi awal ketika aplikasi dimulai ulang. Implementasi tidak menggunakan package tambahan maupun database eksternal.
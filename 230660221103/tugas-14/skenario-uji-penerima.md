# Skenario Uji Penerima (User Acceptance Test) — v1.0.0-rc.1

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Tabel Langkah Pengujian Penerima

| Langkah | Tindakan | Hasil yang Diharapkan | Hasil Aktual | Status |
| :-: | :--- | :--- | :--- | :-: |
| 1 | Buka aplikasi **Kantin Kampus Digital** (`flutter run -d chrome`). | Halaman utama tampil dengan daftar 3 pesanan awal, baris filter status, dan tombol **Buat Pesanan** tanpa error. | Halaman utama tampil rapi dengan 3 kartu pesanan awal dan bar filter aktif. | **Lulus** |
| 2 | Tekan tombol **Buat Pesanan**, isi form valid (`Reina`, `Mie Ayam Bakso`, porsi `2`, meja `9`), lalu tekan **Simpan & Kirim ke Antrean**. | Form tertutup, muncul `SnackBar` konfirmasi, dan pesanan baru `KTN-004` langsung muncul di urutan teratas daftar. | Pesanan `KTN-004` langsung tampil di daftar dengan status **Menunggu** dan `SnackBar` muncul. | **Lulus** |
| 3 | Ketuk kartu pesanan `KTN-004` untuk membuka detail pesanan. | Detail menampilkan data yang sama persis (`KTN-004`, `Mie Ayam Bakso`, Meja `#9`). | Detail menampilkan data `KTN-004` secara akurat baik pada panel kanan maupun layar detail. | **Lulus** |
| 4 | Pada detail `KTN-004`, pilih chip status **Siap Diambil**. | Status berubah menjadi **Siap Diambil**, muncul `SnackBar`, dan lencana pada daftar ikut diperbarui. | Status pada detail dan kartu daftar langsung berubah menjadi **Siap Diambil**. | **Lulus** |
| 5 | Tekan chip filter **Menunggu**, lalu coba filter status yang tidak memiliki data. | Daftar tersaring sesuai status; jika kosong, tampil pesan *"Belum ada pesanan pada kategori ini."* dan tombol **Tampilkan Semua**. | Filter menyaring item dengan tepat dan menampilkan pesan keadaan kosong saat hasil nihil. | **Lulus** |
| 6 | Ubah lebar jendela browser menjadi sempit (`400px`) dan lebar (`900px`), lalu uji ikon simulasi koneksi terputus di `AppBar`. | Pada `400px` tampil 1 kolom tanpa overflow; pada `900px` tampil 2 kolom; saat gagal tampil pesan error dan tombol **Coba Lagi**. | Tidak ada `RenderFlex overflow` pada kedua ukuran layar dan tombol **Coba Lagi** memulihkan tampilan normal. | **Lulus** |
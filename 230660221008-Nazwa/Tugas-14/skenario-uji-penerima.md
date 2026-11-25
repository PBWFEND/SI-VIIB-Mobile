# Skenario Uji Penerima (User Acceptance Test) — v1.0.0-rc.1

* **Nama:** Nazwa Umaira Nanindia Ramdhani
* **NIM:** 230660221008
* **Kelas:** SI-VIIB

---

## Panduan Pengujian Mandiri oleh Pihak Lain

| Langkah | Tindakan | Hasil yang diharapkan | Hasil aktual | Status |
|:--------|:---------|:----------------------|:-------------|:------:|
| **1** | Jalankan aplikasi (`flutter run -d chrome`) dan tunggu proses muat selesai. | Halaman utama tampil dengan AppBar **Pengaduan Fasilitas Kampus**, banner `Koneksi HTTPS Aktif`, ringkasan `Total: 3`, dan 3 kartu tiket awal (`TKT-1001` s.d. `TKT-1003`). | Halaman utama tampil lengkap tanpa error dan menampilkan 3 tiket awal beserta ringkasan jumlah status. | **Lulus** |
| **2** | Tekan tombol **Buat Laporan Kerusakan Baru**, kosongkan kolom Lokasi & Deskripsi, lalu tekan **Kirim Laporan Pengaduan**. | Pengiriman ditahan dan muncul pesan validasi merah di bawah kolom Lokasi dan Deskripsi. | Muncul pesan `Lokasi ruangan atau fasilitas wajib diisi.` dan `Deskripsi kerusakan wajib diisi.`; tidak ada tiket baru terbuat. | **Lulus** |
| **3** | Isi Lokasi dengan `Lab Jaringan Lantai 3` dan Deskripsi dengan `Switch utama rak server mati dan lampu indikator tidak menyala.`, lalu tekan **Kirim Laporan Pengaduan**. | Form tertutup otomatis, muncul SnackBar konfirmasi tiket `TKT-1004`, dan daftar utama langsung menampilkan `Total: 4` dengan tiket baru di urutan paling atas. | SnackBar konfirmasi tampil dan daftar langsung bertambah menjadi `Total: 4` tanpa perlu menekan muat ulang. | **Lulus** |
| **4** | Tekan filter chip **Diproses**, lalu kembalikan ke **Semua**. | Daftar hanya menampilkan tiket berstatus `Diproses` saat filter aktif, dan kembali menampilkan seluruh tiket saat **Semua** dipilih. | Daftar tersaring sesuai status yang dipilih dan kembali menampilkan seluruh tiket saat chip **Semua** ditekan. | **Lulus** |
| **5** | Buka detail tiket `TKT-1004` (ketuk kartu pada layar sempit atau lihat panel kanan pada layar lebar), lalu tekan tombol status **Diproses**. | Status tiket berubah menjadi `Diproses`, muncul SnackBar pembaruan status, dan badge status pada daftar utama ikut berubah menjadi `Diproses`. | Status pada detail dan daftar utama langsung sinkron berubah menjadi `Diproses`. | **Lulus** |
| **6** | Ubah lebar jendela browser menjadi `400 px` (sempit) dan `900 px` (lebar). | Pada `400 px` tampil 1 kolom vertikal tanpa overflow; pada `900 px` tampil 2 kolom berdampingan (daftar di kiri, detail di kanan). | Tata letak berpindah mulus antara 1 kolom dan 2 kolom tanpa peringatan `RenderFlex overflowed`. | **Lulus** |
| **7** | Tekan ikon hapus (tempat sampah) pada detail tiket `TKT-1004`, lalu pilih **Hapus** pada dialog konfirmasi. | Muncul dialog konfirmasi `Hapus Tiket Pengaduan?`; setelah dikonfirmasi, tiket terhapus dan jumlah kembali menjadi `Total: 3`. | Dialog konfirmasi tampil dan tiket `TKT-1004` terhapus dari daftar sehingga kembali menjadi `Total: 3`. | **Lulus** |
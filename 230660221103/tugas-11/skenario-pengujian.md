# Skenario Pengujian Fitur Perangkat — Tugas 11

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Lingkungan Uji:** Google Chrome (`flutter run -d chrome`)

---

## Tabel Hasil Pengujian

| No. | Skenario | Langkah Uji | Expected Result | Actual Result | Status |
| :-: | :--- | :--- | :--- | :--- | :-: |
| 1 | **Fitur berhasil digunakan** | Klik tombol **Pilih Galeri**, pilih file gambar bukti QRIS (`.jpg`/`.png` < 5 MB), lalu tekan **Kirim Pesanan & Bukti Foto**. | Indikator loading muncul sesaat, pratinjau gambar beserta nama file dan ukuran KB tampil, dan pesanan masuk ke daftar terkonfirmasi. | Pratinjau gambar tampil jelas di kartu form dan muncul sebagai thumbnail pada daftar **Pesanan Terkonfirmasi**. | **Lulus** |
| 2 | **Pengguna membatalkan aksi** | Setelah memilih satu gambar, klik kembali **Pilih Galeri** lalu tekan tombol **Cancel / Batal** pada dialog pemilih berkas. | Aplikasi tidak menampilkan pesan error merah, melainkan mempertahankan gambar sebelumnya dan menampilkan `SnackBar` informasi pembatalan. | Gambar sebelumnya tetap tampil utuh dan muncul `SnackBar` bertuliskan *"Pemilihan gambar dibatalkan. Data sebelumnya dipertahankan."* | **Lulus** |
| 3 | **Permission ditolak** | Klik tombol **Ambil Kamera** pada Chrome, lalu klik **Block** pada popup izin kamera browser. | Aplikasi menangkap `PlatformException`, menampilkan kotak peringatan **Izin Akses Perangkat Ditolak** beserta tombol **Coba Minta Izin Lagi**. | Muncul kotak pesan penolakan izin kamera dengan penjelasan cara mengaktifkan izin dan tombol coba lagi berfungsi. | **Lulus** |
| 4 | **Package / Validasi menghasilkan error** | Pilih berkas gambar berukuran lebih dari 5 MB (atau simulasikan error pembacaan file). | Aplikasi menolak file, menampilkan pesan kesalahan informatif dan tombol **Coba Lagi** tanpa *crash*. | Muncul pesan *"Ukuran gambar melebihi batas maksimal 5 MB..."* beserta tombol **Coba Lagi**. | **Lulus** |
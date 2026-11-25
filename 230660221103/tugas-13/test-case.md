# Daftar Skenario Pengujian (Test Case) — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## Tabel Test Case (TC-01 s.d. TC-08)

| ID | Skenario | Kondisi Awal | Langkah | Expected Result | Actual Result | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :---: |
| **TC-01** | Menambah pesanan dengan seluruh input valid | Halaman utama terbuka, form kosong | Isi Nama (`Reina Anatasya`), Menu (`Nasi Goreng Spesial`), Porsi (`2`), lalu tekan **Simpan Pesanan**. | Data tersimpan satu kali, form dibersihkan, `SnackBar` konfirmasi muncul, dan `Daftar Pesanan (1)` tampil. | Pesanan tersimpan satu kali dengan detail sesuai input, form kembali kosong, dan `SnackBar` tampil. | **Lulus** |
| **TC-02** | Validasi field wajib kosong | Form kosong | Kosongkan seluruh kolom input, lalu tekan **Simpan Pesanan**. | Sistem menolak penyimpanan dan menampilkan pesan error di bawah setiap kolom wajib. | Muncul pesan *"Nama pemesan wajib diisi"*, *"Nama menu wajib diisi"*, dan *"Jumlah porsi wajib diisi"*; daftar tetap `0`. | **Lulus** |
| **TC-03** | Validasi jumlah porsi di luar batas (`0` atau `60`) | Form terbuka | Isi Nama dan Menu valid, isi Porsi dengan `0` atau `60`, lalu tekan **Simpan Pesanan**. | Sistem menolak penyimpanan dan menampilkan pesan batas rentang porsi `1..50`. | Muncul pesan *"Jumlah porsi harus antara 1 sampai 50"* dan data tidak ditambahkan ke daftar. | **Lulus** |
| **TC-04** | Menekan tombol Simpan dua kali dengan cepat (*Double-Submit*) | Form terisi data valid | Tekan tombol **Simpan Pesanan** dua kali secara cepat dalam jeda < 100 ms. | Tombol langsung dinonaktifkan (`Menyimpan...`) pada ketukan pertama sehingga hanya **1** pesanan dibuat. | Hanya 1 pesanan masuk ke daftar (`Daftar Pesanan (1)`), tidak ada duplikasi transaksi. | **Lulus** |
| **TC-05** | Menghapus pesanan dari daftar | Terdapat 1 item pesanan (`ORD-1`) di daftar | Tekan ikon tempat sampah pada kartu pesanan `ORD-1`. | Pesanan dihapus berdasarkan `id` dan halaman menampilkan status kosong *"Belum ada pesanan tercatat"*. | Item `ORD-1` terhapus, penghitung kembali menjadi `Daftar Pesanan (0)`, dan teks empty state tampil. | **Lulus** |
| **TC-06** | Kondisi awal daftar kosong (*Empty State*) | Aplikasi baru dibuka tanpa transaksi | Amati area daftar pesanan di bawah formulir. | Menampilkan pesan informatif bahwa belum ada pesanan tercatat tanpa error. | Teks *"Belum ada pesanan tercatat"* tampil rapi di tengah area daftar. | **Lulus** |
| **TC-07** | Simulasi koneksi gagal pada endpoint REST API (Integrasi Tugas 9/10) | URL endpoint diubah ke alamat tidak valid | Jalankan aplikasi dengan URL salah dan amati layar daftar API. | Menampilkan ikon gangguan jaringan, pesan error ramah pengguna, dan tombol **Coba Lagi** tanpa *crash*. | Muncul pesan *"Endpoint pesanan tidak ditemukan di server (HTTP 404)"* beserta tombol **Coba Lagi**. | **Lulus** |
| **TC-08** | Pembatalan pemilihan gambar bukti pembayaran (Integrasi Tugas 11) | Satu foto bukti QRIS sudah terpilih di form | Tekan **Pilih Galeri**, lalu tekan **Cancel** pada dialog pemilih berkas. | Aplikasi mempertahankan foto yang sudah terpilih sebelumnya tanpa menampilkan error. | Foto sebelumnya tetap tampil utuh dan muncul `SnackBar` informasi pembatalan. | **Lulus** |
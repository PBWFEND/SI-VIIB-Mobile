# Spesifikasi Validasi Input — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## 1. Tabel Aturan Validasi Client dan Pemeriksaan Server

| Input | Aturan Validasi Client (`ValidatorKantin`) | Pemeriksaan Otoritatif Server | Pesan Error pada Antarmuka |
| :--- | :--- | :--- | :--- |
| **Nama Pemesan** | Wajib diisi (`trim().isEmpty`), panjang `3..60` karakter, hanya huruf dan tanda baca nama (`^[a-zA-Z\s'.-]+$`). | Memeriksa kecocokan nama dengan akun mahasiswa terautentikasi di database pengguna serta sanitasi karakter. | • `"Nama pemesan wajib diisi."`<br>• `"Nama pemesan minimal 3 karakter."`<br>• `"Nama pemesan maksimal 60 karakter."`<br>• `"Nama hanya boleh berisi huruf dan tanda baca standar."` |
| **Email Mahasiswa** | Wajib diisi, maksimal 100 karakter, format email valid (`^[\w\.-]+@[\w\.-]+\.\w{2,}$`). | Memverifikasi keunikan akun email terdaftar dan status keaktifan mahasiswa di sistem kampus. | • `"Email mahasiswa wajib diisi untuk konfirmasi pesanan."`<br>• `"Format email tidak valid (contoh: reina@kampus.ac.id)."` |
| **Jumlah Porsi** | Wajib diisi, harus dapat dikonversi menjadi bilangan bulat (`int.tryParse`), rentang nilai `1` hingga `50`. | Memeriksa ketersediaan stok harian menu pada stan kantin dan batas kuota pesanan per transaksi. | • `"Jumlah porsi wajib diisi."`<br>• `"Jumlah porsi harus berupa angka bulat."`<br>• `"Jumlah porsi harus di antara 1 sampai 50 porsi per transaksi."` |
| **Nomor Meja** | Wajib diisi, bilangan bulat valid pada rentang `1` hingga `99`. | Memvalidasi apakah nomor meja terdaftar pada denah area makan kantin kampus. | • `"Nomor meja atau kode pengambilan wajib diisi."`<br>• `"Masukkan nomor meja yang valid (1 - 99)."` |
| **Catatan Pesanan** | Opsional, panjang maksimal 150 karakter, menolak karakter tag HTML (`<` dan `>`). | Melakukan *escaping* karakter dan sanitasi SQL/XSS sebelum menyimpan catatan ke tabel pesanan. | • `"Catatan pesanan maksimal 150 karakter."`<br>• `"Catatan tidak boleh mengandung karakter < atau >."` |

---

## 2. Lokasi Kode Validator & Cara Mengujinya

* **Lokasi Kode:** `lib/security/validasi_kantin.dart` (class `ValidatorKantin`) yang dihubungkan ke widget `TextFormField` pada `lib/main.dart`.
* **Skenario Pengujian Kondisi Gagal:**
  1. Kosongkan kolom **Nama Pemesan** atau isi hanya 2 huruf (`"Re"`), lalu tekan **Validasi & Kirim Pesanan Aman** → muncul pesan error merah di bawah kolom dan pengiriman dibatalkan.
  2. Isi **Email Mahasiswa** tanpa tanda `@` (misal `"reinakampus.ac.id"`) → muncul pesan `"Format email tidak valid..."`.
  3. Isi **Jumlah Porsi** dengan angka `0` atau `75` → muncul pesan `"Jumlah porsi harus di antara 1 sampai 50 porsi per transaksi."`.
  4. Isi **Catatan Tambahan** dengan `<script>` → muncul pesan `"Catatan tidak boleh mengandung karakter < atau >."`.
  5. Klik tombol **Logout** pada `AppBar` untuk menghapus token sesi, lalu tekan tombol kirim → muncul peringatan `SnackBar` sesi berakhir (simulasi `401 Unauthorized`).
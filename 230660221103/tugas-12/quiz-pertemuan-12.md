# Quiz Pertemuan 12 — Validasi dan Keamanan Praktis

* **Mata Kuliah:** Pemrograman Aplikasi Bergerak
* **Pertemuan:** 12 | **CPMK:** CPMK-4
* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Project:** Kantin Kampus Digital

---

## Soal 1 — Validasi Client dan Server

**Jawaban:**
* **Perbedaan validasi client dan server:**
  * **Validasi client (Flutter):** Berjalan di perangkat pengguna untuk memberikan umpan balik cepat (*immediate feedback*), mencegah pengguna mengirim formulir kosong atau format yang keliru, serta menghemat kuota jaringan.
  * **Validasi server (Backend API):** Berjalan di server terpusat sebagai pemeriksaan otoritatif terakhir sebelum data diproses atau disimpan ke basis data (memeriksa hak akses pengguna, integritas relasi data, ketersediaan stok, dan aturan bisnis).
* **Alasan validasi form Flutter tidak cukup melindungi aturan bisnis:** Aplikasi client berada di sisi perangkat pengguna sehingga dapat dimodifikasi, di-dekompilasi, atau dilewati sama sekali oleh pihak tidak bertanggung jawab yang mengirimkan HTTP request langsung ke endpoint API menggunakan alat seperti Postman/cURL. Oleh karena itu, server wajib selalu melakukan validasi ulang secara independen.

---

## Soal 2 — HTTPS dan Token

**Jawaban:**
* **Risiko yang terjadi:** Mengirimkan token melalui protokol `http://` (tanpa enkripsi TLS) menyebabkan seluruh isi header `Authorization` dan payload request dikirim dalam bentuk teks terbuka (*plaintext*). Penyerang yang berada pada jaringan yang sama (misalnya Wi-Fi publik kampus) dapat melakukan penyadapan (*Man-in-the-Middle / packet sniffing*), mencuri token sesi tersebut, dan menyamar sebagai pengguna sah untuk mengakses akun atau memanipulasi pesanan.
* **Perbaikan yang harus dilakukan:**
  1. Mengubah seluruh alamat endpoint menjadi **`https://`** yang dilindungi sertifikat TLS/SSL valid agar lalu lintas data terenkripsi selama perjalanan.
  2. Mengirimkan token melalui header HTTP `Authorization: Bearer <token>` (bukan pada URL query string) dan memastikan aplikasi tidak menonaktifkan verifikasi sertifikat SSL.

---

## Soal 3 — Secure Storage

**Jawaban:**
* **Alasan token harus disimpan pada penyimpanan aman platform (bukan source code atau log):**
  * Jika token ditulis (*hardcoded*) di **source code**, siapa pun yang mengakses repository Git atau membongkar berkas APK/IPA aplikasi dapat langsung membaca kredensial tersebut.
  * Jika token dicetak di **log** (`print`/`debugPrint`), token dapat terbaca melalui konsol debugging atau sistem pengumpul log perangkat.
  * Penyimpanan aman platform (seperti `flutter_secure_storage` yang memanfaatkan *Android Keystore* dan *iOS Keychain*) mengenkripsi data sensitif secara perangkat keras sehingga tidak dapat dibaca oleh aplikasi lain.
* **Tindakan saat pengguna logout:** Aplikasi wajib segera **menghapus token dari penyimpanan aman** (`await storage.delete(...)`), membersihkan state sesi pengguna di memori aplikasi, dan mengarahkan pengguna kembali ke halaman login agar token lama tidak dapat dipakai ulang pada perangkat tersebut.

---

## Soal 4 — Permission

**Jawaban:**
* **Analisis masalah:** Meminta permission kamera saat aplikasi pertama kali dibuka — padahal fitur foto hanya dipakai pada satu formulir tertentu — melanggar prinsip ***least privilege*** (hak akses minimum) dan konteks kebutuhan. Hal ini menimbulkan kecurigaan privasi bagi pengguna sehingga pengguna cenderung menekan tombol **Tolak (*Deny*)**, yang mengakibatkan fitur foto gagal berfungsi ketika benar-benar dibutuhkan nanti.
* **Alur permission yang lebih tepat (*Just-in-Time Permission*):**
  1. Biarkan pengguna membuka dan menjelajahi menu utama aplikasi tanpa meminta izin kamera.
  2. Hanya ketika pengguna membuka formulir pengajuan dan menekan tombol **"Ambil Foto"**, tampilkan penjelasan singkat mengenai tujuan penggunaan kamera.
  3. Ajukan permintaan permission kamera pada momen tersebut; jika ditolak, tampilkan pesan edukatif beserta tombol untuk mencoba meminta izin ulang atau gunakan opsi alternatif (seperti memilih file dari galeri).

---

## Soal 5 — Security Checklist

**Jawaban:**
Berikut lima pemeriksaan keamanan untuk project **Kantin Kampus Digital** beserta bukti verifikasinya:

1. **Pemeriksaan:** Input wajib, format email, dan batas rentang nilai divalidasi pada form client sebelum pengiriman data.
   * **Bukti:** File `lib/security/validasi_kantin.dart` (`ValidatorKantin`) dan hasil pengujian input tidak valid pada `validasi-input.md`.
2. **Pemeriksaan:** Seluruh endpoint komunikasi jaringan menggunakan protokol terenkripsi `https://`.
   * **Bukti:** Konfigurasi konstanta `_endpointPesanan = 'https://...'` dan validasi `uri.scheme != 'https'` pada `lib/main.dart`.
3. **Pemeriksaan:** Tidak ada token, password, maupun API key yang ditulis (*hardcoded*) di dalam source code.
   * **Bukti:** Hasil peninjauan seluruh berkas pada folder `lib/` serta `pubspec.yaml` di repository GitHub.
4. **Pemeriksaan:** Token sesi dihapus sepenuhnya ketika pengguna menekan tombol logout.
   * **Bukti:** Implementasi method `hapus()` pada `SesiTokenStorage` (`lib/security/validasi_kantin.dart`) yang dipanggil oleh tombol **Logout** pada `lib/main.dart`.
5. **Pemeriksaan:** Permission fitur kamera/galeri hanya diminta saat fitur lampiran bukti pembayaran digunakan dan penolakan izin ditangani tanpa *crash*.
   * **Bukti:** Penanganan `PlatformException` pada `lampiran_foto_service.dart` serta tabel hasil uji skenario *Permission ditolak* pada `skenario-pengujian.md`.
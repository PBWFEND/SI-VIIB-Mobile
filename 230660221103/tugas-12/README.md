# Tugas 12: Validasi dan Keamanan Praktis — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Dependency & Target Pengujian

* **Dependency:** Menggunakan SDK Flutter (`material.dart`) tanpa tambahan package pihak ketiga yang tidak diperlukan (*minimal attack surface*).
* **Target Pengujian:** Google Chrome (`flutter run -d chrome`) pada macOS.

---

## 2. Dokumentasi Pengelolaan Token, HTTPS, dan Permission

* **HTTPS:** Seluruh endpoint komunikasi API menggunakan protokol `https://` (`https://jsonplaceholder.typicode.com/posts`) dan diverifikasi melalui pengecekan `uri.scheme == 'https'` sebelum transaksi dikirim.
* **Token & Penyimpanan Aman:** Token sesi dikelola melalui abstraksi `TokenStorage` (`SesiTokenStorage` pada `lib/security/validasi_kantin.dart`). Token tidak pernah ditulis secara statis (*hardcoded*) di dalam kode, tidak dicetak ke log/UI, dan langsung dihapus (`hapus()`) ketika pengguna menekan tombol **Logout**.
* **Permission (*Least Privilege*):** Fitur pemesanan utama tidak meminta izin perangkat keras apa pun. Permission kamera/galeri hanya diminta secara *on-demand* pada modul unggah bukti QRIS (Tugas 11) ketika pengguna menekan tombol lampiran foto.

---

## 3. Batasan Keamanan

1. Karena target verifikasi utama menggunakan Flutter Web (`Chrome`), penyimpanan token disimulasikan melalui memori sesi runtime (`SesiTokenStorage`). Pada implementasi produksi untuk Android/iOS, penyimpanan token akan menggunakan package `flutter_secure_storage` (EncryptedSharedPreferences / iOS Keychain).
2. Validasi form pada aplikasi Flutter berfungsi untuk meningkatkan pengalaman pengguna (*fast feedback*), namun pemeriksaan otoritatif tetap wajib dilakukan oleh server backend pada lingkungan produksi.

---

## 4. Cara Menjalankan Aplikasi

1. Masuk ke folder Tugas 12:
   ```bash
   cd tugas-12/230660221103-ReinaAnatasyaKusumahPutri
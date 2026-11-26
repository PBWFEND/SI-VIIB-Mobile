# Tugas 11: Integrasi Fitur Perangkat (RadiAct UNSAP Radio)

**Nama**  : Deyna Angeliawati Zahara  
**NPM**   : 230660221032  
**Kelas** : SI VII B  


## 1. Deskripsi Singkat & Analisis Kebutuhan Fitur
Pada Tugas 11 ini, aplikasi **RadiAct (UNSAP Radio)** diintegrasikan dengan fitur perangkat **akses file / penyimpanan lokal** menggunakan package `file_picker` untuk melampirkan dokumen naskah siaran pada setiap jadwal program.

- **Aktor yang Menggunakan Fitur:** Penanggung Jawab (PJ) Divisi / Produser Program UNSAP Radio.
- **Tujuan Fitur pada Proses Bisnis:** Menjadi syarat kelengkapan naskah siaran (`.pdf`, `.doc`, `.docx`, maks 2 MB) sebelum jadwal program berstatus *Progres* dapat disetujui berubah menjadi *Tayang*.
- **Data Keluaran Fitur:** Metadata file dari perangkat meliputi nama file (`namaFile`), ekstensi (`ekstensi`), ukuran file (`ukuranTerbaca`), dan path lokal (`pathLokal` pada target non-web).
- **Target Platform:** Flutter Web (Google Chrome).
- **Konsekuensi Jika Permission Ditolak atau Aksi Dibatalkan:**
  - **Pengguna Membatalkan Aksi:** Service mengembalikan `null`, lampiran naskah sebelumnya tetap dipertahankan (tidak terhapus), dan muncul banner info pembatalan.
  - **Permission Ditolak / Error:** Service melempar `Exception` dengan pesan yang informatif serta menampilkan banner peringatan lengkap dengan tombol **Coba Lagi**.


## 2. Dokumentasi Konfigurasi dan Cara Menjalankan

### Dependency (`pubspec.yaml`)
 `http: ^1.2.2` dan `file_picker: ^8.3.7`

### Target Verifikasi dan Langkah Menjalankan
- **Target Verifikasi:** Google Chrome (Flutter Web) pada Windows.
- **Langkah Menjalankan Aplikasi:**
  1. Jalankan perintah berikut di terminal direktori proyek untuk mengunduh package:
     ```bash
     flutter pub get
     ```
  2. Jalankan aplikasi pada target Google Chrome:
     ```bash
     flutter run -d chrome
     ```
  3. Klik tombol **Lampirkan Naskah** pada kartu jadwal untuk memilih dokumen (`.pdf`, `.doc`, `.docx`, maks 2 MB), lalu ubah status program ke **Tayang** melalui tombol **Ubah Status**.
- **Batasan Pengujian pada Target Web:** Pada Flutter Web, akses langsung ke path file lokal dibatasi oleh browser (`file.path` tidak tersedia), sehingga pembacaan isi file menggunakan `bytes` (`withData: true`) dan penyimpanan masih bersifat sementara di memori (*in-memory*), belum diunggah ke server permanen.

## 3. Skenario Pengujian

| Skenario | Expected Result | Actual Result |
| :--- | :--- | :--- |
| **Fitur berhasil digunakan** | Indikator *loading* muncul saat dialog terbuka; file valid tampil di kotak hijau beserta ukurannya, dan status program dapat diubah ke *Tayang*. | Kotak lampiran berubah hijau menampilkan detail dokumen yang ditambahkan dan status jadwal berhasil diubah menjadi *Tayang*. |
| **Pengguna membatalkan aksi** | Data lampiran file sebelumnya tidak terhapus, tidak dianggap error, dan muncul pesan info pembatalan. | File lampiran lama tetap dipertahankan pada kartu jadwal dan muncul info bahwa pemilihan file dibatalkan. |
| **Permission ditolak** | Aplikasi tidak *crash*, menampilkan pesan izin ditolak yang informatif, serta menyediakan tombol *Coba Lagi*. | `PlatformException` ditangkap oleh `FileNaskahService` dan antarmuka menampilkan banner merah peringatan beserta tombol *Coba Lagi*. |
| **Package atau perangkat menghasilkan error** | File > 2 MB atau format selain PDF/DOC/DOCX ditolak dengan pesan error yang jelas beserta tombol *Coba Lagi*. | Banner peringatan merah tampil menjelaskan kesalahan format/ukuran file lengkap dengan tombol *Coba Lagi*. |

---

## 4. Struktur Folder Pengumpulan
```text
tugas-11/
├── lib/
│   ├── main.dart
│   └── services/
│       ├── file_naskah_service.dart
│       └── integrasi_service.dart
├── pubspec.yaml
├── README.md
└── refleksi.md
```
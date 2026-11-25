# Dokumen Analisis Kebutuhan Fitur Perangkat — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Fitur Perangkat Terpilih:** Kamera & Galeri (`image_picker`)

---

## 1. Spesifikasi Kebutuhan Fitur Perangkat

| Komponen Analisis | Uraian |
| :--- | :--- |
| **Aktor Pengguna** | Mahasiswa Pemesan (Dinda) dan Pengelola Stan Kantin |
| **Tujuan pada Proses Bisnis** | Melampirkan bukti pembayaran QRIS atau foto struk pesanan sebelum pesanan dikirim ke antrean stan, sehingga penjual dapat memverifikasi pembayaran secara instan tanpa antre di kasir. |
| **Data Keluaran Fitur** | Objek `XFile` yang dikonversi menjadi `HasilPilihFoto` berisi `namaFile` (`String`), `pathFile` (`String`), `bytesGambar` (`Uint8List`), dan `ukuranKb` (`double`). |
| **Permission yang Diperlukan** | • **Web (Chrome):** Izin akses kamera browser (`navigator.mediaDevices.getUserMedia`) saat memilih *Ambil Kamera*, dan dialog pemilih berkas sistem saat memilih *Pilih Galeri*.<br>• **Android (`AndroidManifest.xml`):** `android.permission.CAMERA` (ditangani otomatis oleh `image_picker` melalui Android Photo Picker / Intent kamera).<br>• **iOS (`Info.plist`):** `NSCameraUsageDescription` dan `NSPhotoLibraryUsageDescription`. |
| **Target Platform Verifikasi** | Flutter Web (`flutter run -d chrome`) pada macOS |
| **Konsekuensi Pembatalan & Penolakan Izin** | • Jika pengguna menekan **Batal** (`XFile? == null`), sistem **tidak menganggapnya sebagai error** dan mempertahankan foto yang sudah dipilih sebelumnya.<br>• Jika izin kamera ditolak (`PlatformException`), sistem menampilkan kotak peringatan khusus beserta alasan dan tombol **Coba Minta Izin Lagi**. |

---

## 2. Diagram Lifecycle & Alur Penanganan State

```mermaid
stateDiagram-v2
    [*] --> BelumDipilih
    BelumDipilih --> Memproses: Tekan Ambil Kamera / Pilih Galeri
    Memproses --> BerhasilPreview: XFile valid (<= 5 MB)
    Memproses --> BelumDipilih: Batal (XFile == null)
    Memproses --> PermissionDitolak: PlatformException (permission denied)
    Memproses --> ErrorPerangkat: Ukuran > 5 MB / gagal baca file
    BerhasilPreview --> Memproses: Ganti foto baru
    BerhasilPreview --> BerhasilPreview: Batal memilih foto baru (pertahankan lama)
# Security Checklist Project — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## Tabel Pemeriksaan Keamanan Praktis

| No. | Risiko atau Pemeriksaan | Status | Bukti |
| :-: | :--- | :-: | :--- |
| 1 | Input wajib divalidasi pada client | **Selesai** | `lib/security/validasi_kantin.dart` (`validasiNamaPemesan`, `validasiEmail`, `validasiJumlahPorsi`, `validasiNomorMeja` menolak string kosong setelah `trim()`). |
| 2 | Format, panjang teks, dan rentang nilai input diperiksa | **Selesai** | `lib/security/validasi_kantin.dart` (RegExp email & nama, batas panjang 60/100/150 karakter, rentang porsi `1..50` dan meja `1..99`, serta penolakan karakter `<` dan `>`). |
| 3 | HTTPS digunakan untuk endpoint yang membawa data sensitif | **Selesai** | `lib/main.dart` (`_endpointPesanan = 'https://jsonplaceholder.typicode.com/posts'` dan pengecekan eksplisit `uri.scheme != 'https'` sebelum pengiriman). |
| 4 | Token atau secret tidak ditulis (*hardcoded*) pada source code | **Selesai** | Seluruh berkas pada folder `lib/` diperiksa; tidak ada API key, password, maupun token statis di dalam kode. |
| 5 | Token tidak dicetak pada console log, UI, maupun pesan error | **Selesai** | `lib/main.dart` hanya menampilkan status boolean `_sesiAktif` pada banner antarmuka tanpa mencetak nilai token ke `print()` maupun `SnackBar`. |
| 6 | Token dihapus saat pengguna melakukan logout | **Selesai** | `lib/security/validasi_kantin.dart` (`SesiTokenStorage.hapus()`) dipanggil pada tombol **Logout** di `AppBar` (`lib/main.dart`) dan mencegah pengiriman jika sesi kosong. |
| 7 | Permission fitur perangkat mengikuti prinsip *least privilege* | **Selesai** | `tugas-11/230660221103-ReinaAnatasyaKusumahPutri/dokumen-fitur-perangkat.md` — hanya meminta akses kamera/galeri saat tombol unggah bukti QRIS ditekan, tanpa meminta permission lokasi atau kontak yang tidak relevan. |
| 8 | Kondisi permission ditolak dan pembatalan ditangani | **Selesai** | `tugas-11/.../lampiran_foto_service.dart` menangani `PlatformException` (permission denied) dengan pesan edukatif dan menganggap pembatalan (`null`) bukan sebagai error. |
| 9 | Pesan error tidak membocorkan detail internal server / stack trace | **Selesai** | Seluruh pesan error pada `ValidatorKantin` dan layanan HTTP menampilkan pesan ramah pengguna tanpa menampilkan *stack trace* mentah. |
| 10 | Dependency, batasan keamanan, dan rencana perbaikan didokumentasikan | **Selesai** | Tercantum pada `README.md` Tugas 12 (strategi migrasi ke `flutter_secure_storage` untuk perangkat Android/iOS). |
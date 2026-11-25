# Catatan Hasil Build dan Pemeriksaan — v1.0.0-rc.1

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Daftar Pemeriksaan Build & Lingkungan

- [x] `flutter pub get` dijalankan — selesai tanpa konflik dependensi.
- [x] `flutter analyze` dijalankan — hasil: `No issues found!`.
- [x] `flutter run -d chrome` dijalankan — seluruh alur terintegrasi, tata letak responsif (`400px` dan `900px`), keadaan kosong, dan keadaan gagal berjalan tanpa overflow.
- [x] `flutter build web --release` dijalankan — berhasil menghasilkan paket rilis pada direktori `build/web`.
- [ ] **Catatan Emulator Android & `flutter build apk --release`:** Sesuai ketentuan pelaporan jujur pada panduan Tugas 14, pengujian utama pada perangkat ini dijalankan pada target Web (`Chrome`). Untuk menjalankan build APK Android pada perangkat Anda, pastikan Android SDK & emulator terpasang (`flutter doctor`), jalankan `flutter emulators --launch <id>`, `flutter build apk --release`, dan `flutter install` (berkas keluaran di `build/app/outputs/flutter-apk/app-release.apk`).
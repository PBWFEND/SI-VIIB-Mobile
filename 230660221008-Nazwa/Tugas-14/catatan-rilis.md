# Catatan Rilis (Release Notes) — Candidate Release

| Bagian | Isi |
|:-------|:----|
| **Versi** | `1.0.0-rc.1` |
| **Tanggal build** | 25 November 2026 |
| **Target** | Web (Google Chrome) dan Android (konfigurasi project siap build) |
| **Fitur utama** | 1. Dashboard ringkasan status pengaduan fasilitas kampus (`Total`, `Menunggu`, `Diproses`, `Selesai`).<br>2. Daftar tiket terpusat (`PengaduanRepository`) dengan penyaringan status (`ChoiceChip`).<br>3. Form pengajuan pengaduan baru (`HalamanFormPengaduan`) dengan validasi input berlapis (`PengaduanValidator`) dan lampiran foto.<br>4. Halaman/panel detail pengaduan berdasarkan `id` unik dengan pembaruan status real-time dan konfirmasi hapus (`AlertDialog`).<br>5. Tata letak responsif 1 kolom (`< 720 px`) dan 2 kolom (`>= 720 px`) berbasis `LayoutBuilder`. |
| **Perbaikan pada versi ini** | 1. Penyatuan model data tunggal `Pengaduan` dan `enum StatusPengajuan` di seluruh halaman.<br>2. Sinkronisasi otomatis daftar tiket setelah penambahan, pembaruan status, atau penghapusan data.<br>3. Penyeragaman tema Material 3 (`ColorScheme` & `TextTheme`), target sentuh `>= 48 px`, serta penambahan tampilan khusus untuk keadaan memuat, kosong, dan gagal. |
| **Batasan pengujian** | 1. Pengujian antarmuka dan build release telah dijalankan pada target Web (`flutter build web --release` dan Google Chrome).<br>2. Pengujian langsung pada emulator/perangkat fisik Android belum dijalankan karena lingkungan praktikum menggunakan skenario standar (target Web Chrome); detail status toolchain tercatat di `bukti-build/catatan-build.md`. |
| **Cara menjalankan** | Masuk ke folder `tugas-14/`, jalankan `flutter pub get`, lalu jalankan `flutter run -d chrome` (atau buka hasil build pada `build/web/`). |
| **Versi Flutter dan Dart** | Flutter SDK `3.x` (Stable) • Dart SDK `>=3.0.0 <4.0.0` (sesuai `pubspec.yaml` dan `flutter --version`). |
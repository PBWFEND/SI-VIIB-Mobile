# Catatan Rilis Candidate Release — Kantin Kampus Digital

| Bagian | Isi |
| :--- | :--- |
| **Versi** | `1.0.0-rc.1` |
| **Tanggal Build** | 16 Desember 2026 |
| **Target** | Flutter Web (`build/web`) & Android APK (`build/app/outputs/flutter-apk/app-release.apk`) |
| **Fitur Utama** | 1. Daftar antrean pesanan terpusat dengan filter status (`Semua`, `Menunggu`, `Sedang Dimasak`, `Siap Diambil`).<br>2. Halaman/panel detail pesanan berbasis kunci unik `id` dengan pembaruan status langsung.<br>3. Form pembuatan pesanan baru dengan validasi berlapis dan pencegahan *double-submit*. |
| **Perbaikan pada Versi Ini** | • Menyatukan model `PesananKantin` dan enum `StatusPesanan` lintas halaman.<br>• Tata letak responsif 1 kolom (`< 720px`) dan 2 kolom (`>= 720px`) menggunakan `LayoutBuilder`.<br>• Pemisahan tampilan keadaan kosong dan keadaan gagal serta target sentuh minimal `48px`. |
| **Batasan Pengujian** | Pengujian antarmuka dan build release web telah dijalankan pada Google Chrome; pemasangan APK pada emulator/perangkat fisik Android bergantung pada ketersediaan Android SDK lokal (dicatat apa adanya pada `bukti-build/hasil-build.md`). |
| **Cara Menjalankan** | Jalankan `flutter pub get` lalu `flutter run -d chrome` atau buka hasil kompilasi pada folder `build/web`. |
| **Versi Flutter dan Dart** | Flutter SDK 3.x (Material 3) / Dart SDK 3.x |
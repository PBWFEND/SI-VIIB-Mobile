# Tugas 14: Integrasi Project dan Candidate Release — Pengaduan Fasilitas Kampus (`v1.0.0-rc.1`)

* **Nama:** Nazwa Umaira Nanindia Ramdhani
* **NIM:** 230660221008
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pengaduan Fasilitas Kampus

---

## 1. Deskripsi Singkat Candidate Release

Folder `tugas-14/` merupakan versi kandidat rilis (**`1.0.0-rc.1`**) dari aplikasi **Pengaduan Fasilitas Kampus** yang mengintegrasikan fitur autentikasi sesi, daftar tiket pengaduan terpusat, filter status, formulir pelaporan dengan validasi berlapis, pembaruan status penanganan, serta tata letak responsif berbasis `LayoutBuilder`.

---

## 2. Daftar Berkas Artefak Tugas 14

* **`ringkasan-integrasi.md`:** Penjelasan alur utama terintegrasi, kontrak model `Pengaduan`, sumber data `PengaduanRepository`, dan diagram alur data.
* **`checklist-uiux.md`:** Perbandingan kondisi sebelum dan sesudah penyempurnaan tema, hierarki visual, tata letak responsif (`400 px` & `900 px`), keadaan antarmuka, dan aksesibilitas.
* **`catatan-rilis.md`:** Informasi versi `1.0.0-rc.1`, fitur utama, perbaikan, batasan pengujian, dan cara menjalankan aplikasi.
* **`skenario-uji-penerima.md`:** 7 langkah skenario uji penerima (*User Acceptance Test*) yang dapat dijalankan penguji lain secara mandiri.
* **`bukti-build/`:** Catatan hasil eksekusi `flutter analyze`, `flutter test`, dan `flutter build web --release`.
* **`refleksi.md`:** Refleksi pembelajaran integrasi project dan penyempurnaan UI/UX.

---

## 3. Cara Menjalankan dan Verifikasi

```bash
cd tugas-14
flutter pub get
flutter analyze
flutter test
flutter run -d chrome

Deklarasi penggunaan AI: Gemini (Google AI) — membantu memeriksa konsistensi tema ColorScheme, menyusun struktur tata letak responsif LayoutBuilder, dan merapikan format dokumentasi candidate release; seluruh integrasi kode, eksekusi flutter analyze, flutter test, flutter build web --release, serta pengujian skenario penerima diverifikasi secara mandiri oleh penulis.
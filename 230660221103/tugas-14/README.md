# Tugas 14: Integrasi Project dan Candidate Release (`v1.0.0-rc.1`)

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Ringkasan Candidate Release

Versi **`1.0.0-rc.1`** menggabungkan fitur daftar pesanan, filter status, detail pesanan berbasis `id` unik, dan formulir pemesanan tervalidasi ke dalam satu alur terpadu pada aplikasi **Kantin Kampus Digital**. Antarmuka telah disempurnakan menggunakan tema Material 3 terpusat, tata letak responsif dua kolom (`LayoutBuilder` pada breakpoint `720px`), pemisahan keadaan kosong vs gagal, serta target sentuh minimal `48px`.

---

## 2. Struktur Berkas Tugas 14

* `lib/models/pesanan_kantin.dart` — Kontrak model data `PesananKantin` dan enum `StatusPesanan` yang dipakai bersama.
* `lib/main.dart` — Integrasi alur utama, tata letak responsif `LayoutBuilder`, filter, detail, dan form pemesanan.
* `ringkasan-integrasi.md` — Tabel spesifikasi integrasi dan diagram alur perpindahan data.
* `checklist-uiux.md` — Perbandingan kondisi UI/UX sebelum dan sesudah penyempurnaan.
* `catatan-rilis.md` — Catatan versi `1.0.0-rc.1`, fitur utama, batasan, dan cara menjalankan.
* `skenario-uji-penerima.md` — 6 langkah pengujian penerima (*UAT*) beserta hasil aktual.
* `bukti-build/` — Catatan hasil pemeriksaan build (`hasil-build.md`) dan tangkapan layar pengujian responsif.
* `refleksi.md` — Refleksi pembelajaran integrasi dan penyempurnaan UI/UX.

---

## 3. Cara Menjalankan & Membangun Rilis

```bash
cd tugas-14/230660221103-ReinaAnatasyaKusumahPutri
flutter pub get
flutter analyze
flutter run -d chrome
flutter build web --release
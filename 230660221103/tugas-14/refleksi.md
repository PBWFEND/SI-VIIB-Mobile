# Refleksi Tugas 14 — Integrasi Project dan Candidate Release

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Refleksi Pembelajaran

1. Tantangan terbesar saat menyatukan fitur-fitur dari pertemuan sebelumnya adalah memastikan seluruh halaman (daftar, filter, detail, dan form) merujuk pada satu model data (`PesananKantin`), satu tipe status (`StatusPesanan`), dan satu sumber state sehingga perubahan status pada detail langsung terlihat pada daftar tanpa perlu memuat ulang aplikasi.
2. Penerapan `LayoutBuilder` dengan titik henti `720px` serta pengambilan warna dan tipografi dari `Theme.of(context)` terbukti efektif mencegah `RenderFlex overflow` pada layar sempit `400px` sekaligus memaksimalkan ruang dua kolom pada layar lebar `900px`.
3. Pendokumentasian versi `1.0.0-rc.1` dalam catatan rilis dan skenario uji penerima membantu memetakan fitur yang sudah stabil maupun batasan pengujian yang masih perlu dituntaskan sebelum presentasi akhir project.
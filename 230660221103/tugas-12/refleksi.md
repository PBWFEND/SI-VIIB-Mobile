# Refleksi Tugas 12 — Validasi dan Keamanan Praktis

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Refleksi Pembelajaran

1. Risiko keamanan paling penting pada project adalah pengiriman input transaksi yang tidak tervalidasi serta kebocoran atau penyalahgunaan token sesi pengguna apabila komunikasi tidak terenkripsi atau token tidak dihapus saat logout.
2. Mitigasi yang dipilih adalah menerapkan lima validator berlapis pada form Flutter disertai sanitasi karakter, mewajibkan protokol HTTPS sebelum pengiriman data, menerapkan prinsip *least privilege* pada permission perangkat, serta menghapus token sesi secara eksplisit saat logout.
3. Hal yang masih perlu diperbaiki adalah mengintegrasikan penyimpanan token produksi menggunakan `flutter_secure_storage` pada target perangkat Android/iOS serta menghubungkannya dengan mekanisme otorisasi token JWT asli dari backend Sistem Informasi.
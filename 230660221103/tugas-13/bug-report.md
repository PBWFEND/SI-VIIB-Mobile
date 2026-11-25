# Laporan Bug dan Perbaikan Regresi — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Laporan Bug #1 (BUG-01)

| Bagian | Isi |
| :--- | :--- |
| **ID Bug** | `BUG-01` |
| **Skenario Reproduksi** | 1. Buka halaman pemesanan kantin.<br>2. Isi kolom Nama Pemesan (`Reina Anatasya`), Nama Menu (`Ayam Geprek`), dan Jumlah Porsi (`1`).<br>3. Tekan tombol **Simpan Pesanan** dua kali secara beruntun saat jeda pemrosesan asinkron berlangsung. |
| **Expected Result** | Sistem hanya menyimpan **satu** entri pesanan dan mengabaikan ketukan kedua selama proses penyimpanan masih berjalan. |
| **Actual Result** | Sebelum diperbaiki, dua entri pesanan yang identik masuk ke `_daftarPesanan` (`Daftar Pesanan (2)`), menyebabkan duplikasi pesanan di antrean kantin. |
| **Dugaan Penyebab** | Method `_simpanPesanan()` bersifat *asynchronous* (`Future`), namun tombol `FilledButton` tetap aktif (`onPressed: _simpanPesanan`) selama proses `await` berlangsung dan tidak ada variabel penanda (*guard flag*) untuk memblokir pemanggilan ganda. |
| **Perbaikan** | Menambahkan variabel state boolean `_sedangMenyimpan = false` pada `_HalamanPemesananTerujiState`, menambahkan penjagaan `if (_sedangMenyimpan) return;` di awal `_simpanPesanan()`, serta menonaktifkan tombol (`onPressed: _sedangMenyimpan ? null : _simpanPesanan`) dan mengubah label menjadi `'Menyimpan...'` selama proses berjalan (`lib/main.dart`). |
| **Test Regresi** | Dijalankan kembali melalui `TC-04 (Regresi BUG-01)` pada `test/widget_test.dart` serta pengujian regresi pada `TC-01` (simpan normal) dan `TC-02` (validasi kosong) dengan perintah `flutter test`. Seluruh 6 test otomatis lulus (`All tests passed!`). |
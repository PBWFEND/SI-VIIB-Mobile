# Checklist Penyempurnaan UI/UX — Tugas 14

* **Nama:** Nazwa Umaira Nanindia Ramdhani
* **NIM:** 230660221008
* **Kelas:** SI-VIIB

---

## Pemeriksaan Konsistensi Tampilan, Responsivitas, dan Aksesibilitas

| No. | Pemeriksaan | Sebelum | Sesudah | Bukti |
|:---:|:------------|:--------|:--------|:------|
| 1 | **Warna dan tipografi dari tema** | Beberapa warna status dan pesan peringatan ditulis langsung (*hardcoded*) menggunakan `Colors.amber.shade50` dan `Colors.grey.shade900` di dalam widget. | Seluruh warna komponen, kartu, badge status, dan teks diambil dari `Theme.of(context).colorScheme` (`ColorScheme.fromSeed(seedColor: Colors.teal)`) dan `Theme.of(context).textTheme`. | `lib/main.dart` & `lib/models/pengaduan_model.dart` |
| 2 | **Hierarki judul, informasi, dan aksi** | Form input, daftar tiket, dan log bercampur dalam satu kolom vertikal panjang sehingga aksi utama kurang menonjol. | Halaman utama difokuskan pada ringkasan status, satu aksi utama (`FilledButton.icon` *Buat Laporan Kerusakan Baru*), bar filter, dan kartu tiket dengan judul tebal, deskripsi maksimal 2 baris, serta badge status. | `HalamanUtamaTerintegrasi` di `lib/main.dart` |
| 3 | **Tata letak pada lebar 400 piksel** | Tampilan 1 kolom memanjang tanpa penyesuaian antara daftar dan detail. | Pada `constraints.maxWidth < 720` (diuji pada `400 × 800 px`), tampilan tersusun 1 kolom vertikal (`ListView`) tanpa `RenderFlex overflowed`, dan mengetuk kartu membuka `HalamanDetailPengaduan`. | `test/integrasi_uiux_test.dart` (Test 2) & Chrome DevTools `400 px` |
| 4 | **Tata letak pada lebar 900 piksel** | Tampilan tetap 1 kolom sehingga ruang horizontal pada browser desktop/tablet terbuang. | Pada `constraints.maxWidth >= 720` (diuji pada `900 × 800 px`), `LayoutBuilder` menampilkan 2 kolom berdampingan (`Row`): daftar tiket di kiri dan `PanelDetailPengaduan` di kanan. | `test/integrasi_uiux_test.dart` (Test 2) & Chrome DevTools `900 px` |
| 5 | **Keadaan memuat, kosong, dan gagal** | Hanya menampilkan teks daftar kosong biasa tanpa pemisahan antara proses memuat dan gangguan layanan. | Tersedia 3 tampilan khusus: indikator `CircularProgressIndicator` saat memuat, kartu ilustrasi + tombol aksi saat kosong, serta kartu `errorContainer` + tombol **Coba Lagi** saat gagal memuat. | `test/integrasi_uiux_test.dart` (Test 3) |
| 6 | **Target sentuh minimal 48 piksel** | Tinggi tombol mengikuti ukuran default sehingga beberapa tombol aksi kecil kurang nyaman disentuh di layar ponsel. | Tema global `FilledButtonThemeData` dan `OutlinedButtonThemeData` menetapkan tinggi minimum `48 px` (`Size.fromHeight(48)`). | `test/integrasi_uiux_test.dart` (Test 4) |
| 7 | **Label ikon dan kontras teks** | Ikon aksi belum seluruhnya memiliki `tooltip` dan badge status hanya mengandalkan latar warna. | Seluruh `IconButton` dilengkapi `tooltip` (`Muat ulang daftar pengaduan`, `Hapus tiket pengaduan`), pasangan warna memakai `onPrimaryContainer` / `onErrorContainer`, dan badge status menyertakan ikon + teks eksplisit. | `lib/main.dart` & `lib/models/pengaduan_model.dart` |
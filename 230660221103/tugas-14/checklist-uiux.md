# Checklist Penyempurnaan UI/UX — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Tabel Pemeriksaan UI/UX

| No. | Pemeriksaan | Sebelum | Sesudah | Bukti |
| :-: | :--- | :--- | :--- | :--- |
| 1 | **Warna dan tipografi dari tema** | Beberapa warna kartu dan label teks ditulis secara manual (*hardcoded*). | Seluruh warna komponen dan gaya teks mengambil dari `Theme.of(context).colorScheme` dan `textTheme` (`seedColor: Colors.deepOrange`). | `lib/main.dart` (`KantinCandidateReleaseApp` dan `_warnaStatus`) |
| 2 | **Hierarki judul, informasi, dan aksi** | Ukuran judul kartu dan informasi pendukung kurang kontras satu sama lain. | Judul menu memakai `titleMedium` tebal, informasi pemesan memakai `bodySmall` redup, dan aksi utama memakai `FloatingActionButton.extended` / `FilledButton`. | `lib/main.dart` (`_bangunDaftarPesanan`) |
| 3 | **Tata letak pada lebar 400 piksel** | Teks panjang pada kartu pesanan berisiko terpotong atau menimbulkan `RenderFlex overflow`. | Menggunakan `LayoutBuilder` (`constraints.maxWidth < 720`), `Expanded`, dan `TextOverflow.ellipsis` sehingga tampil 1 kolom rapi tanpa overflow. | Pengujian jendela Chrome lebar `400px` (`bukti-build/screenshot-400px.png`) |
| 4 | **Tata letak pada lebar 900 piksel** | Tampilan 1 kolom melebar penuh dan menyisakan banyak ruang kosong di layar lebar. | Pada lebar `>= 720px`, `LayoutBuilder` menampilkan tata letak **2 kolom** (daftar di kiri, panel detail & ubah status di kanan) dan form dibatasi `maxWidth: 640`. | Pengujian jendela Chrome lebar `900px` (`bukti-build/screenshot-900px.png`) |
| 5 | **Keadaan memuat, kosong, dan gagal** | Halaman belum membedakan daftar kosong hasil filter dengan gangguan koneksi. | Keadaan kosong menampilkan ikon struk dan tombol **Tampilkan Semua**, sedangkan keadaan gagal menampilkan ikon jaringan terputus dan tombol **Coba Lagi**. | `lib/main.dart` (`_bangunDaftarPesanan` & `_bangunKeadaanGagal`) |
| 6 | **Target sentuh minimal 48 piksel** | Tombol aksi pada form dan layar kosong menggunakan tinggi bawaan yang sempit. | Seluruh tombol utama (`FilledButton.icon`, `OutlinedButton.icon`) diberi `minimumSize: Size.fromHeight(48)` atau `Size(160, 48)`. | `lib/main.dart` (seluruh tombol aksi utama) |
| 7 | **Label ikon dan kontras teks** | `IconButton` pada `AppBar` belum memiliki deskripsi teks alternatif dan status hanya mengandalkan warna. | `IconButton` dilengkapi `tooltip`, dan setiap lencana status (`Chip`) selalu menampilkan teks label status (`Menunggu`, `Sedang Dimasak`, `Siap Diambil`). | `lib/main.dart` (`AppBar` & `Chip`) |
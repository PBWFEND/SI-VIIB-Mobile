# Tugas 3 PAB — PresentGo (Halaman Riwayat Absensi)

**Nama:** Rian Rianto
**NIM:** 230660221004
**Domain SI:** Absensi organisasi (PT Kencana Makmur Lestari)

## Deskripsi Halaman

Halaman ini menampilkan riwayat absensi karyawan pada hari berjalan sebagai bagian dari aplikasi PresentGo. Bagian atas halaman berisi ringkasan jumlah karyawan yang hadir, izin, dan terlambat dalam tiga kartu sejajar, sedangkan bagian bawah menampilkan daftar karyawan lengkap dengan waktu absen dan status kehadiran masing-masing dalam bentuk daftar yang dapat digulir. Tombol **Absen Sekarang** di pojok kanan bawah mewakili aksi utama pengguna untuk melakukan absensi baru.

## Widget yang Digunakan

| Widget | Peran di halaman |
|---|---|
| `MaterialApp` | Membungkus aplikasi, memuat judul "PresentGo" |
| `Scaffold` | Kerangka halaman: AppBar, body, dan floating action button |
| `Column` | Menyusun ringkasan, judul daftar, dan daftar secara vertikal |
| `Row` | Menyusun tiga kartu ringkasan sejajar, dan menyusun avatar + teks + status pada tiap item daftar |
| `Padding` | Memberi jarak di sekeliling ringkasan dan judul daftar |
| `Expanded` + `ListView.builder` | Menampilkan daftar 5 karyawan yang dapat digulir tanpa overflow |

Layout yang dipakai: **Column, Row, dan ListView.builder** (3 dari 5 jenis yang diminta).

## Data

Data statis berisi 5 entri (melebihi minimal 4), dengan kunci konsisten: `nama`, `tanggal`, `jam`, `status`.

## Refleksi

Bagian yang paling sulit dirangkai adalah `ListView.builder` di dalam `Column`, karena awalnya muncul error `RenderFlex overflow` saat daftar langsung ditempatkan sebagai anak `Column`. Masalah ini terjadi karena `ListView` ingin mengambil tinggi tak terbatas, sedangkan `Column` juga menghitung tinggi berdasarkan isinya. Solusinya adalah membungkus `ListView.builder` dengan `Expanded`, sehingga daftar hanya mengisi sisa ruang yang tersedia di bawah ringkasan dan judul.

## File

- `halaman_aplikasi.dart` — kode halaman
- `widget-tree.png` / `widget-tree.mmd` — diagram widget tree
- `screenshot-halaman.png` — tangkapan layar halaman
- `README.md` — dokumen ini
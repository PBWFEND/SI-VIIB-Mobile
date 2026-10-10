# Tugas 3 --- Halaman Aplikasi Sederhana

-   **Nama:** Ridho Akmal Aulia
-   **NIM:** 230660221024
-   **Kelas:** SI-VIIB
-   **Mata Kuliah:** Pemrograman Aplikasi Bergerak
-   **Domain Sistem:** Aplikasi Absensi Organisasi Mahasiswa
-   **Halaman:** Daftar Kegiatan & Sesi Absensi
-   **Tenggat:** Sebelum Pertemuan 4

## Deskripsi Halaman

Halaman ini merupakan halaman utama aplikasi absensi yang menampilkan
daftar kegiatan organisasi beserta status sesi absensinya (Dibuka,
Ditutup, atau Belum Dibuka). Halaman dibangun menggunakan `MaterialApp`
dengan judul **Absensi Organisasi Mahasiswa** dan `Scaffold` yang berisi
`AppBar` bertema absensi, header sapaan sebagai pengantar, serta
`ListView.builder` untuk menampilkan setiap kegiatan dalam bentuk kartu.

Setiap kartu tersusun dari `Row` yang memuat ikon, judul kegiatan,
detail tanggal dan lokasi, serta badge status berwarna sesuai kondisi
sesi. Data yang ditampilkan masih statis di dalam kode dan pada
pertemuan lanjutan akan diambil dari backend Sistem Informasi.
`FloatingActionButton` disediakan sebagai akses cepat bagi panitia untuk
menambah kegiatan, sesuai kebutuhan #5 pada tabel Tugas 1.

## Layout yang Digunakan

  -----------------------------------------------------------------------
  Layout                              Peruntukan di halaman ini
  ----------------------------------- -----------------------------------
  `Column`                            Menyusun header dan daftar kegiatan
                                      secara vertikal pada `body`
                                      `Scaffold`.

  `Padding`                           Memberi jarak pada header dan isi
                                      `Card`.

  `ListView.builder`                  Menampilkan daftar kegiatan yang
                                      dapat digulir secara efisien.

  `Row`                               Menyusun ikon, teks, dan badge
                                      status dalam satu baris kartu.
  -----------------------------------------------------------------------

## Data yang Ditampilkan

Halaman menampilkan lima entri kegiatan organisasi mahasiswa. Setiap
entri menggunakan kunci data yang konsisten, yaitu `nama`, `tanggal`,
`lokasi`, dan `status`. Status sesi absensi ditampilkan sebagai
**Dibuka**, **Ditutup**, atau **Belum Dibuka**.

## Widget Tree

Diagram widget tree disimpan pada `widget-tree.png`, dengan sumber
diagram pada `widget-tree.mmd`. Struktur utama widget adalah sebagai
berikut:

``` text
MaterialApp
└── HalamanDaftarKegiatan (Scaffold)
    ├── AppBar: "Absensi Organisasi"
    ├── body: Column
    │   ├── Padding → Column (header: sapaan + petunjuk)
    │   └── Expanded → ListView.builder → KartuKegiatan
    │       └── Card → Padding → Row
    │           ├── CircleAvatar (ikon)
    │           ├── Expanded → Column (nama, tanggal • lokasi)
    │           └── Container (badge status)
    └── FloatingActionButton: +
```

## Cara Menjalankan

### Jalur 1 --- DartPad

1.  Buka [DartPad Flutter](https://dartpad.dev/?template=app).
2.  Salin seluruh isi `halaman_aplikasi.dart` ke panel kode.
3.  Tekan **Run** untuk menjalankan dan memeriksa halaman.

### Jalur 2 --- Flutter SDK di Chrome

Jika menggunakan project Flutter yang sudah tersedia, buka PowerShell
dan jalankan:

``` powershell
Set-Location "D:\Kuliah\SI-VIIB-Mobile\230660221024\tugas-3"

# Salin kode halaman ke entry point project Flutter
Copy-Item ".\halaman_aplikasi.dart" `
  "D:\Kuliah\SI-VIIB-Mobile\230660221024\aplikasi-pab\lib\main.dart" -Force

# Jalankan aplikasi di Chrome
Set-Location "D:\Kuliah\SI-VIIB-Mobile\230660221024\aplikasi-pab"
flutter run -d chrome
```

Pastikan Flutter SDK dan Chrome sudah terpasang serta project Flutter
dapat dijalankan.

## Refleksi

Widget layout yang paling sulit saya rangkai adalah `ListView.builder`
ketika ditempatkan di dalam `Column`, karena tanpa `Expanded` atau
`shrinkWrap` dapat muncul masalah batas tinggi yang membuat sebagian
daftar tidak terlihat. Saya juga sempat kesulitan mengatur `Row` pada
kartu kegiatan agar judul yang panjang tidak mendorong badge status
keluar dari tepi kartu. Dari dua kesulitan itu, saya belajar bahwa
memahami batas ruang (`Expanded`) dan arah sumbu (`mainAxisAlignment` vs
`crossAxisAlignment`) lebih penting daripada menambah widget baru.

> Refleksi terdiri dari tepat tiga kalimat. Sesuaikan isinya apabila
> pengalaman saat mengerjakan tugas berbeda dari yang dijelaskan.

## Struktur Berkas

-   `halaman_aplikasi.dart` --- kode halaman aplikasi.
-   `widget-tree.mmd` --- sumber diagram widget tree dalam format
    Mermaid.
-   `widget-tree.png` --- hasil ekspor diagram widget tree.
-   `screenshot-halaman.png` --- tangkapan layar halaman saat dijalankan
    di Chrome.
-   `README.md` --- dokumentasi tugas, cara menjalankan, dan refleksi.

## Bantuan AI

Sebagian struktur widget tree (`MaterialApp` → `Scaffold` → `Column` →
`ListView.builder` → `Card` → `Row`) dan penelusuran masalah tata letak
disusun dengan bantuan AI coding assistant, lalu perlu diperiksa dan
disesuaikan dengan implementasi serta domain Tugas 1.

# Tugas 2 --- Modul Hitung Nilai Keaktifan Anggota Organisasi

-   **Nama:** Ridho Akmal Aulia
-   **NIM:** 230660221024
-   **Kelas:** SI-VIIB
-   **Mata Kuliah:** Pemrograman Aplikasi Bergerak
-   **Domain Sistem:** Aplikasi Absensi Organisasi Mahasiswa
-   **Tenggat:** Sebelum Pertemuan 3

## Deskripsi Singkat

Modul `hitung_nilai.dart` menghitung rata-rata skor keaktifan anggota
organisasi berdasarkan lima komponen penilaian berbobot, lalu menentukan
predikat keaktifan. Modul ini merupakan turunan dari domain Tugas 1
(Aplikasi Absensi Organisasi Mahasiswa): komponen **Kehadiran Kegiatan**
direkap dari data check-in, sedangkan komponen lain menjadi indikator
keaktifan yang dinilai pengurus. Logika ini akan dipakai kembali pada
backend Sistem Informasi di pertemuan lanjutan.

## Aturan Predikat

  Rentang Nilai   Predikat
  --------------- -----------------
  ≥ 86            Sangat Aktif
  76--85          Aktif
  61--75          Cukup Aktif
  \< 61           Perlu Pembinaan

## Cara Menjalankan

Jalankan perintah berikut dari folder yang berisi `hitung_nilai.dart`:

``` bash
dart hitung_nilai.dart
```

Atau melalui PowerShell di Windows:

``` powershell
Set-Location "D:\Kuliah\SI-VIIB-Mobile\230660221024\tugas-2"
dart hitung_nilai.dart
```

## Hasil Keluaran Program

Berikut contoh keluaran yang diharapkan. Setelah menjalankan
`dart hitung_nilai.dart` di komputer Anda, ganti blok ini dengan hasil
asli dari terminal.

``` text
============================================================
Mata Kuliah : Pemrograman Aplikasi Bergerak
Domain      : Aplikasi Absensi Organisasi Mahasiswa
Modul       : Hitung Nilai Keaktifan Anggota
============================================================

Daftar Komponen Penilaian:
  1. Kehadiran Kegiatan — bobot 40, skor 36 (90.0%)
  2. Kontribusi Kepanitiaan — bobot 20, skor 18 (90.0%)
  3. Kedisiplinan Waktu — bobot 15, skor 13 (86.7%)
  4. Partisipasi Rapat — bobot 15, skor 12 (80.0%)
  5. Pengumpulan Laporan — bobot 10, skor 9 (90.0%)

Rata-rata skor: 88.00
Predikat akhir: Sangat Aktif
============================================================
```

> **Catatan:** Keluaran di atas merupakan contoh. Pastikan hasil akhir
> di README sesuai dengan keluaran asli program yang dijalankan secara
> lokal.

## Refleksi

Di antara sintaks dasar Dart pada Pertemuan 2, saya paling sering salah
menggunakan `int.parse` karena lupa bahwa input seperti `'75.5'` atau
string kosong akan melempar exception, bukan mengembalikan nilai
default. Saya juga cenderung memakai `var` untuk semua variabel padahal
`final` dan `const` lebih tepat untuk nilai yang tidak berubah.
Kesalahan ini mengingatkan saya untuk memilih tipe dan keyword deklarasi
berdasarkan peruntukan, bukan sekadar agar program berjalan.

## Struktur Berkas

-   `hitung_nilai.dart` --- modul hitung nilai keaktifan anggota.
-   `README.md` --- dokumentasi, contoh keluaran program, dan refleksi.

## Bantuan AI

Sebagian kerangka fungsi `hitungRataRata`, `predikat`, dan struktur
`main()` disusun dengan bantuan AI coding assistant, lalu diperiksa dan
disesuaikan dengan domain Tugas 1.

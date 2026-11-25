# Quiz Pertemuan 13 — Testing, Debugging, dan Perbaikan

* **Mata Kuliah:** Pemrograman Aplikasi Bergerak
* **Pertemuan:** 13 | **CPMK:** CPMK-4
* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Project:** Kantin Kampus Digital

---

## Soal 1 — Test Case

**Jawaban:**
* **Komponen utama test case:**
  1. **ID Test Case** (misal `TC-01`) untuk identifikasi unik.
  2. **Skenario / Judul Uji** yang menjelaskan fitur atau kondisi yang diuji.
  3. **Kondisi Awal (*Precondition*)** sebelum pengujian dimulai.
  4. **Langkah Pengujian (*Test Steps*)** dan **Data Input** yang dimasukkan.
  5. **Expected Result** (keluaran yang seharusnya terjadi sesuai spesifikasi kebutuhan).
  6. **Actual Result** (keluaran nyata yang diamati setelah pengujian dijalankan) serta **Status** (*Lulus* / *Gagal*).
* **Perbedaan Expected Result dan Actual Result:** *Expected result* adalah perilaku ideal sistem yang dirumuskan **sebelum** pengujian berdasarkan kebutuhan aplikasi, sedangkan *actual result* adalah perilaku nyata yang benar-benar terjadi **saat/setelah** pengujian dijalankan. Apabila keduanya tidak cocok, maka ditemukan bug.

---

## Soal 2 — Jenis Testing

**Jawaban:**
1. **Static Analysis (`flutter analyze`):** Pemeriksaan kode sumber tanpa menjalankan aplikasi untuk mendeteksi kesalahan sintaks, ketidakcocokan tipe data, variabel tidak terpakai, dan pelanggaran aturan *lint*.
2. **Unit Test:** Pengujian terisolasi terhadap fungsi, method, atau class logika terkecil (misalnya menguji fungsi `ValidatorPesanan.validasiPorsi('0')`) tanpa merender tampilan UI.
3. **Widget Test (`flutter_test`):** Pengujian komponen antarmuka Flutter pada lingkungan simulasi cepat untuk memastikan widget dirender dengan benar dan merespons interaksi seperti `tap` atau `enterText`.
4. **Integration Test:** Pengujian alur kerja aplikasi secara menyeluruh (*end-to-end*) pada perangkat nyata atau emulator yang menggabungkan antarmuka, navigasi, dan komunikasi layanan.
5. **Manual Functional Test:** Pengujian langsung oleh manusia dengan menjalankan skenario pengguna nyata pada aplikasi (misalnya menguji penolakan izin kamera pada browser Chrome).

---

## Soal 3 — Widget Test

**Jawaban:**
1. **`pumpWidget()`:** Memasang dan merender widget akar yang akan diuji ke dalam lingkungan simulasi `flutter_test`.
2. **`find`:** Objek pencari (*finder*) untuk menemukan widget tertentu di dalam *widget tree* berdasarkan teks (`find.text`), kunci (`find.byKey`), tipe widget (`find.byType`), atau ikon.
3. **`tap()`:** Mensimulasikan interaksi ketukan jari pengguna pada widget yang ditemukan oleh `find` (seperti tombol simpan atau ikon hapus).
4. **`pump()`:** Memicu pembangunan ulang frame (*rebuild*) widget setelah terjadi perubahan state atau jeda waktu tertentu agar tampilan di lingkungan test diperbarui.
5. **`expect()`:** Melakukan verifikasi (*assertion*) untuk membandingkan hasil aktual pada *widget tree* dengan *expected result* yang diharapkan (misal `findsOneWidget`).

---

## Soal 4 — Debugging

**Jawaban:**
Langkah debugging berbasis bukti untuk menemukan penyebab tombol simpan menghasilkan dua data saat ditekan dua kali:
1. **Reproduksi bug secara konsisten:** Buka form pemesanan, isi seluruh kolom valid, tekan tombol **Simpan Pesanan** dua kali dengan cepat, dan catat *actual result* (muncul 2 item identik di daftar).
2. **Periksa log dan analisis kode:** Telusuri handler `onPressed` pada tombol simpan dan method `_simpanPesanan()` di `lib/main.dart`.
3. **Susun hipotesis penyebab:** Method `_simpanPesanan()` menjalankan operasi asinkron (`await`), tetapi properti `onPressed` tombol tidak dinonaktifkan selama proses berjalan sehingga ketukan kedua ikut memicu eksekusi fungsi yang sama sebelum proses pertama selesai.
4. **Lakukan perbaikan terfokus:** Tambahkan flag state `_sedangMenyimpan`, blokir eksekusi ulang jika `_sedangMenyimpan == true`, dan ubah `onPressed: _sedangMenyimpan ? null : _simpanPesanan`.
5. **Verifikasi ulang:** Jalankan kembali skenario klik ganda untuk memastikan hanya satu pesanan yang tersimpan.

---

## Soal 5 — Regresi

**Jawaban:**
* **Alasan test yang sudah lulus perlu dijalankan kembali:** Perbaikan bug pada satu bagian kode dapat secara tidak sengaja menimbulkan kerusakan baru (*side effect* / regresi) pada alur logika lain yang saling terhubung. Menjalankan ulang test sebelumnya memastikan perilaku yang sudah benar tetap terjaga.
* **Contoh pada form pengajuan (Kantin Kampus Digital):** Setelah menambahkan kondisi `if (_sedangMenyimpan) return;` dan mengubah `onPressed` tombol simpan untuk memperbaiki bug klik ganda (`TC-04`), kita wajib menjalankan ulang `TC-01` (menyimpan pesanan valid secara normal) dan `TC-02` (validasi input kosong) untuk memastikan tombol tidak terkunci permanen dan validasi form tetap berfungsi seperti semula.

---

## Soal 6 — Integritas Testing

**Jawaban:**
Tujuan utama pengujian adalah **menemukan cacat pada kode aplikasi agar kualitas perangkat lunak meningkat**, bukan sekadar mengejar centang hijau pada laporan test. Menghapus *assertion* (`expect`) atau mengubah *expected result* agar cocok dengan perilaku kode yang keliru sama saja dengan **menyembunyikan bug yang sebenarnya** — masalah tetap akan dialami oleh pengguna nyata saat aplikasi digunakan, dan fungsi test sebagai pengaman kualitas menjadi hilang sama sekali.
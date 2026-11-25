# Quiz Pertemuan 11 — Fitur Perangkat Sesuai Kebutuhan

* **Mata Kuliah:** Pemrograman Aplikasi Bergerak
* **Pertemuan:** 11 | **CPMK:** CPMK-3
* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Project:** Kantin Kampus Digital

---

## Soal 1 — Pemilihan Fitur

**Jawaban:**
Pemilihan fitur perangkat harus didasarkan pada analisis keterkaitan antara **aktor pengguna, tujuan spesifik pada proses bisnis, data keluaran yang dihasilkan, serta konsekuensi permission**, bukan sekadar menambahkan fitur perangkat keras sebagai hiasan antarmuka.

* **Contoh pada Project (Kantin Kampus Digital):** Fitur **Kamera & Galeri (`image_picker`)** dipilih untuk membantu aktor mahasiswa (pemesan) dan pengelola stan dalam proses verifikasi pembayaran QRIS secara mandiri. Melalui fitur ini, mahasiswa dapat mengambil foto struk atau memilih tangkapan layar bukti transfer QRIS (`XFile` / bytes gambar) untuk dilampirkan langsung pada formulir pemesanan, sehingga pengelola stan dapat memvalidasi transaksi tanpa antrean fisik di kasir.

---

## Soal 2 — Permission

**Jawaban:**
Fitur perangkat seperti kamera, galeri, lokasi, dan berkas mengakses data pribadi serta perangkat keras sensitif milik pengguna, sehingga sistem operasi (Android, iOS, maupun peramban web) mewajibkan aplikasi meminta **izin akses (*permission*)** secara eksplisit demi melindungi privasi dan keamanan pengguna.

* **Tiga kondisi yang wajib ditangani aplikasi:**
  1. **Permission diminta (*runtime*):** Menampilkan indikator pemrosesan sambil menunggu keputusan pengguna pada dialog izin sistem tanpa membuat antarmuka membeku.
  2. **Permission ditolak (*denied*):** Menangkap *exception* penolakan izin (`PlatformException`), menampilkan pesan edukatif mengenai alasan kebutuhan fitur tersebut bagi proses bisnis, serta menyediakan tombol untuk meminta izin ulang atau mengarahkan pengguna ke pengaturan perangkat.
  3. **Perangkat atau fitur tidak tersedia:** Menangani kondisi ketika perangkat tidak mendukung fitur tertentu (misalnya komputer desktop tanpa kamera) dengan pesan yang jelas dan menyediakan jalur alternatif (seperti memilih file dari galeri).

---

## Soal 3 — Pembatalan Pemilihan

**Jawaban:**
Nilai kembalian `XFile?` yang bernilai **`null`** menandakan bahwa **pengguna secara sadar membatalkan pengambilan foto atau menutup dialog pemilih galeri** sebelum memilih berkas gambar apa pun. Kondisi ini merupakan perilaku interaksi normal dan **bukan merupakan error sistem**.

* **Respons aplikasi yang tepat:** Aplikasi tidak boleh menampilkan kotak kesalahan merah; sebaliknya, aplikasi harus menghentikan indikator *loading*, **mempertahankan state foto yang telah terpilih sebelumnya** (jika sudah ada), serta memberikan umpan balik ringan seperti `SnackBar` informasi bahwa pemilihan dibatalkan.

---

## Soal 4 — Service Layer

**Jawaban:**
* **Tanggung jawab Service Layer (`LampiranFotoService`):** Bertanggung jawab mengisolasi pemanggilan package eksternal (`ImagePicker`), mengatur parameter kompresi/ukuran gambar, membaca bytes file, memvalidasi batas ukuran berkas, serta menerjemahkan penolakan izin (`PlatformException`) maupun pembatalan (`null`) menjadi objek hasil terstruktur tanpa merender widget UI secara langsung.
* **Alasan tidak ditulis langsung di dalam widget:**
  1. **Pemisahan tanggung jawab (*Separation of Concerns*):** Widget UI tetap bersih dan berfokus pada pengelolaan state tampilan serta tata letak antarmuka.
  2. **Kemudahan penggunaan ulang & pengujian:** Logika akses perangkat dapat dipanggil ulang pada halaman lain tanpa duplikasi kode serta memudahkan pengujian terisolasi apabila package atau sumber data diganti.

---

## Soal 5 — State Fitur Perangkat

**Jawaban:**
Lima state minimal yang perlu ditangani antarmuka saat mengintegrasikan fitur perangkat adalah **Loading**, **Berhasil**, **Dibatalkan**, **Permission Ditolak**, dan **Error Perangkat/Validasi**.

* **Perbedaan perlakuan ketiga kondisi utama:**
  1. **Berhasil:** Menyimpan objek hasil (`HasilPilihFoto`) ke dalam state dan menampilkan pratinjau visual gambar (`Image.memory`) beserta informasi nama dan ukuran berkas.
  2. **Dibatalkan:** Tidak menimpa atau menghapus data gambar yang sudah tersimpan di state sebelumnya serta tidak memicu tampilan error.
  3. **Permission Ditolak:** Menampilkan panel peringatan khusus yang menjelaskan mengapa izin akses dibutuhkan dan menyediakan tombol aksi untuk mencoba meminta izin kembali.
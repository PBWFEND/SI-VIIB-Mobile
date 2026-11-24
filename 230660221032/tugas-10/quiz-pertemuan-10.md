# Quiz Pertemuan 10 — Integrasi Data dan Proses Bisnis Sistem Informasi

**Mata Kuliah:** Pemrograman Aplikasi Bergerak  
**Nama:** Deyna Angeliawati Zahara  
**NPM:** 230660221032  
**Kelas:** SI VII B  

## Soal 1 — Integrasi Data
Integrasi data pada aplikasi mobile adalah proses menggabungkan data dari dua atau lebih sumber (endpoint REST API) yang terpisah menjadi satu informasi utuh agar bisa menjalankan suatu proses bisnis di halaman aplikasi. Secara teknis, proses ini dilakukan dengan mencocokkan nilai kunci (*key*) yang sama di antara model data yang berbeda sebelum ditampilkan ke layar.

* **Contoh pada project (RadiAct — UNSAP Radio):** Pada fitur jadwal produksi siaran, informasi jadwal konten diambil dari endpoint `/posts` sedangkan nama serta email Penanggung Jawab (PJ) divisi diambil dari endpoint `/users`, lalu keduanya disatukan ke dalam model `JadwalTerintegrasi` agar setiap kartu jadwal langsung menampilkan nama penanggung jawabnya.
* **Identifier penghubung:** Field **`userId`** pada data jadwal (`/posts`) dicocokkan dengan field **`id`** pada data pengguna (`/users`).

## Soal 2 — `Future.wait`
`Future.wait` digunakan ketika aplikasi perlu memanggil beberapa endpoint secara bersamaan (*paralel*) karena permintaan-permintaan tersebut **tidak saling bergantung** satu sama lain. Secara teknis, menjalankan request secara bersamaan menghindari waktu tunggu yang menumpuk (*blocking* berurutan) sehingga total waktu *loading* hanya mengikuti durasi request yang paling lama, bukan penjumlahan waktu semua request. Pada project **RadiAct**, `Future.wait` dipakai untuk memanggil `ambilDaftarPengguna()` (`/users`) dan `ambilDaftarJadwal()` (`/posts`) secara bersamaan.

Sebaliknya, request **harus dijalankan secara berurutan** (*sequential* dengan `await` satu per satu) apabila hasil dari request kedua bergantung pada data atau identifier yang baru didapat dari response request pertama. Contohnya, jika aplikasi harus mengambil detail profil pengguna dengan `GET /users/{userId}` terlebih dahulu sebelum memanggil `GET /posts?userId={userId}` menggunakan ID yang baru diperoleh dari response pertama.

## Soal 3 — Model dan `fromJson`
Agar model transaksi seperti `DataPengajuan` (atau pada project **RadiAct** berupa model `DataJadwal`) dapat menghubungkan data pengguna dengan data utama, field yang dibutuhkan minimal meliputi:
* **`id`**: identitas unik pengajuan atau jadwal.
* **`userId`**: *foreign key* atau identifier penghubung yang merujuk pada `id` milik model pengguna (`DataPengguna`).
* Field pendukung proses bisnis seperti **`status`** (misalnya *Progres*, *Tayang*, *Terkendala*) serta informasi detail lainnya seperti judul dan tanggal.

**Cara `fromJson` menangani field yang tidak tersedia:**
Di dalam `factory fromJson`, setiap pembacaan nilai dari `Map<String, dynamic>` dilakukan dengan melakukan *type casting* secara *nullable* (misalnya `json['userId'] as int?` atau `(json['userId'] as num?)?.toInt()`) lalu digabungkan dengan operator *null-coalescing* (`??`) untuk memberikan nilai bawaan (*default*). Pada project **RadiAct**, misalnya `id: (json['id'] as num?)?.toInt() ?? 0` dan `judul: json['title'] as String? ?? 'Program Tanpa Judul'`. Secara teknis, cara ini mencegah aplikasi mengalami *runtime crash* (`TypeError` atau `Null check operator used on a null value`) ketika server mengembalikan field bernilai `null` atau struktur JSON tidak lengkap.

## Soal 4 — Service Layer
* **Tanggung jawab Service Layer (`IntegrasiService`):** Bertugas menangani komunikasi jaringan (`http.get`), memeriksa kode status HTTP, menerapkan `try-catch` dan `timeout`, mengurai teks JSON menjadi objek model Dart, menggabungkan data antar-endpoint berdasarkan identifier (`userId`), serta memvalidasi aturan proses bisnis (seperti aturan perubahan status jadwal).
* **Tanggung jawab Widget (`HalamanIntegrasiJadwal`):** Bertugas memanggil method dari service layer, mengelola state tampilan layar (*loading*, *sukses*, *kosong*, *error*), dan merender antarmuka pengguna berdasarkan data yang sudah siap pakai.

**Alasan penggabungan data tidak ditulis langsung di dalam widget:**
Method `build` pada widget dapat dipanggil berulang kali oleh Flutter setiap kali terjadi perubahan state atau pembaruan layar. Jika pemanggilan API, parsing JSON, dan penggabungan data diletakkan di dalam widget, proses jaringan bisa tereksekusi berulang kali secara tidak terkendali, membuat kode sulit diuji (*debug*), serta mencampuradukkan logika bisnis dengan kode antarmuka sehingga perubahan pada struktur API memaksa mengubah kode tampilan.

## Soal 5 — Status Halaman
Pada halaman integrasi data, minimal ada **4 state** yang perlu ditangani:
1. **State Loading (`_sedangMemuat = true`):** Ditampilkan saat proses `Future.wait` masih berjalan mengambil data dari beberapa endpoint (ditampilkan menggunakan indikator memuat).
2. **State Data Berhasil (`Sukses`):** Ditampilkan ketika data gabungan berhasil diperoleh dan memiliki isi untuk dirender ke daftar kartu.
3. **State Data Kosong (`Empty State`):** Ditampilkan ketika request ke server sebenarnya berhasil, tetapi daftar datanya kosong (`isEmpty`) atau hasil filter status tidak menemukan jadwal yang cocok.
4. **State Error (`_pesanError != null`):** Ditampilkan ketika terjadi kegagalan teknis seperti koneksi terputus, *timeout*, atau status code error (`404`/`500`), disertai tombol **Coba Lagi**.

**Alasan kondisi data kosong perlu dibedakan dari kondisi error:**
Secara teknis dan dari sisi pengalaman pengguna (*UX*), kedua kondisi ini memiliki penyebab dan solusi yang berbeda. Kondisi **data kosong** berarti jalur komunikasi ke server berjalan normal dan tidak ada kerusakan sistem, hanya saja belum ada data yang tersedia atau sesuai kriteria filter sehingga pengguna tidak perlu menekan tombol perbaikan koneksi. Sebaliknya, kondisi **error** menandakan adanya gangguan jaringan atau server yang membutuhkan tindakan pemulihan, seperti menampilkan pesan penyebab gangguan dan menyediakan tombol **Coba Lagi** untuk memicu ulang request ke service.
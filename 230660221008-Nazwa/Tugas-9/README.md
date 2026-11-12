# Tugas 9: Integrasi REST API — Pengaduan Fasilitas Kampus

* **Nama:** Nazwa Umaira Nanindia Ramdhani
* **NIM:** 230660221008
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pengaduan Fasilitas Kampus

---

## Deskripsi Implementasi

Aplikasi **Pengaduan Fasilitas Kampus** kini terhubung dengan layanan backend melalui REST API menggunakan package `http` sehingga daftar laporan kerusakan dapat dimuat secara terpusat (`GET`) dan laporan baru dapat dikirimkan ke server (`POST`). Logika jaringan diisolasi secara terpisah di dalam class `PengaduanApiService` pada file `service-api.dart` lengkap dengan deserialisasi `fromJson`, serialisasi `toJson`, batas waktu `timeout`, dan blok `try-catch`[cite: 23, 32]. Sementara itu, antarmuka pengguna pada `halaman-api.dart` menangani tiga kondisi siklus hidup data secara visual, yaitu indikator *loading*, tampilan daftar *sukses* menggunakan `ListView.builder`, serta pesan *error* informatif yang dilengkapi tombol **Coba Lagi**[cite: 23, 32].

---

## Daftar Berkas

* `service-api.dart` — Model data `LaporanFasilitas` (`fromJson` & `toJson`) serta layanan HTTP `PengaduanApiService` (`GET` & `POST`)[cite: 23, 32].
* `halaman-api.dart` — Antarmuka utama aplikasi yang mengelola state *loading*, *sukses*, *error*, dan formulir pengiriman laporan baru[cite: 23, 32].
* `catatan-integrasi-api.md` — Dokumentasi teknis kontrak endpoint, struktur model data, dan strategi penanganan error[cite: 23, 32].
* `screenshot-loading.png` — Bukti tangkapan layar saat aplikasi memuat data dari server[cite: 23, 32].
* `screenshot-sukses.png` — Bukti tangkapan layar saat data daftar maupun hasil kirim laporan tampil[cite: 23, 32].
* `screenshot-error.png` — Bukti tangkapan layar saat simulasi endpoint gagal dan tombol pemulihan tampil[cite: 23, 32].

---

## Refleksi Pembelajaran

Bagian yang paling sulit dipahami dalam integrasi REST API adalah memadukan pemrograman asynchronous (`async`/`await`) dengan pengelolaan tiga kondisi state antarmuka agar tampilan layar tetap sinkron selama menunggu respons jaringan[cite: 23, 32]. Hal ini menantang karena transisi status dari loading menuju sukses maupun error harus dikendalikan secara cermat menggunakan `setState()` serta pengecekan `mounted` supaya aplikasi tidak mengalami error ketika halaman ditutup sebelum request selesai. Kendala tersebut berhasil diatasi dengan memisahkan seluruh logika komunikasi jaringan ke dalam lapisan `PengaduanApiService` yang dilengkapi blok `try-catch` dan batas waktu `timeout` sehingga kode tampilan menjadi jauh lebih rapi serta mudah diuji[cite: 23, 32].

---

## Deklarasi Penggunaan AI

Deklarasi penggunaan AI: Gemini (Google AI) — membantu menjelaskan pemetaan field JSON ke factory constructor `fromJson` serta struktur pemisahan lapisan service dan penanganan error; kode, pengujian di DartPad, dan dokumentasi diverifikasi oleh penulis.
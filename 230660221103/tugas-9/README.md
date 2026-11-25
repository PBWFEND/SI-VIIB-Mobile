# Tugas 9: Integrasi REST API pada Flutter

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Deskripsi Singkat Tugas

Tugas ini menghubungkan aplikasi **Kantin Kampus Digital** dengan layanan REST API menggunakan package `http` melalui lapisan terpisah **`KantinApiService`** (`service-api.dart`) dan antarmuka **`HalamanPesananApi`** (`halaman-api.dart`). Aplikasi mendukung pengambilan daftar pesanan melalui `HTTP GET`, pengiriman pesanan baru melalui `HTTP POST` dengan header `application/json`, pemetaan JSON menggunakan `PesananApi.fromJson`, serta pengelolaan tiga keadaan visual (*loading*, *sukses*, dan *error* dengan tombol coba lagi).

---

## 2. Daftar Berkas

* `service-api.dart` — Model `PesananApi` (`fromJson`/`toJson`) dan lapisan `KantinApiService` (`GET`, `POST`, `try-catch`, dan `timeout`).
* `halaman-api.dart` — Antarmuka utama yang menampilkan indikator loading, daftar data sukses, tampilan error + tombol *retry*, serta form kirim pesanan `POST`.
* `screenshot-loading.png` — Tangkapan layar indikator `CircularProgressIndicator` saat data sedang dimuat dari server[cite: 25, 26].
* `screenshot-sukses.png` — Tangkapan layar daftar pesanan yang berhasil dimuat dari endpoint REST API[cite: 25, 26].
* `screenshot-error.png` — Tangkapan layar pesan kesalahan ramah pengguna dan tombol **Coba Lagi** saat simulasi URL endpoint gagal diakses[cite: 25, 26].
* `catatan-integrasi-api.md` — Dokumentasi kontrak endpoint HTTP, struktur pemetaan JSON ke model Dart, dan strategi penanganan error[cite: 25, 26].

---

## 3. Refleksi

Bagian yang paling menantang untuk dipahami adalah **menyelaraskan eksekusi *asynchronous* (`Future`, `async`/`await`) dengan perubahan tiga state antarmuka (*loading*, *sukses*, dan *error*) serta menjaga keamanan tipe data saat mengurai JSON (`fromJson`)** agar aplikasi tidak berhenti mendadak ketika terjadi keterlambatan jaringan atau kunci JSON bernilai `null`[cite: 25, 26]. Pemisahan kode HTTP ke dalam class `KantinApiService` terbukti membuat alur logika di dalam widget jauh lebih rapi dan mudah diuji. Melalui pengerjaan Tugas 9 ini, saya memahami bagaimana aplikasi mobile bertindak sebagai *client* yang berkomunikasi dengan server terpusat secara andal.

---

Deklarasi penggunaan AI: Gemini — membantu memvalidasi struktur factory constructor `fromJson` dengan penanganan null dan manajemen flag state loading/error pada widget; seluruh implementasi, pengujian tiga kondisi, dan catatan teknis diverifikasi oleh penulis[cite: 25, 26].
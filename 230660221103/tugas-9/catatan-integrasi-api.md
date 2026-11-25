# Catatan Integrasi API — Tugas 9

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Endpoint yang Digunakan

| Operasi | Metode HTTP | URL Endpoint | Payload Request | Status Code Sukses |
| :--- | :--- | :--- | :--- | :---: |
| **Ambil daftar pesanan** | `GET` | `https://jsonplaceholder.typicode.com/posts` | — | `200 OK` |
| **Kirim pesanan baru** | `POST` | `https://jsonplaceholder.typicode.com/posts` | `{"title": "Nasi Goreng Spesial", "body": "Reina - 2 Porsi", "userId": 1}` | `201 Created` |

---

## 2. Struktur Model Data (`PesananApi`)

| Field | Tipe Dart | Key JSON | Sumber Nilai |
| :--- | :--- | :--- | :--- |
| `id` | `int` | `"id"` | **Server** (ID unik transaksi yang dikembalikan backend, default `0` jika null) |
| `namaMenu` | `String` | `"title"` | **Form / Server** (Nama menu pesanan mahasiswa, default `'Menu Tanpa Nama'`) |
| `rincianPesanan` | `String` | `"body"` | **Form / Server** (Identitas pemesan, jumlah porsi, dan catatan pesanan) |
| `userId` | `int` | `"userId"` | **Sistem** (Identitas pengirim standar bernilai `1`) |

---

## 3. Penanganan Error dan Keadaan Antarmuka

1. **Isolasi Lapisan Service (`KantinApiService`):** Seluruh pemanggilan `http.get` dan `http.post` ditempatkan pada class `KantinApiService` agar kode antarmuka widget tetap bersih dan mudah dirawat.
2. **Batas Waktu & `try-catch`:** Setiap permintaan HTTP dibatasi dengan `.timeout(const Duration(seconds: 10))` dan dibungkus blok `try-catch` yang menangkap `TimeoutException`, kesalahan jaringan (*socket/CORS*), serta kode status non-sukses (`404`, `500`, dll.) menjadi pesan kesalahan yang mudah dipahami mahasiswa.
3. **Tiga State UI & Pencegahan Duplikasi Kirim:** Halaman utama menangani kondisi *loading* (`CircularProgressIndicator`), *sukses* (`ListView.builder`), dan *error* (ikon jaringan terputus, teks error, serta tombol **"Coba Lagi"**). Pada halaman form `POST`, tombol kirim dinonaktifkan (`onPressed: null`) selama `_sedangMengirim == true` agar pesanan tidak terkirim ganda saat jaringan lambat.
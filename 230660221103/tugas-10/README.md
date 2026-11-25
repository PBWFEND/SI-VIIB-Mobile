# Tugas 10: Integrasi Data dan Proses Bisnis — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Endpoint dan Metode HTTP yang Digunakan

| No. | Sumber Data | Metode HTTP | URL Endpoint | Peran dalam Proses Bisnis |
| :-: | :--- | :---: | :--- | :--- |
| 1 | Data Pemesan Mahasiswa | `GET` | `https://jsonplaceholder.typicode.com/users` | Mengambil identitas nama dan email mahasiswa pemesan berdasarkan `id` |
| 2 | Data Transaksi Pesanan | `GET` | `https://jsonplaceholder.typicode.com/posts` | Mengambil rincian menu pesanan, catatan, dan kunci relasi `userId` |

---

## 2. Tabel Pemetaan Field JSON ke Model Dart

### A. Model `DataPemesan` (dari `/users`)

| Key JSON | Field Dart | Tipe Dart | Nilai Default | Keterangan |
| :--- | :--- | :--- | :--- | :--- |
| `"id"` | `id` | `int` | `0` | Kunci utama pemesan (dicocokkan dengan `userId`) |
| `"name"` | `nama` | `String` | `'Mahasiswa Tanpa Nama'` | Nama lengkap mahasiswa pemesan |
| `"email"` | `email` | `String` | `'-'` | Alamat email mahasiswa |

### B. Model `DataPesanan` (dari `/posts`)

| Key JSON | Field Dart | Tipe Dart | Nilai Default | Keterangan |
| :--- | :--- | :--- | :--- | :--- |
| `"id"` | `id` | `int` | `0` | Nomor antrean/ID pesanan |
| `"userId"` | `userId` | `int` | `0` | *Foreign key* penghubung ke `DataPemesan.id` |
| `"title"` | `namaMenu` | `String` | `'Menu Tidak Diketahui'` | Nama menu yang dipesan |
| `"body"` | `catatan` | `String` | `'-'` | Rincian porsi dan catatan pesanan |
| *(Turunan ID)* | `status` | `StatusPesanan` | `StatusPesanan.menunggu` | Status proses bisnis (`menunggu`, `diproses`, `siapDiambil`) |

---

## 3. Identifier Penghubung & Penggunaan `Future.wait`

* **Identifier Penghubung:** Data pesanan dari `/posts` memiliki field **`userId`**, sedangkan data pengguna dari `/users` memiliki field **`id`**. Pada `IntegrasiKantinService`, daftar pemesan dipetakan ke dalam `Map<int, DataPemesan>` menggunakan kunci `id` sehingga setiap pesanan dapat digabungkan dengan nama pemesannya secara cepat ($O(1)$) menjadi model tampilan `PesananTerintegrasi`.
* **Alasan Penggunaan `Future.wait`:** Request `GET /users` dan `GET /posts` tidak saling bergantung (keduanya dapat dipanggil secara bersamaan tanpa menunggu satu sama lain). Dengan `Future.wait`, total waktu tunggu jaringan menjadi jauh lebih singkat dibandingkan memanggil keduanya secara berurutan (*sequential*).

---

## 4. Diagram Alur Request, Penggabungan Data, dan Response

```mermaid
flowchart LR
    UI["HalamanIntegrasiPesanan<br>(Widget UI)"] -->|"1. Panggil service"| SVC["IntegrasiKantinService"]
    SVC -->|"2a. HTTP GET /users"| API1["Endpoint Pemesan"]
    SVC -->|"2b. HTTP GET /posts"| API2["Endpoint Pesanan"]
    API1 -->|"JSON Users"| M1["List<DataPemesan>"]
    API2 -->|"JSON Posts"| M2["List<DataPesanan>"]
    M1 & M2 -->|"3. Future.wait & Gabung via userId"| VM["List<PesananTerintegrasi>"]
    VM -->|"4. Tampilkan + Filter Status"| UI
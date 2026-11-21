# Tugas 10 — Integrasi Data dan Proses Bisnis Sistem Informasi

- **Nama:** Annisa
- **NIM:** 230660221085
- **Kelas:** SI-VIIB

## 1. Endpoint dan Metode HTTP

| Sumber Data | Metode | URL Endpoint | Keterangan |
|:------------|:-------|:-------------|:-----------|
| Data Pemohon | `GET` | `https://jsonplaceholder.typicode.com/users` | Mengambil master data pengguna |
| Data Ruang | `GET` | `https://jsonplaceholder.typicode.com/comments?_limit=10` | Simulasi master data laboratorium |
| Data Pengajuan | `GET` | `https://jsonplaceholder.typicode.com/posts?_limit=15` | Mengambil daftar transaksi pengajuan |

## 2. Pemetaan Field JSON ke Model Dart

| Model Dart | Field Dart | Key JSON API | Nilai Default (`??`) |
|:-----------|:-----------|:-------------|:---------------------|
| `DataPengguna` | `id` (`int`) | `id` | `0` |
| `DataPengguna` | `nama` (`String`) | `name` | `'Pemohon Tidak Diketahui'` |
| `DataPengguna` | `email` (`String`) | `email` | `'-'` |
| `DataRuang` | `id` (`int`) | `id` | `0` |
| `DataRuang` | `namaRuang` (`String`) | `name` | `'Lab Komputer'` |
| `DataPengajuan` | `id` (`int`) | `id` | `0` |
| `DataPengajuan` | `userId` (`int`) | `userId` | `0` |
| `DataPengajuan` | `keperluan` (`String`) | `title` | `'Praktikum Rutin'` |

## 3. Identifier Penghubung & Alasan Penggunaan `Future.wait`

- **Identifier Penghubung:** Data pengajuan digabungkan dengan data pengguna menggunakan `userId`, dan digabungkan dengan master ruangan menggunakan `roomId` menjadi objek `DataPengajuanRingkas`.
- **Alasan Penggunaan `Future.wait`:** Ketiga endpoint (`/users`, `/comments`, dan `/posts`) bersifat independen (tidak saling menunggu parameter satu sama lain). Penggunaan `Future.wait` memungkinkan ketiga request dikirim secara paralel sehingga total waktu muat halaman jauh lebih cepat dibandingkan pemanggilan berurutan.

## 4. Diagram Alur Request dan Response

```mermaid
flowchart LR
    UI[HalamanDaftarTerintegrasi] -->|1. Panggil Service| SVC[IntegrasiService]
    SVC -->|2. Future.wait Paralel| API1[GET /users]
    SVC -->|2. Future.wait Paralel| API2[GET /comments]
    SVC -->|2. Future.wait Paralel| API3[GET /posts]
    API1 & API2 & API3 -->|3. JSON Response| SVC
    SVC -->|4. Join via userId & roomId| VM[List DataPengajuanRingkas]
    VM -->|5. Render UI & Filter Status| UI
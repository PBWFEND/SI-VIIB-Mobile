# Ringkasan Integrasi Project — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Spesifikasi Alur Utama Terintegrasi

| Bagian | Isi |
| :--- | :--- |
| **Nama Alur** | Alur Pemesanan, Pemantauan Antrean, Penyaringan Status, dan Pembaruan Progres Pesanan Kantin |
| **Halaman yang Terlibat** | 1. Halaman Utama Daftar Antrean & Filter (`HalamanUtamaTerintegrasi`)<br>2. Halaman / Panel Detail Pesanan & Ubah Status (`_bangunPanelDetail`)<br>3. Halaman Form Tambah Pesanan Tervalidasi (`HalamanFormPesanan`) |
| **Model Data yang Dipakai** | Satu kontrak model bersama **`PesananKantin`** (`lib/models/pesanan_kantin.dart`) dengan kunci unik `id` (`KTN-001`, dst.) dan method *immutable* `salinDengan()`. |
| **Status yang Dipakai** | Satu tipe enumerasi bersama **`StatusPesanan`** (`menunggu`, `diproses`, `siapDiambil`) yang menggantikan teks bebas lintas halaman. |
| **Fitur yang Terintegrasi** | 1. **Read & Filter Status:** Menampilkan daftar antrean dan menyaring berdasarkan `StatusPesanan` tanpa merusak data asli.<br>2. **Detail & Update Status:** Membuka detail berdasarkan `id` unik dan memperbarui status yang langsung tersinkron ke daftar.<br>3. **Create dengan Validasi:** Mengirim pesanan baru melalui form tervalidasi dan langsung menambahkannya ke daftar utama. |
| **Batasan yang Masih Ada** | Data terintegrasi saat ini dikelola pada satu sumber state terpusat di memori sesi aplikasi; sinkronisasi backend multi-perangkat dan penyimpanan token `flutter_secure_storage` dijadwalkan untuk rilis produksi berikutnya. |

---

## 2. Diagram Alur Integrasi & Perpindahan Data

```mermaid
flowchart LR
    A["Halaman Utama<br>(Daftar Pesanan)"] -->|"Ketuk kartu (kirim id)"| B["Halaman / Panel Detail<br>(PesananKantin)"]
    B -->|"Ubah StatusPesanan"| A
    A -->|"Tekan Buat Pesanan"| C["Halaman Form Pesanan<br>(Validator Berlapis)"]
    C -->|"Pop bawa objek PesananKantin"| A
    A -->|"Pilih FilterChip"| D["Daftar Tersaring<br>(StatusPesanan)"]
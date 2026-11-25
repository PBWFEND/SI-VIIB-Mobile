# Information Architecture — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Inventaris Layar (Berdasarkan Tabel Pemetaan Tugas 4)

| No. | Nama Layar | Kategori Peran | ID Kebutuhan yang Dipenuhi | Prioritas |
| :-: | :--- | :--- | :--- | :--- |
| 1 | **Halaman Utama (Katalog Menu)** | Mahasiswa Pemesan | F-01 (Lihat daftar menu & stok), F-02 (Cari/filter menu) | Must & Should |
| 2 | **Halaman Detail Menu** | Mahasiswa Pemesan | F-03 (Tambah menu & porsi ke keranjang) | Must |
| 3 | **Halaman Keranjang Pesanan** | Mahasiswa Pemesan | F-04 (Konfirmasi & kirim pesanan) | Must |
| 4 | **Halaman Status & Riwayat Pesanan** | Mahasiswa Pemesan | F-05 (Pantau status pesanan), F-08 (Beri ulasan) | Must & Could |
| 5 | **Halaman Kelola Pesanan & Menu (Mode Penjual)** | Pengelola Stan | F-06 (Ubah status pesanan), F-07 (Ubah status stok habis) | Must & Should |

---

## 2. Diagram Information Architecture (IA)

```mermaid
flowchart TD
    U["Layar Utama:<br>Halaman Utama (Katalog Menu)<br>[F-01, F-02]"] --> D["Layar Pendukung 1:<br>Halaman Detail Menu<br>[F-03]"]
    U --> K["Layar Pendukung 2:<br>Halaman Keranjang Pesanan<br>[F-04]"]
    U --> R["Layar Pendukung 3:<br>Halaman Status & Riwayat Pesanan<br>[F-05, F-08]"]
    P["Layar Khusus Penjual:<br>Halaman Kelola Pesanan & Menu<br>[F-06, F-07]"]
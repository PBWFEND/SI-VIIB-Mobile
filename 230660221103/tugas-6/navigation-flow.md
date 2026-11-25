# Navigation Flow — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Daftar Route (Berdasarkan Information Architecture Tugas 5)

| Nama Route | Nama Layar | Dibuka Dari | Data yang Dikirim | ID Kebutuhan | Status Route |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `/` | **Halaman Utama (Katalog Menu)** | Awal aplikasi dibuka | — | F-01 (Lihat daftar menu & stok) | `initialRoute` |
| `/detail` | **Halaman Detail Menu** | Ketukan kartu menu (`pushNamed`) | Objek `DataMenu` (read-only) | F-01 & F-03 (Detail menu & status stok) | Route Dalam |
| `/pesan` | **Halaman Form Pemesanan** | Tombol aksi utama "Pesan Menu" (`pushNamed`) | — (diisi melalui form oleh pengguna) | F-03 & F-04 (Input jumlah porsi, catatan, dan kirim pesanan) | Route Dalam |

---

## 2. Diagram Navigation Flow

```mermaid
flowchart TD
    U["Halaman Utama: Katalog Menu<br>(Route: / — F-01)"] -->|"Ketuk kartu menu<br>pushNamed('/detail', arguments: menu)"| D["Halaman Detail Menu<br>(Route: /detail — F-01, F-03)"]
    D -->|"Tombol Kembali / AppBar Back<br>Navigator.pop(context)"| U
    U -->|"Tombol 'Buat Pesanan'<br>pushNamed('/pesan')"| F["Halaman Form Pemesanan<br>(Route: /pesan — F-03, F-04)"]
    F -->|"Submit valid → SnackBar konfirmasi<br>Navigator.pop(context)"| U
    F -->|"Tombol Batal / Back<br>Navigator.pop(context)"| U
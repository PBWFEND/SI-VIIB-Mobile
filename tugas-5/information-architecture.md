# Infomation Archictecture (IA)

## 1. Inventaris Layar

| Nama Layar | ID Kebutuhan yang di penuhi | Deskripsi Singkat |
|:---|:---|:---|
| *Layar Utama (Daftar Pengajuan Saya)* | F-03 |
Menampilkan daftar riwayat dan status pengajuan yang sedang di proses maupun selesai. |
| *Form Pengajuan Peminjaman* | F-01 | Halaman input untuk membuat penjualan peminjaman baru (tanggal, jam dan durasi). |
| *Layar Cari & Detail Ruang* | F-04 | Halaman untuk mencari daftar laboratorium dan melihat jadwal ketersediaannya. |

## 2. Diagram IA

```memaid
flowchart TD
    H["Layar Utama:<br>Daftar Pengajuan Saya (F-03)"] --> D["Form Pengajuan:<br>Input Data Peminjaman (F-01)"]
    H --> R["Cari Ruang:<br>Daftar & Detail Ruang (F-04)"]

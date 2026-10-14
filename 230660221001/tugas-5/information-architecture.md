# Information Architecture — Sistem Penjualan Beras BSM

## 1. Inventaris Layar

| Layar | ID Kebutuhan yang Dipenuhi | Persona |
|:------|:---------------------------|:--------|
| Halaman Katalog Beras (layar utama) | F-01 (melihat daftar beras), F-02 (tambah ke keranjang) | Rani |
| Halaman Detail Beras | F-02 | Rani |
| Halaman Checkout | F-03 (checkout), F-04 (lihat total & ongkir) | Rani |
| Halaman Konfirmasi Pembayaran | F-05 (unggah bukti transfer) | Rani |
| Halaman Riwayat Pesanan | F-06 (lihat status pesanan) | Rani |
| Halaman Login | F-09 (login sesuai peran) | Rani, Budi |
| Halaman Daftar Pesanan Siap Kirim | F-07 (lihat pesanan siap kirim) | Budi |
| Halaman Detail Pengiriman | F-08 (input nomor resi) | Budi |

## 2. Diagram IA

```mermaid
flowchart TD
    L["Halaman Login<br>(F-09)"]
    L --> K["<b>LAYAR UTAMA KONSUMEN</b><br>Katalog Beras<br>(F-01, F-02)"]
    L --> P["<b>LAYAR UTAMA KARYAWAN</b><br>Daftar Pesanan Siap Kirim<br>(F-07)"]

    K --> D["Detail Beras<br>(F-02)"]
    D --> C["Checkout<br>(F-03, F-04)"]
    C --> B["Konfirmasi Pembayaran<br>(F-05)"]
    K --> R["Riwayat Pesanan<br>(F-06)"]

    P --> DP["Detail Pengiriman<br>(F-08)"]

    style K fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px
    style P fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px
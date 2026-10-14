# Catatan Keputusan UI/UX

## Identitas
- **Nama:** Ghatan Zalfaa Kautsar
- **NIM:** 230660221001
- **Domain:** Sistem Penjualan Beras di Pabrik BSM

## Tabel Keputusan

| Keputusan | Pilihan | Alasan (merujuk kebutuhan/persona/prinsip) |
|:----------|:--------|:--------------------------------------------|
| Warna benih | `Colors.green` (hijau) | Warna hijau diasosiasikan dengan produk pertanian/beras, sehingga konsumen (persona Rani) langsung mengenali konteks aplikasi. Warna aksen dan latar seluruhnya diturunkan dari satu benih lewat `ColorScheme.fromSeed` agar konsisten. |
| Bentuk status | `Chip` berwarna + ternary dari warna tema | Memenuhi prinsip **hierarki visual** dan **feedback** (prinsip 2 & 3). Status "tersedia" memakai `tertiaryContainer`, "habis" memakai `errorContainer`. Warna dari tema, bukan ditulis langsung, agar konsisten bila skema diubah. |
| Posisi aksi utama | `FloatingActionButton.extended` di kanan bawah | Memenuhi prinsip **target sentuh memadai** (prinsip 1). Aksi utama (melihat keranjang, F-02) harus terlihat tanpa menggulir — konsumen Rani memesan di sela waktu istirahat kerja. Tautan teks kecil akan menyulitkan penggunaan satu tangan. |
| Hierarki teks | `textTheme.titleLarge` untuk sapaan, `titleMedium` untuk nama beras, `bodySmall` untuk keterangan | Memenuhi prinsip **hierarki visual** (prinsip 2). Nama beras adalah informasi paling penting pada kartu; harga dan kualitas adalah pelengkap sehingga diredupkan. |
| Keadaan kosong | `Center` + ikon + judul + keterangan | Memenuhi prinsip **feedback** (prinsip 3). Bila katalog kosong, pengguna tidak boleh melihat layar putih tanpa penjelasan — mereka harus tahu bahwa sistem sedang tidak memiliki produk, bukan sedang error. |
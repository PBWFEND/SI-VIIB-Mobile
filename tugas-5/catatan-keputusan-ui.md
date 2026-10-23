# Catatan Keputusan UI/UX

Dokumen ini mencatat keputusan desain antarmuka yang diambil pada perancangan Layar Utama aplikasi peminjaman ruang laboratorium beserta alasan rasionalnya berdasarkan analisis kebutuhan, persona pengguna, dan prinsip antarmuka mobile.

## Tabel Keputusan UI/UX

| Keputusan | Pilihan Anda | Alasan (merujuk kebutuhan/persona/prinsip) |
|:---|:---|:---|
| **Warna benih** | `Colors.indigo` | Memberikan kesan akademis dan formal yang sesuai dengan domain aplikasi kampus, serta menghasilkan kontras tinggi antara teks dan latar belakang untuk menjaga keterbacaan pada layar seluler (Prinsip Keterbacaan & Kontras). |
| **Bentuk status** | `Chip` dengan teks berwarna dinamis menggunakan ekspresi ternary (`Colors.green`, `theme.error`, `Colors.orange`) | Memudahkan mahasiswa dan laboran mengetahui status pengajuan ("Menunggu", "Disetujui", "Ditolak") secara sekilas tanpa perlu membaca detail teks secara menyeluruh (F-03 & Prinsip Feedback). |
| **Posisi aksi utama** | `FloatingActionButton.extended` bertuliskan "Ajukan Peminjaman" di pojok kanan bawah | Memastikan tombol aksi utama mudah dijangkau oleh ibu jari saat penggunaan satu tangan (*thumb zone*), memiliki target sentuh memadai (minimal 48x48 dp), serta tampak menonjol tanpa menghalangi daftar pengajuan (F-01 & Prinsip Target Sentuh). |
| **Hierarki teks** | `titleMedium` cermat/tebal untuk nama ruang lab dan `bodyMedium` redup untuk informasi tanggal dan jam | Menegaskan hierarki visual sehingga mata pengguna langsung tertuju pada informasi lokasi laboratorium terlebih dahulu sebelum melihat detail waktu peminjaman (Prinsip Hierarki Visual). |
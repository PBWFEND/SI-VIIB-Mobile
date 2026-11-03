# Catatan Keputusan UI/UX

| Keputusan | Pilihan Saya | Alasan (merujuk kebutuhan/persona/prinsip) |
| :--- | :--- | :--- |
| **Warna benih (*Seed Color*)** | `Colors.teal` | Mewakili institusi kesehatan/puskesmas yang bersih dan profesional; warna sejuk yang tidak melelahkan mata saat dipandang di luar ruangan (memenuhi kendala pencahayaan terang pada persona Perawat Lapangan). |
| **Bentuk status** | `Chip` label berwarna | Membedakan status "Hadir" (hijau) dan "Dinas Luar" (oranye) dengan latar belakang penuh (Chip) mematuhi prinsip *keterbacaan dan kontras*. Pengguna tidak perlu membaca teks lekat-lekat karena warna sudah memberikan umpan balik status (F-03). |
| **Posisi aksi utama** | `FloatingActionButton.extended` di kanan bawah | Sesuai prinsip antarmuka mobile (*target sentuh*), posisi kanan bawah mudah dijangkau ibu jari kanan. Penggunaan label *extended* ("Absen Sekarang") memastikan fungsi form absensi (F-01) tidak terlewatkan. |
| **Hierarki teks** | Menggunakan `textTheme` dari tema (Judul `titleMedium` tebal, deskripsi reguler) | Mematuhi prinsip *hierarki visual*; pengguna pertama kali akan melihat tanggal absensi (tebal) sebelum rincian lokasi atau jam (redup), membuat penelusuran riwayat lebih efisien. |

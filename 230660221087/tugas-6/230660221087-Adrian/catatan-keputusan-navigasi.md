# Catatan Keputusan Navigasi

| Keputusan | Pilihan Saya | Alasan (merujuk IA/kebutuhan) |
| :--- | :--- | :--- |
| **Nama route** | `/`, `/form`, `/detail` | Sesuai IA Tugas 5; pemberian nama route singkat, *case-sensitive*, dan deskriptif mempermudah pemanggilan `Navigator.pushNamed()` secara terpusat dari MaterialApp. |
| **Data antarlayar** | `Map<String, String>` dari Daftar ke Detail | Sesuai F-03 (Melihat detail riwayat absensi); data bersifat *read-only* karena pegawai tidak diizinkan memanipulasi log kehadiran yang sudah tercatat. |
| **Validator tiap field** | Wajib isi (`trim().isEmpty`) untuk Lokasi GPS dan Catatan | Mencegah anomali pengiriman Form Absensi (F-01) kosong yang sering terjadi akibat sinyal GPS hilang di lapangan, memastikan *database* puskesmas menerima data utuh. |
| **Feedback tiap aksi** | Pesan validasi warna merah di bawah field form, dan `SnackBar` sukses di layar Daftar | Pesan *error inline* spesifik memberitahu perawat bagian mana yang belum lengkap. `SnackBar` dengan pesan sukses konfirmasi (simulasi) menegaskan bahwa proses absensi telah usai dan tervalidasi. |

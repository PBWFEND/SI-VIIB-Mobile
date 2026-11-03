# Model Data

## 1. Daftar Entitas
**Entitas Utama: `DataAbsensi`**

| Field | Tipe Data | Kebutuhan yang Dipenuhi | Penjelasan Sumber Nilai |
| :--- | :--- | :--- | :--- |
| `id` | `String` | Kunci unik (CRUD) | **Sistem**: Dihasilkan otomatis menggunakan `DateTime.now().millisecondsSinceEpoch` saat data dibuat. |
| `lokasi` | `String` | F-01 (Kirim Lokasi GPS) | **Form**: Diinput manual oleh pegawai melalui `TextFormField` di Halaman Form Absensi. |
| `catatan` | `String` | F-01 (Keterangan) | **Form**: Diinput manual oleh pegawai melalui `TextFormField`. |
| `tanggal` | `String` | F-03 (Melihat riwayat) | **Sistem**: Diformat otomatis secara *hardcode/perhitungan* saat data disimpan (misal: mengambil hari ini). |
| `jam` | `String` | F-03 (Melihat riwayat) | **Sistem**: Diformat otomatis dari waktu pengiriman (misal: "08:15"). |
| `status` | `String` | F-04 (Pemantauan TU) | **Sistem/Update**: Default "Menunggu" saat dibuat, dapat diubah ("Divalidasi"/"Ditolak") melalui aksi *Update* di daftar. |

## 2. Keterkaitan Entitas
Saat ini aplikasi masih berfokus pada MVP *Single Entity* (satu daftar absensi pribadi milik satu *User Persona* Perawat), sehingga tidak ada relasi tabel kompleks. Seluruh informasi disatukan dalam satu entitas `DataAbsensi` untuk memudahkan eksekusi CRUD in-memory.

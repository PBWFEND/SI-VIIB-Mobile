# Catatan Keputusan Data

| Keputusan | Pilihan Saya | Alasan (merujuk kebutuhan) |
| :--- | :--- | :--- |
| **Field model** | `id`, `lokasi`, `catatan`, `tanggal`, `jam`, `status` | Diambil langsung dari kebutuhan F-01 (Kirim Lokasi), F-03 (Riwayat Absen), dan F-04 (Status Pemantauan TU). Seluruh tipe field di-set ke `String` dan sifatnya `final` untuk menjaga *immutability*. |
| **Kunci data (id)** | Dibuat otomatis dari `DateTime.now().millisecondsSinceEpoch` | Menjamin nilai `id` selalu unik. Hal ini wajib agar operasi Update dan Delete menggunakan referensi `indexWhere` yang tepat, bukan indeks dinamis `ListView` yang rentan salah sasaran saat data dihapus/diubah urutannya. |
| **Operasi CRUD** | Create (Absen), Read (Riwayat), Update (Validasi Status), Delete (Hapus) | Memenuhi seluruh syarat *Must have* MVP awal. Fitur Update disediakan untuk mensimulasikan validasi pihak TU (F-02/F-04), dan fitur Delete dipasang sebagai antisipasi jika pengguna (perawat) salah merekam lokasi (human error). |
| **Keputusan persistensi** | In-memory `List` *(sementara)* | MVP awal difokuskan pada uji coba logika *State* dan `setState` agar form berjalan tanpa *error* di DartPad. Persistensi permanen (`shared_preferences`) ditunda pengimplementasiannya agar aplikasi tetap bisa diverifikasi via web ringan tanpa mengimpor *package* pihak ketiga, sejalan dengan batas cakupan Pertemuan 7. |

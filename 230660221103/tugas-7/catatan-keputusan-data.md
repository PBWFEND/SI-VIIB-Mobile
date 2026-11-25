# Catatan Keputusan Pengelolaan Data — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Tabel Keputusan Data Lokal

| Keputusan | Pilihan Anda | Alasan (Merujuk Kebutuhan Tugas 4) |
| :--- | :--- | :--- |
| **Field model (`DataPesanan`)** | `id`, `namaPemesan`, `namaMenu`, `jumlahPorsi`, `catatan`, dan `status` bertipe `final` dengan konstruktor `required`[cite: 26, 27] | Menyatukan struktur data dari form pemesanan (Tugas 6) sehingga seluruh informasi yang dibutuhkan penjual dan mahasiswa (**F-03**, **F-04**, **F-05**) terjamin kelengkapannya dan bersifat *immutable*[cite: 26, 27]. |
| **Kunci data (`id`)** | `DateTime.now().millisecondsSinceEpoch.toString()` pada saat objek pesanan dibuat[cite: 26, 27] | Menghasilkan pengenal unik yang tidak berubah meskipun urutan daftar bergeser akibat penghapusan item, sehingga operasi *Update* (`indexWhere`) dan *Delete* (`removeWhere`) selalu tepat sasaran[cite: 26, 27]. |
| **Operasi CRUD per kebutuhan** | **Create** (`add` dari form) untuk **F-04**, **Read** (`ListView.builder`) untuk **F-05**, **Update** (penggantian objek status) untuk **F-06**, dan **Delete** (`removeWhere` + `AlertDialog`) untuk pembatalan pesanan[cite: 26, 27] | Memastikan setiap kebutuhan *Must have* transaksi pesanan dapat dijalankan langsung melalui antarmuka dengan pembaruan layar otomatis melalui `setState()` serta mencegah penghapusan tidak sengaja[cite: 26, 27]. |
| **Keputusan persistensi** | Tahap MVP Tugas 7 menggunakan penyimpanan *in-memory* (`List<DataPesanan>` dalam `State`) dan akan ditingkatkan menggunakan `shared_preferences` / REST API pada tahap lanjutan[cite: 26, 27] | Penyimpanan *in-memory* menjaga kode tetap kompatibel lintas lingkungan (DartPad dan Flutter Web tanpa dependensi eksternal) sambil memvalidasi alur logika CRUD sebelum terhubung ke penyimpanan permanen dan server pada Pertemuan 9–10. |
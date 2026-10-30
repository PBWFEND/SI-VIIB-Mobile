# Catatan Keputusan Data & CRUD - Pengaduan Fasilitas Kampus

| Keputusan Desain | Pilihan Diterapkan | Alasan & Keterkaitan Kebutuhan |
| :--- | :--- | :--- |
| **Pilihan Field Model** | `id`, `fasilitas`, `kategori`, `kendala`, `status`, `pelapor` | Menampung seluruh atribut yang dibutuhkan pengguna untuk pelaporan (F-01, F-02), pemantauan status (F-03), dan tindak lanjut petugas Sarpras (F-04, F-05)[cite: 28]. |
| **Kunci Unik Data (`id`)** | Timestamp (`DateTime.now().millisecondsSinceEpoch`) | Menggunakan timestamp unik sebagai id pembeda antar-laporan, menghindari error saat menghapus atau mengubah data berbasis index array[cite: 33]. |
| **Operasi CRUD** | **Create**: Form Tambah<br>**Read**: `ListView.builder`<br>**Update**: Dialog Status<br>**Delete**: Dialog Hapus | Pemetaan penuh terhadap kebutuhan fungsional: Create memenuhi F-02, Read memenuhi F-01 & F-03, Update memenuhi F-05, dan Delete memenuhi F-06[cite: 28, 33]. |
| **Mekanisme Persistensi** | State In-Memory (`StatefulWidget` + `setState`) | Memenuhi batasan MVP awal tanpa dependensi package eksternal sehingga kode dapat diverifikasi langsung di DartPad maupun Flutter SDK Web. |
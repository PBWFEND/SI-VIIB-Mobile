# Dokumentasi Model Data - Pengaduan Fasilitas Kampus

## 1. Entitas Data Utama

Entitas data utama pada aplikasi ini adalah `LaporanFasilitas`, yang menyimpan seluruh informasi keluhan kerusakan fasilitas kampus[cite: 28, 33, 42].

| Nama Field | Tipe Data | ID Kebutuhan | Sumber Nilai | Keterangan |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `String` | F-05, F-06 | Sistem (`DateTime.now().millisecondsSinceEpoch`) | Kunci unik entitas untuk pencarian update/delete |
| `fasilitas` | `String` | F-01, F-02, F-04 | Input Form (`TextFormField`) | Nama atau identitas fasilitas yang rusak[cite: 28, 29] |
| `kategori` | `String` | F-02, F-03, F-04 | Input Form / Dropdown | Kategori fasilitas (Elektronik, Mebel, Sanitasi, dll.)[cite: 28, 29] |
| `kendala` | `String` | F-02, F-04 | Input Form (`TextFormField`) | Deskripsi detail kerusakan fasilitas[cite: 28, 29] |
| `status` | `String` | F-01, F-05 | Sistem (Default: "Menunggu") / Input Petugas | Status perbaikan ("Menunggu", "Diproses", "Selesai")[cite: 28, 29] |
| `pelapor` | `String` | F-01, F-04 | Sistem / Input Form | Nama pengguna yang mengajukan laporan[cite: 28, 29] |

---

## 2. Penjelasan Sumber Nilai & Keperluan Field

1. **`id`**: Dihasilkan otomatis oleh sistem menggunakan nilai timestamp saat laporan dibuat untuk menjamin keunikan kunci data saat melakukan pembaruan status (`Update`) atau penghapusan data (`Delete`).
2. **`fasilitas`**: Berasal dari input teks pengguna pada form pengaduan untuk mengidentifikasi objek kerusakan[cite: 28, 29].
3. **`kategori`**: Berasal dari pilihan form untuk memudahkan pengelompokan dan pencarian laporan oleh mahasiswa lain maupun petugas Sarpras[cite: 28].
4. **`kendala`**: Berasal dari input deskripsi form agar petugas Sarpras (Pak Kirill) mengetahui tindakan teknis yang perlu disiapkan[cite: 28, 29].
5. **`status`**: Bernilai awal `"Menunggu"` saat laporan dibuat oleh mahasiswa (Felix), dan diperbarui oleh petugas Sarpras menjadi `"Diproses"` atau `"Selesai"`[cite: 28, 29].
6. **`pelapor`**: Mengidentifikasi identitas pengguna yang membuat pengaduan[cite: 28, 29].
# Ringkasan Integrasi Project — Tugas 14

* **Nama:** Nazwa Umaira Nanindia Ramdhani
* **NIM:** 230660221008
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pengaduan Fasilitas Kampus

---

## 1. Tabel Ringkasan Alur Terintegrasi

| Bagian | Isi |
|:-------|:----|
| **Nama alur** | Pengelolaan Siklus Pengaduan Fasilitas Kampus (Login Sesi → Daftar & Filter → Buat Laporan Tervalidasi → Detail & Pembaruan Status / Hapus) |
| **Halaman yang terlibat** | 1. `HalamanUtamaTerintegrasi` (Daftar tiket, ringkasan statistik, filter status, serta panel detail otomatis pada lebar `>= 720 px`)<br>2. `HalamanFormPengaduan` (Form laporan kerusakan dengan validasi berlapis dan lampiran foto)<br>3. `HalamanDetailPengaduan` (Halaman detail tiket beserta pembaruan status dan hapus tiket pada layar sempit `< 720 px`) |
| **Model data yang dipakai** | `Pengaduan` (`lib/models/pengaduan_model.dart`) dengan field `final`: `id`, `nim`, `email`, `lokasi`, `tanggalKejadian`, `deskripsi`, `status`, dan `namaLampiran` serta metode `copyWith()`. |
| **Status yang dipakai** | `enum StatusPengajuan` (`menunggu`, `diproses`, `selesai`) yang menyimpan label tampilan, ikon, serta pemetaan warna berbasis `ColorScheme`, ditambah state antarmuka `_sedangMemuat`, `_pesanErrorMuat`, dan `_sesiAktif`. |
| **Fitur yang terintegrasi** | 1. Autentikasi sesi aman (`SecureSessionTokenStorage` + HTTPS guard)<br>2. Tampilan daftar tiket terpusat (`PengaduanRepository`) dengan ringkasan statistik<br>3. Penyaringan daftar berdasarkan `StatusPengajuan`<br>4. Pembuatan laporan baru (`HalamanFormPengaduan`) dengan `PengaduanValidator` yang langsung menyinkronkan daftar utama<br>5. Tampilan detail berdasarkan `id` unik, pembaruan status (`Menunggu` → `Diproses` → `Selesai`), dan penghapusan tiket dengan konfirmasi `AlertDialog` |
| **Batasan yang masih ada** | 1. Penyimpanan masih berada di memori sesi runtime (`PengaduanRepository`) sehingga data kembali ke 3 tiket awal saat aplikasi di-restart.<br>2. Layanan backend REST API dan pengiriman notifikasi email/push masih disimulasikan secara lokal di lapisan repository. |

---

## 2. Diagram Alur Data dan Navigasi Antarhalaman

```mermaid
flowchart LR
    A["HalamanUtamaTerintegrasi<br>(Sumber Data: PengaduanRepository)"] -->|"1. Ketuk Buat Laporan"| B["HalamanFormPengaduan<br>(Validasi PengaduanValidator)"]
    B -->|"2. Simpan & pop(Pengaduan baru)"| A
    A -->|"3. Filter StatusPengajuan"| A
    A -->|"4a. Layar < 720 px: push(id)"| C["HalamanDetailPengaduan<br>(cariBerdasarkanId(id))"]
    A -->|"4b. Layar >= 720 px: pilih id"| D["PanelDetailPengaduan<br>(Split-View Kanan)"]
    C -->|"5. ubahStatus(id) / hapus(id) -> refresh"| A
    D -->|"5. ubahStatus(id) / hapus(id) -> refresh"| A
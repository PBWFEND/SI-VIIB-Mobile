# Dokumen Kebutuhan dan User Flow — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Deskripsi Aplikasi

**Kantin Kampus Digital** adalah aplikasi bergerak berbasis Flutter yang dirancang untuk menyelesaikan masalah penumpukan antrean fisik di kantin kampus saat jam istirahat, ketidakjelasan stok menu yang masih tersedia, serta kesalahan pencatatan pesanan manual oleh penjual[cite: 18, 19]. Solusi ini diwujudkan dalam bentuk aplikasi mobile (bukan web desktop atau pencatatan kertas) karena karakteristik pengguna kampus yang melakukan pemesanan dalam sesi penggunaan singkat di sela pergantian jam kuliah serta berada dalam konteks bergerak dari ruang kelas menuju area kantin[cite: 18, 19].

---

## 2. User Persona

### Persona 1 — Dinda — Mahasiswa Pemesan

| Komponen | Isi |
| :--- | :--- |
| Nama dan peran | Dinda — Mahasiswa aktif (pemesan makanan/minuman)[cite: 17, 19] |
| Tujuan | Memesan makan siang dengan cepat sebelum keluar kelas dan mengetahui kapan makanan siap diambil tanpa mengantre lama di depan stan[cite: 17, 19] |
| Kendala | Waktu istirahat antar mata kuliah sangat singkat (15–30 menit) dan sering kehabisan menu favorit tanpa tahu sebelumnya[cite: 17, 19] |
| Perangkat dan konteks | Ponsel Android/iOS dengan koneksi seluler kampus; diakses di ruang kelas atau selasar gedung menjelang jam istirahat[cite: 17, 19] |
| Frekuensi penggunaan | 4–5 kali seminggu pada hari perkuliahan aktif[cite: 17, 19] |

### Persona 2 — Bu Siti — Pengelola Stan Kantin

| Komponen | Isi |
| :--- | :--- |
| Nama dan peran | Bu Siti — Penjual / Pengelola Stan Kantin[cite: 17, 19] |
| Tujuan | Menerima daftar pesanan secara terurut sesuai waktu masuk, memperbarui status ketersediaan menu habis, dan mengubah status pesanan siap diambil[cite: 17, 19] |
| Kendala | Kesulitan mencatat pesanan lisan saat jam ramai yang sering memicu tertukarnya pesanan dan kerepotan memberi tahu pembeli satu per satu ketika stok habis[cite: 17, 19] |
| Perangkat dan konteks | Ponsel Android atau tablet di meja kasir stan kantin dengan koneksi Wi-Fi kantin; diakses terus-menerus selama jam operasional makan siang[cite: 17, 19] |
| Frekuensi penggunaan | Setiap hari kerja (Senin–Jumat) pukul 08.00–16.00 WIB[cite: 17, 19] |

---

## 3. Kebutuhan Fungsional

| ID | Rumusan Kebutuhan | Terkait Persona |
| :--- | :--- | :--- |
| F-01 | Mahasiswa dapat melihat daftar seluruh menu makanan dan minuman beserta harga dan status ketersediaannya pada halaman utama[cite: 17, 19] | Persona 1 (Dinda) |
| F-02 | Mahasiswa dapat mencari menu makanan berdasarkan nama atau filter stan kantin sehingga hasil pencarian tampil sesuai kata kunci[cite: 17, 19] | Persona 1 (Dinda) |
| F-03 | Mahasiswa dapat menambahkan menu yang berstatus tersedia ke dalam keranjang beserta jumlah porsinya[cite: 17, 19] | Persona 1 (Dinda) |
| F-04 | Mahasiswa dapat mengirimkan pesanan dari keranjang sehingga pesanan tercatat di sistem dengan status "Menunggu Konfirmasi"[cite: 17, 19] | Persona 1 (Dinda) |
| F-05 | Mahasiswa dapat melihat riwayat dan status terkini pesanannya ("Menunggu", "Diproses", atau "Siap Diambil")[cite: 17, 19] | Persona 1 (Dinda) |
| F-06 | Pengelola stan dapat memperbarui status pesanan pembeli menjadi "Diproses" atau "Siap Diambil"[cite: 17, 19] | Persona 2 (Bu Siti) |
| F-07 | Pengelola stan dapat mengubah status ketersediaan menu menjadi "Habis" atau "Tersedia" secara langsung[cite: 17, 19] | Persona 2 (Bu Siti) |
| F-08 | Mahasiswa dapat memberikan ulasan bintang dan komentar setelah pesanan berstatus selesai diambil[cite: 17, 19] | Persona 1 (Dinda) |

---

## 4. Kebutuhan Nonfungsional

| ID | Kategori | Rumusan | Kriteria Terukur |
| :--- | :--- | :--- | :--- |
| NF-01 | Kegunaan (*Usability*) | Alur pemesanan makanan utama harus ringkas dan mudah diselesaikan oleh mahasiswa di sela jadwal kuliah[cite: 17, 19] | Proses pemesanan dari memilih menu hingga mengirim pesanan selesai dalam maksimal **5 langkah interaksi**[cite: 17, 19] |
| NF-02 | Kinerja (*Performance*) | Pembaruan daftar menu dan status ketersediaan harus dimuat dengan responsif pada jaringan seluler standar kampus[cite: 17, 19] | Daftar katalog menu dan status antrean tampil di layar dalam waktu kurang dari **3 detik**[cite: 17, 19] |
| NF-03 | Keandalan (*Reliability*) | Aplikasi tetap menampilkan katalog menu terakhir yang pernah dimuat meskipun sinyal seluler di dalam gedung kampus sedang terputus | Data katalog menu tersimpan di penyimpanan lokal sehingga tetap terbaca **100% tanpa crash** saat mode offline |

---

## 5. Prioritas Fitur (MoSCoW)

| Prioritas | ID Kebutuhan | Alasan |
| :--- | :--- | :--- |
| **Must have** (Maks. 5) | F-01, F-03, F-04, F-05, F-06 | Kelima fitur ini merupakan inti alur transaksi pemesanan dua arah antara mahasiswa (melihat menu, memilih ke keranjang, mengirim pesanan, memantau status) dan penjual (memperbarui status pesanan) agar tujuan utama mengurangi antrean tercapai pada MVP Minggu 7[cite: 17, 19]. |
| **Should have** | F-02, F-07 | Pencarian menu dan pembaruan stok langsung oleh penjual sangat penting untuk mempercepat transaksi saat jam sibuk, namun pada tahap awal daftar menu masih dapat digulir manual dan stok diperbarui secara berkala[cite: 17, 19]. |
| **Could have** | F-08 | Fitur ulasan dan rating memberikan nilai tambah bagi mahasiswa dalam memilih stan favorit, tetapi tidak menghambat jalannya proses pemesanan utama jika dikerjakan pada tahap penyempurnaan akhir[cite: 17, 19]. |
| **Won't have (saat ini)** | Pembayaran *payment gateway* otomatis & layanan antar ke gedung kuliah | Di luar lingkup semester ini karena membutuhkan integrasi pihak ketiga berbayar dan tenaga kurir fisik; pembayaran tetap dilakukan langsung di kasir/QRIS stan saat pengambilan makanan[cite: 17, 19]. |

---

## 6. Pemetaan Kebutuhan ke Antarmuka

| ID Kebutuhan | Rumusan (ringkas) | Prioritas | Halaman yang Memenuhi | Widget yang Direncanakan (P3) |
| :--- | :--- | :--- | :--- | :--- |
| F-01 | Melihat daftar menu & status stok | Must | Halaman Utama (Katalog Menu) | `Scaffold`, `AppBar`, `Padding`, `Column`, `ListView.builder`, `Card`, `Row`[cite: 17, 19] |
| F-02 | Mencari & memfilter menu | Should | Halaman Utama (Bagian Atas Katalog) | `Column`, `Row`, `Padding` (kolom pencarian & chip kategori)[cite: 17, 19] |
| F-03 | Menambah menu ke keranjang | Must | Halaman Detail Menu / Kartu Menu | `Row`, `Column`, `ElevatedButton` / `IconButton`[cite: 17, 19] |
| F-04 | Mengirim pesanan (*checkout*) | Must | Halaman Keranjang Pesanan | `Scaffold`, `Column`, `ListView.builder`, `Padding`, `ElevatedButton`[cite: 17, 19] |
| F-05 | Melihat riwayat & status pesanan | Must | Halaman Status & Riwayat Pesanan | `Scaffold`, `ListView.builder`, `Card`, `Row`, `Text` (status berwarna)[cite: 17, 19] |
| F-06 | Mengubah status pesanan (Penjual) | Must | Halaman Kelola Pesanan (Mode Penjual) | `Scaffold`, `ListView.builder`, `Card`, `Column`, `Row`[cite: 17, 19] |
| F-07 | Mengubah status stok habis (Penjual) | Should | Halaman Kelola Menu (Mode Penjual) | `ListView.builder`, `ListTile`, `Row`[cite: 17, 19] |
| F-08 | Memberi ulasan setelah selesai | Could | Halaman Detail Riwayat Selesai | `Column`, `Row`, `Padding`[cite: 17, 19] |

---

## 7. User Flow — Alur Utama Pemesanan Makanan

### 7.1 Identitas Alur
* **Nama Alur:** Melakukan Pemesanan Menu Kantin
* **Aktor:** Persona 1 — Dinda (Mahasiswa Pemesan)
* **Tujuan Alur:** Pesanan berhasil dikirimkan dan tercatat dengan status "Menunggu Konfirmasi" pada halaman status pesanan.

### 7.2 Diagram User Flow

```mermaid
flowchart TD
    S(["Mulai: Mahasiswa membuka aplikasi"]) --> A["1. Halaman Utama: Tampil Katalog Menu"]
    A --> B["2. Pilih menu makanan/minuman yang diinginkan"]
    B --> C{"3. Keputusan: Apakah stok menu tersedia?"}
    C -- "Tidak (Habis)" --> D["4. Tampilkan notifikasi 'Stok Habis' & nonaktifkan tombol tambah"]
    D --> A
    C -- "Ya (Tersedia)" --> E["5. Tentukan jumlah porsi & masukkan ke keranjang"]
    E --> F["6. Buka Halaman Keranjang & isi catatan pesanan"]
    F --> G["7. Tekan tombol 'Kirim Pesanan'"]
    G --> H{"8. Keputusan: Apakah koneksi & data pesanan valid?"}
    H -- "Tidak (Gagal)" --> I["9. Tampilkan pesan error validasi / gangguan jaringan"]
    I --> F
    H -- "Ya (Valid)" --> J["10. Simpan transaksi & arahkan ke Halaman Status Pesanan"]
    J --> K["11. Tampilkan nomor antrean & status 'Menunggu Konfirmasi'"]
    K --> T(["Tujuan Tercapai: Pesanan tercatat di sistem kantin"])
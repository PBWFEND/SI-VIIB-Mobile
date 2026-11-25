# Model Data — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Daftar Entitas dan Struktur Field

Berdasarkan dokumen analisis kebutuhan (Tugas 4), entitas transaksi utama yang dikelola secara lokal pada aplikasi adalah **`DataPesanan`**.

| Entitas | Nama Field | Tipe Data | ID Kebutuhan (Tugas 4) | Sumber Nilai |
| :--- | :--- | :--- | :--- | :--- |
| `DataPesanan` | `id` | `String` | F-04, F-05, F-06 | **Sistem** (`DateTime.now().millisecondsSinceEpoch.toString()`) sebagai kunci unik untuk operasi *Update* dan *Delete*. |
| `DataPesanan` | `namaPemesan` | `String` | F-04 (Kirim pesanan) | **Form** (input pengguna pada kolom Nama Pemesan / NIM). |
| `DataPesanan` | `namaMenu` | `String` | F-01, F-03, F-04 | **Form** (input pengguna pada kolom Nama Menu yang dipesan). |
| `DataPesanan` | `jumlahPorsi` | `int` | F-03 (Tambah porsi) | **Form** (input pengguna pada kolom Jumlah Porsi yang dikonversi ke bilangan bulat). |
| `DataPesanan` | `catatan` | `String` | F-04 (Kelengkapan pesanan) | **Form** (input opsional pengguna; diisi `'-'` bila dikosongkan). |
| `DataPesanan` | `status` | `String` | F-05 (Lihat status), F-06 (Ubah status) | **Sistem** (nilai awal `'menunggu'`, dapat diperbarui menjadi `'diproses'` atau `'siap diambil'`). |

---

## 2. Penjelasan Keterkaitan Field dengan Kebutuhan

* **`id`:** Dihasilkan otomatis oleh sistem menggunakan timestamp milidetik agar setiap pesanan memiliki identitas unik sehingga operasi pembaruan status maupun pembatalan/hapus tidak salah sasaran.
* **`namaPemesan`, `namaMenu`, `jumlahPorsi`, dan `catatan`:** Seluruhnya diturunkan langsung dari kolom formulir pemesanan (Tugas 6) untuk memenuhi kebutuhan **F-03** dan **F-04** agar penjual stan menerima rincian pesanan yang lengkap dan akurat.
* **`status`:** Diperlukan untuk memenuhi kebutuhan **F-05** (mahasiswa memantau progres pesanan) dan **F-06** (pengelola stan memperbarui status pesanan dari menunggu menjadi diproses atau siap diambil).
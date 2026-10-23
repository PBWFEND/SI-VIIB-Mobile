# Dokumen Kebutuhan Aplikasi LabSpace 

## 1. Deskrisi Aplikasi
Aplikasi *LabSpace* merupakan solusi aplikasi begerak berbasis Android dan Web yang di rancang untuk mempermudah proses peminjaman ruang laboratorium di lingkungan kampus. Masalah utama yang dihadapi pengguna saat ini adalah proses pendaftaran formulir fisik yang memakan waktu, tingginya risiko bentrokan jadwal pengguna ruang, serta ketiadaan transparansi status persetujuan peminjaman secara real-time. Solusi berbasis mobile dipilih karena mahasiswa dan laboratorium membutuhkan akases yang fleksibel, cepat, serta dapat diakses kapan saja di sela-sela kesibukan aktivitas akademik di kampus.

---

## 2. User Pengguna

### Persona 1 - Rani - Mahasiswa Peminjam 

| Komponen | Isi |
|:---|:---|
| Nama dan Peran | Rani - Mahasiswa Peminjam |
| Tujuan | Meminjam ruang Laboratorium secara praktis tanpa harus datang langsung ke gedung lab | 
| Kendala | Jadwal Kuliah padat; formulir kertas sering hilang atau proses persetujuan memakan waktu lama | Perangkat dan konteks | Smartphone, Android; digunakan di sela-sela jam perkuliahan di kampus | 
| Frekuensi penggunaan | 1-2 kali perminggu saat masa pengerjaan tugas akhir atau ujian |

### Persona 2 - Pak Budi - Laboran (Pengelola Lab) 

| Komponene | Isi |
|:---|:---|
| Nama dan Peran | Pak Budi - Laboran / Admin Lab |
| Tujuan | Mengelola dan menyetujui pengajuan peminjaman ruangan lab dengan rapi tanpa bentrokan jadwal |
| Kendala | Sering kesulitan memverifikasi ketersediaan jadwal secara manual menggunakan buku catatan fisik | 
| Perangkat dan Konteks | Smartphone Android / Target Web; digunakan saat jam kerja di ruangan laboratorium | 
| Frekuensi penggunaan | Setiap hari kerja (pagi dan sore hari) |

---

## 3. Kebutuhan Fungsional

| ID | Rumusan Kebutuhan | Terkait Persona |
|:---|:------------------|:----------------|
| F-01 | Mahasiswa dapat melihat daftar ruang laboratorium beserta detail fasilitasnya | Rani |
| F-02 | Mahasiswa dapat mengajukan peminjaman ruang dengan memilih tanggal, jam mulai, dan durasi | Rani |
| F-03 | Mahasiswa dapat melihat status riwayat pengajuan peminjaman (menunggu, disetujui, ditolak) | Rani |
| F-04 | Laboran dapat melihat daftar seluruh pengajuan peminjaman ruang yang masuk | Pak Budi |
| F-05 | Laboran dapat menyetujui atau menolak pengajuan peminjaman beserta catatan alasan | Pak Budi |
| F-06 | Mahasiswa dapat membatalkan pengajuan peminjaman yang masih berstatus menunggu | Rani |

---

## 4. Kebutuhan Nonfungsional

| ID | Kategori | Rumusan | Kriteria Terukur |
|:---|:---------|:--------|:-----------------|
| NF-01 | Kegunaan | Proses pengajuan peminjaman ruang dapat diselesaikan dengan cepat | Selesai maksimal dalam 5 langkah dari halaman utama |
| NF-02 | Kinerja | Antarmuka aplikasi memuat data daftar laboratorium dengan responsif | Tampilan daftar ruang muncul kurang dari 3 detik pada jaringan kampus |

---

## 5. Prioritas Fitur (MoSCoW)

| Prioritas | ID Kebutuhan | Alasan |
|:----------|:-------------|:-------|
| Must have | F-01, F-02, F-03, F-04, F-05 | Merupakan alur inti peminjaman dan persetujuan yang menjadi tujuan utama persona mahasiswa dan laboran (maksimal 5 fitur). |
| Should have | F-06 | Penting untuk memberi fleksibilitas jika ada perubahan jadwal mahasiswa, namun bisa diwakili alur konfirmasi manual jika waktu mendesak. |
| Could have | — | Tidak ada pada iterasi ini. |
| Won't have (saat ini) | F-07 (Notifikasi Push) | Ditunda ke semester/fase berikutnya karena fokus MVP saat ini adalah alur pengajuan dan manajemen status berbasis data lokal/API inti. |

---

## 6. Pemetaan Kebutuhan ke Antarmuka

| ID Kebutuhan | Rumusan (ringkas) | Prioritas | Halaman yang Memenuhi | Widget yang Direncanakan (P3) |
|:-------------|:------------------|:----------|:----------------------------|:------------------------------|
| F-01 | Melihat daftar ruang lab | Must | Halaman Utama (Daftar Lab) | `Scaffold` + `ListView.builder` + `Card` |
| F-02 | Mengajukan peminjaman ruang | Must | Halaman Form Pengajuan | `Scaffold` + `Column` + `TextField` / `ElevatedButton` |
| F-03 | Melihat status pengajuan | Must | Halaman Status / Riwayat | `Scaffold` + `ListView.builder` + `ListTile` + `Text` |
| F-04 | Melihat daftar pengajuan masuk | Must | Halaman Dasbor Laboran | `Scaffold` + `ListView.builder` + `Card` |
| F-05 | Menyetujui/menolak pengajuan | Must | Halaman Detail Pengajuan Laboran | `Scaffold` + `Column` + `Row` (Tombol Setuju/Tolak) |
| F-06 | Membatalkan pengajuan | Should | Halaman Status / Riwayat | `ListTile` + `TextButton

---

## 7. Diagram User Flow

```mermaid
flowchart TD
    S(["Mulai: Mahasiswa membuka aplikasi"]) --> A["Halaman Utama: Lihat Daftar Lab"]
    A --> B["Pilih Ruang Lab"]
    B --> C["Masuk Halaman Form Pengajuan"]
    C --> D{"Data Form Valid?"}
    D -- "Tidak" --> E["Tampilkan Pesan Kesalahan Form"]
    E --> C
    D -- "Ya" --> F["Sistem Memeriksa Ketersediaan Jadwal"]
    F --> G{"Jadwal Bentrok?"}
    G -- "Ya" --> H["Tampilkan Pesan Jadwal Sudah Terisi"]
    H --> C
    G -- "Tidak" --> I["Kirim Pengajuan Peminjaman"]
    I --> J["Halaman Konfirmasi & Riwayat Status"]
    J --> T(["Tujuan Tercapai: Pengajuan Berstatus Menunggu"])




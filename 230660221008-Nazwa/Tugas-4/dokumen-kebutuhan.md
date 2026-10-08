# Dokumen Kebutuhan - Pengaduan Fasilitas Kampus

## 1. Deskripsi Aplikasi

Aplikasi Pengaduan Fasilitas Kampus adalah platform pelaporan kerusakan fasilitas (seperti AC mati, proyektor rusak, atau kursi patah) di lingkungan kampus. Masalah yang sering dihadapi adalah pelaporan manual melalui petugas tata usaha memakan waktu lama, tidak transparan statusnya, dan sering kali bukti laporan kertas tercecer atau menumpuk. Solusi berupa aplikasi mobile sangat tepat karena memungkinkan pengguna melaporkan kerusakan seketika langsung dari lokasi kejadian menggunakan ponsel mereka, kapan saja dan di mana saja, yang selaras dengan karakteristik mobilitas mahasiswa yang tinggi dan kebutuhan input data di tempat kejadian.

## 2. User Persona

### Persona 1 — Felix — Mahasiswa Pelapor

| Komponen | Isi |
|:---------|:----|
| Nama dan peran | Felix — Mahasiswa Pelapor |
| Tujuan | Melaporkan fasilitas kampus yang rusak agar segera diperbaiki tanpa harus bolak-balik ke kantor administrasi |
| Kendala | Sering menemukan alat lab atau fasilitas kelas yang rusak saat akan digunakan, namun waktu pelaporan manual sangat menyita waktu di sela jeda kuliah yang sempit |
| Perangkat dan konteks | Target web pada ponsel pintar; digunakan secara insidental saat berada di ruang kelas, lab, atau area kampus lainnya |
| Frekuensi penggunaan | 1–3 kali dalam satu semester (saat menemukan fasilitas rusak) |

### Persona 2 — Pak Kirill — Petugas Sarpras

| Komponen | Isi |
|:---------|:----|
| Nama dan peran | Pak Kirill — Petugas Sarana dan Prasarana (Sarpras) |
| Tujuan | Menerima daftar laporan kerusakan secara terpusat, memvalidasi, dan memperbarui status perbaikan fasilitas |
| Kendala | Sering mendapat laporan ganda untuk kerusakan yang sama dari mahasiswa berbeda dan kesulitan melacak laporan kertas yang mudah hilang |
| Perangkat dan konteks | Target web pada ponsel atau komputer; digunakan rutin setiap hari kerja di ruang pengelola atau saat berpatroli |
| Frekuensi penggunaan | Setiap hari kerja (berkali-kali) |

## 3. Kebutuhan Fungsional

| ID | Rumusan Kebutuhan | Terkait Persona |
|:---|:------------------|:----------------|
| F-01 | Felix dapat melihat daftar keluhan fasilitas agar mengetahui laporan yang sudah masuk | Persona 1 |
| F-02 | Felix dapat mengirim laporan kerusakan baru agar masalah segera diketahui oleh petugas | Persona 1 |
| F-03 | Felix dapat mencari laporan berdasarkan kategori agar tidak membuat pengaduan ganda | Persona 1 |
| F-04 | Pak Kirill dapat membaca detail laporan agar mengetahui letak lokasi spesifik kerusakan | Persona 2 |
| F-05 | Pak Kirill dapat mengubah status laporan agar mahasiswa mengetahui progres perbaikannya | Persona 2 |
| F-06 | Pak Kirill dapat menghapus laporan yang keliru atau usang agar daftar antrean tetap rapi | Persona 2 |

## 4. Kebutuhan Nonfungsional

| ID | Kategori | Rumusan | Kriteria Terukur |
|:---|:---------|:--------|:-----------------|
| NF-01 | Kegunaan | Kemudahan membuat laporan | Pengiriman laporan kerusakan baru oleh mahasiswa selesai maksimal dalam 4 langkah |
| NF-02 | Kinerja | Kecepatan memuat daftar | Daftar keluhan fasilitas tampil di layar aplikasi dalam waktu kurang dari 3 detik |

## 5. Prioritas Fitur (MoSCoW)

| Prioritas | ID Kebutuhan | Alasan |
|:----------|:-------------|:-------|
| Must have | F-01, F-02, F-04, F-05 | Keempat fitur ini adalah inti utama aplikasi agar siklus pengaduan (buat laporan -> petugas melihat -> petugas memproses) dapat berjalan lancar. |
| Should have | F-03 | Fitur pencarian penting untuk mencegah laporan ganda, tetapi mahasiswa masih bisa menggulir layar secara manual jika fitur ini terpaksa ditunda pembuatannya. |
| Could have | (Kosong) | Tidak ada fitur opsional tambahan untuk saat ini. |
| Won't have (saat ini) | F-06 | Fitur hapus laporan sengaja ditunda pada semester ini karena setiap laporan yang masuk (meskipun keliru) tetap akan disimpan sebagai riwayat rekam jejak untuk diaudit. |

## 6. Pemetaan Kebutuhan ke Antarmuka

| ID Kebutuhan | Rumusan (ringkas) | Prioritas | Halaman yang Memenuhi | Widget yang Direncanakan (P3) |
|:-------------|:------------------|:----------|:----------------------------|:------------------------------|
| F-01 | Melihat daftar keluhan | Must | Halaman Utama (Daftar Laporan) | `Scaffold` + `ListView.builder` + `Card` |
| F-02 | Mengirim laporan baru | Must | Halaman Form Pengaduan | `Scaffold` + `Column` |
| F-03 | Mencari laporan | Should | Halaman Utama (Daftar Laporan) | `Row` + `Padding` |
| F-04 | Membaca detail laporan | Must | Halaman Detail Laporan | `Scaffold` + `Column` + `Padding` |
| F-05 | Mengubah status laporan | Must | Halaman Detail Laporan | `Row` + `ElevatedButton` |
| F-06 | Menghapus laporan | Won't | Tidak ada (ditunda) | Tidak ada |

## 7. Diagram User Flow

**Nama alur:** Mengirim Laporan Kerusakan Baru  
**Aktor:** Felix (Mahasiswa Pelapor)  
**Tujuan alur:** Laporan kerusakan fasilitas berhasil terkirim dan masuk ke dalam antrean sistem.

```mermaid
flowchart TD
    S(["Mulai: Felix membuka aplikasi"]) --> A["Halaman Utama (Daftar Laporan)"]
    A --> B["Tekan tombol 'Tambah Laporan'"]
    B --> C["Halaman Form Pengaduan"]
    C --> D["Isi form (Nama fasilitas, kategori, kendala)"]
    D --> E{"Form diisi dengan lengkap?"}
    E -- "Tidak" --> F["Tampilkan pesan peringatan warna merah"]
    F --> C
    E -- "Ya" --> G["Kirim laporan ke sistem"]
    G --> H{"Koneksi internet sedang stabil?"}
    H -- "Tidak" --> I["Tampilkan pesan 'Gagal mengirim, coba lagi'"]
    I --> C
    H -- "Ya" --> J["Tampilkan pesan 'Laporan Berhasil'"]
    J --> T(["Tujuan tercapai: Laporan baru tercatat di sistem"])
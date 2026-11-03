# Information Architecture (IA)

## 1. Inventaris Layar
Berdasarkan tabel pemetaan Tugas 4, berikut adalah daftar layar yang dirancang:
1. **Halaman Riwayat Pegawai (Layar Utama)** — Memenuhi kebutuhan F-03 (Melihat riwayat absensi mandiri).
2. **Halaman Form Absensi (Layar Pendukung)** — Memenuhi kebutuhan F-01 (Kirim lokasi GPS) dan F-02 (Unggah foto bukti kehadiran).
3. **Halaman Pengajuan Izin (Layar Pendukung)** — Memenuhi kebutuhan F-05 (Kirim form izin kerja).

## 2. Diagram Information Architecture
```mermaid
graph TD
    A[Halaman Riwayat Pegawai<br/>(Layar Utama)] --> B[Halaman Form Absensi<br/>(Layar Pendukung)]
    A --> C[Halaman Pengajuan Izin<br/>(Layar Pendukung)]
```

## 3. Alasan Pemilihan Layar Utama
Halaman Riwayat Pegawai dipilih sebagai layar utama (titik masuk) karena langsung menjawab kebutuhan *Must have* (F-03) bagi pengguna untuk memastikan status absensi mereka hari ini telah tercatat. Selain itu, dari layar inilah aksi utama (F-01, Form Absensi) paling logis diakses agar pengguna bisa langsung memantau perubahannya setelah selesai melakukan absensi.

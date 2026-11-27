# Skenario Pengujian Fitur Perangkat — FasKampus

## 1. Identitas Pengujian

| Bagian | Keterangan |
|---|---|
| Nama aplikasi | FasKampus |
| Nama fitur | Pemilihan Dokumen Lampiran |
| Package | `file_picker` |
| Platform target | Android |
| Framework | Flutter |
| Jenis pengujian | Pengujian fungsional |
| Tujuan | Memastikan fitur pemilihan dokumen berjalan sesuai kebutuhan |

## 2. Tujuan Pengujian

Pengujian dilakukan untuk memastikan fitur pemilihan dokumen pada aplikasi FasKampus dapat digunakan sesuai kebutuhan proses pengajuan peminjaman fasilitas kampus.

Pengujian juga bertujuan memastikan aplikasi dapat menangani kondisi berhasil, pembatalan, akses dokumen yang tidak tersedia, dan kesalahan saat proses pemilihan dokumen.

## 3. Persiapan Pengujian

Sebelum melakukan pengujian, beberapa hal yang perlu dipersiapkan adalah:

1. Project Flutter FasKampus sudah memiliki dependency `file_picker`.
2. Aplikasi dapat dijalankan pada perangkat Android atau emulator.
3. Tersedia dokumen dengan format PDF, DOC, dan DOCX untuk pengujian.
4. Halaman lampiran sudah dapat dibuka.
5. Perangkat dapat membuka pemilih dokumen bawaan Android.

Perintah untuk mempersiapkan project:

```bash
flutter pub get
flutter analyze
flutter run
```

## 4. Skenario Pengujian

### 4.1 Pengujian Berhasil Memilih Dokumen

| Bagian | Keterangan |
|---|---|
| ID Pengujian | TC-01 |
| Nama Pengujian | Memilih dokumen berhasil |
| Kondisi Awal | Halaman lampiran sudah terbuka |
| Data Pengujian | Dokumen PDF, DOC, atau DOCX |
| Langkah Pengujian | 1. Tekan tombol Pilih Dokumen. 2. Pilih salah satu dokumen. 3. Tunggu proses selesai. |
| Hasil yang Diharapkan | Aplikasi menampilkan nama, tipe, dan ukuran dokumen yang dipilih. |
| Status | Belum diuji |

### 4.2 Pengujian Pembatalan Pemilihan Dokumen

| Bagian | Keterangan |
|---|---|
| ID Pengujian | TC-02 |
| Nama Pengujian | Membatalkan pemilihan dokumen |
| Kondisi Awal | Halaman lampiran sudah terbuka |
| Data Pengujian | Tidak ada dokumen yang dipilih |
| Langkah Pengujian | 1. Tekan tombol Pilih Dokumen. 2. Pemilih dokumen terbuka. 3. Tekan tombol kembali atau batalkan pemilihan. |
| Hasil yang Diharapkan | Aplikasi kembali ke halaman lampiran tanpa menampilkan pesan error. Jika sebelumnya sudah ada dokumen, dokumen tersebut tetap ditampilkan. |
| Status | Belum diuji |

### 4.3 Pengujian Akses Dokumen Tidak Tersedia

| Bagian | Keterangan |
|---|---|
| ID Pengujian | TC-03 |
| Nama Pengujian | Menangani dokumen yang tidak dapat diakses |
| Kondisi Awal | Halaman lampiran sudah terbuka |
| Data Pengujian | Dokumen yang aksesnya tidak tersedia atau tidak dapat dibaca oleh aplikasi |
| Langkah Pengujian | 1. Tekan tombol Pilih Dokumen. 2. Pilih dokumen dari lokasi yang aksesnya dibatasi atau sudah tidak tersedia. 3. Amati respons aplikasi. |
| Hasil yang Diharapkan | Aplikasi tidak mengalami crash. Jika proses pemilihan menghasilkan error, aplikasi menampilkan informasi yang sesuai dan menyediakan kesempatan untuk mencoba kembali. |
| Status | Belum diuji |

**Catatan:** Skenario ini bergantung pada perilaku pemilih dokumen dan perangkat. Tidak semua pembatasan akses dapat direproduksi secara langsung. Jika system file picker menolak atau tidak menampilkan dokumen tersebut, catat kondisi sebenarnya dan jangan menganggapnya sebagai pengujian permission yang berhasil.

### 4.4 Pengujian Kesalahan Perangkat atau Package

| Bagian | Keterangan |
|---|---|
| ID Pengujian | TC-04 |
| Nama Pengujian | Menangani kesalahan saat pemilihan dokumen |
| Kondisi Awal | Halaman lampiran sudah terbuka |
| Data Pengujian | Kondisi ketika pemilih dokumen atau plugin mengalami kegagalan |
| Langkah Pengujian | 1. Tekan tombol Pilih Dokumen. 2. Lakukan pengujian pada kondisi pemilih dokumen tidak tersedia atau terjadi kegagalan plugin. 3. Amati respons aplikasi. |
| Hasil yang Diharapkan | Aplikasi menampilkan pesan kesalahan yang informatif, tidak mengalami crash, dan menyediakan pilihan untuk mencoba kembali. |
| Status | Belum diuji |

## 5. Tabel Rekapitulasi Pengujian

| No. | ID | Skenario | Hasil yang Diharapkan | Hasil Aktual | Status |
|---|---|---|---|---|---|
| 1 | TC-01 | Berhasil memilih dokumen | Informasi dokumen ditampilkan | Belum diisi | Belum diuji |
| 2 | TC-02 | Membatalkan pemilihan | Tidak menampilkan error | Belum diisi | Belum diuji |
| 3 | TC-03 | Akses dokumen tidak tersedia | Aplikasi menangani kondisi akses | Belum diisi | Belum diuji |
| 4 | TC-04 | Kesalahan perangkat atau package | Menampilkan pesan error dan opsi mencoba kembali | Belum diisi | Belum diuji |

## 6. Evaluasi Hasil Pengujian

Setelah seluruh pengujian dilakukan, hasil aktual perlu dicatat berdasarkan perilaku aplikasi pada perangkat.

Evaluasi dilakukan dengan memperhatikan beberapa hal:

1. Apakah dokumen berhasil dipilih dan informasinya ditampilkan?
2. Apakah pembatalan pemilihan tidak dianggap sebagai error?
3. Apakah aplikasi dapat menangani dokumen yang tidak dapat diakses?
4. Apakah kesalahan perangkat atau package ditangani tanpa membuat aplikasi berhenti secara tiba-tiba?
5. Apakah pengguna dapat mencoba kembali setelah terjadi kesalahan?

Skenario yang belum dapat diuji harus tetap dicatat secara jujur dan tidak boleh dinyatakan berhasil tanpa pengujian.

## 7. Kesimpulan

Pengujian fitur pemilihan dokumen dilakukan untuk memastikan package `file_picker` dapat mendukung kebutuhan lampiran pada aplikasi FasKampus.

Melalui empat skenario pengujian tersebut, diharapkan aplikasi dapat menangani proses pemilihan dokumen, pembatalan, masalah akses, dan kesalahan perangkat dengan baik.

Hasil akhir pengujian akan menjadi bahan evaluasi untuk memastikan fitur perangkat sudah sesuai dengan kebutuhan aplikasi.
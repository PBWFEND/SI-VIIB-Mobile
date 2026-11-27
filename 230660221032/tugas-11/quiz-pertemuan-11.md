# Quiz Pertemuan 11 — Fitur Perangkat Sesuai Kebutuhan

**Nama**  : Deyna Angeliawati Zahara  
**NPM**   : 230660221032  
**Kelas** : SI VII B  

## Soal 1 — Pemilihan Fitur
Fitur perangkat dipilih berdasarkan kebutuhan nyata pengguna dan alur proses bisnis agar menghasilkan data yang langsung dipakai pada tahap berikutnya, bukan sekadar pelengkap.
- **Contoh pada RadiAct (UNSAP Radio):** Fitur **akses file lokal (`file_picker`)** untuk melampirkan naskah siaran (`.pdf`, `.doc`, `.docx`, maks 2 MB).
- **Alasan pemilihan:** Dalam pelaksanaannya konsep/naskah merupakan hal utama yang diperlukan dalam produksi sebuah konten, sehingga dalam hal ini setiap divisi diwajibkan untuk mengunggah naskah untuk acuan produksi dan sebelum mengubah status menjadi 'Tayang'. Hal ini juga penting sebagai arsip ide dan evaluasi konten kedepannya.

## Soal 2 — Permission
*Permission* diperlukan karena fitur perangkat mengakses data sensitif pengguna (penyimpanan, kamera, lokasi), sehingga sistem membatasinya demi privasi dan keamanan.
- **Permission diminta:** Ditampilkan saat pengguna memicu aksi (misalnya klik tombol *Lampirkan Naskah* yang membuka dialog file browser).
- **Permission ditolak:** Aplikasi tidak boleh *crash*, melainkan menangkap error (`PlatformException`), menampilkan pesan peringatan jelas, dan menyediakan tombol **Coba Lagi**.
- **Tidak tersedia:** Ketika platform tidak mendukung fitur tertentu (seperti `file.path` yang tidak tersedia di Flutter Web), aplikasi menyesuaikan logika dengan membaca `bytes` (`kIsWeb`) dan menginformasikan batasannya.

## Soal 3 — Pembatalan Pemilihan
Nilai `XFile?` (atau `FilePickerResult?` / `InfoFileNaskah?` pada RadiAct) yang bernilai `null` artinya **pengguna menutup dialog atau menekan *Cancel* tanpa memilih file**, dan kondisi ini **bukan error**.
- **Respons aplikasi:** Menghentikan *loading*, **mempertahankan data lampiran sebelumnya** agar tidak terhapus, serta menampilkan pesan info netral bahwa pemilihan file dibatalkan.

## Soal 4 — Service Layer
*Service layer* (`FileNaskahService` pada RadiAct) bertugas memanggil package `file_picker` secara *asynchronous*, memvalidasi format/ukuran file, membedakan hasil batal (`null`) dengan error (`Exception`), dan mengembalikan data bersih tanpa merender widget.
- **Alasan tidak ditulis di widget:** Agar kode tetap terpisah antara logika teknis platform (`kIsWeb`, `bytes`, `PlatformException`) dan tampilan UI (`main.dart`), sehingga mudah diperbaiki atau diganti tanpa merusak struktur widget.

## Soal 5 — State Fitur Perangkat
State minimal yang perlu ditangani adalah **Loading**, **Berhasil**, **Batal**, dan **Error / Permission Ditolak**.
- **Berhasil:** *Loading* berhenti, data file disimpan ke *state*, kotak lampiran berubah hijau menampilkan nama dan ukuran file, serta status program bisa diubah ke *Tayang*.
- **Dibatalkan:** *Loading* berhenti, lampiran lama tetap dipertahankan, dan muncul banner info pembatalan tanpa dianggap error.
- **Permission Ditolak / Error:** *Loading* berhenti, data lama tetap aman, muncul banner peringatan merah beserta penyebab error, dan tersedia tombol **Coba Lagi**.
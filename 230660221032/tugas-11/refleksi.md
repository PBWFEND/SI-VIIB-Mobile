# Refleksi dan Deklarasi Penggunaan AI — Tugas 11

**Nama**  : Deyna Angeliawati Zahara  
**NPM**   : 230660221032  
**Kelas** : SI VII B  


## 1. Alasan Pemilihan Fitur
Fitur yang dipilih adalah **pemilihan dokumen dari perangkat (`file_picker`)** untuk melampirkan naskah siaran (`.pdf`, `.doc`, `.docx`) pada aplikasi **RadiAct**. Fitur ini cocok dengan kebutuhan siaran radio karena naskah menjadi kebutuhan utama sebelum jadwal dilaksanakan dan bisa diubah statusnya menjadi *Tayang*, serta cukup mudah dicoba langsung di browser Chrome.

## 2. Kesulitan yang Ditemui dan Cara Mengatasinya
- **Error saat memilih file di browser:** Waktu dicoba pertama kali di Chrome, muncul peringatan error karena browser tidak bisa membaca alamat folder (`path`) asli komputer. Masalah ini selesai setelah membaca data file lewat memori (`bytes`) khusus untuk tampilan web.
- **File lama ikut hilang saat batal memilih file:** Awalnya waktu jendela pilih file ditutup (*Cancel*), lampiran yang sudah ada ikut terhapus. Hal ini diperbaiki dengan membedakan antara batal memilih file dan error, sehingga kalau dibatalkan file sebelumnya tetap tersimpan.

## 3. Deklarasi Penggunaan AI
Dalam mengerjakan Tugas 11 ini, saya dibantu oleh AI Gemini untuk memahami cara memisahkan file service dari tampilan halaman, memperbaiki error saat memilih file di Chrome, dan merapikan catatan `README.md` serta `refleksi.md`. Semua kode sudah saya salin, jalankan, dan uji sendiri di VS Code serta Google Chrome.
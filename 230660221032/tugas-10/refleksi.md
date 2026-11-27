# Refleksi Pembelajaran dan Deklarasi Penggunaan AI — Tugas 10

**Nama**  : Deyna Angeliawati Zahara  
**NPM**   : 230660221032  
**Kelas** : SI VII B  

## 1. Refleksi Pembelajaran

1. **Bagian integrasi data yang paling sulit:**
   Bagian yang paling menantang adalah menyatukan data dari dua endpoint berbeda dengan mencocokkan `userId` jadwal ke `id` pengguna, serta membiasakan diri memakai `Future.wait` agar keduanya bisa diambil bersamaan.

2. **Cara menangani response kosong atau error:**
   Request di *service* diamankan dengan `try-catch`, pengecekan status HTTP, dan `timeout`. Di layar UI, kondisi gagal ditampilkan lewat pesan error dan tombol **Coba Lagi**, sedangkan jika daftar jadwal memang kosong, layar menampilkan pesan data kosong agar tidak dikira error.

3. **Alasan pemisahan service dan widget:**
   Agar kode lebih rapi dan tidak menumpuk di satu file. Widget cukup fokus mengatur tampilan layar, sementara urusan pengambilan API, penggabungan data, dan aturan status ditangani oleh *service*.

## 2. Deklarasi Penggunaan AI
Dalam pengerjaan Tugas 10 ini, saya menggunakan AI (Gemini) untuk membantu cara penggabungan data dengan `Future.wait` dan memperbaiki error saat mencoba kode, penyusunan dan hasil proyek disesuaikan kembali secara mandiri.
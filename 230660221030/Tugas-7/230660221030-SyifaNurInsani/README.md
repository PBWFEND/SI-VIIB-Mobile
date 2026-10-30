# Tugas 7 – MVP Awal dengan Data Lokal

## Deskripsi Singkat

Tugas 7 ini mengimplementasikan MVP awal fitur peminjaman buku pada aplikasi PustakaKu dengan menggunakan data lokal. Pengelolaan data dilakukan menggunakan `StatefulWidget`, `List`, dan `setState()` tanpa menggunakan database maupun package tambahan.

Fitur yang diterapkan meliputi:
- **Create:** Menambahkan data peminjaman melalui formulir.
- **Read:** Menampilkan daftar data peminjaman.
- **Update:** Mengubah status peminjaman menjadi Diproses, Disetujui, atau Ditolak.
- **Delete:** Menghapus data peminjaman melalui dialog konfirmasi.

## Struktur File

- `model-data.md` – Dokumentasi entitas dan atribut data Peminjaman.
- `crud-lokal.dart` – Implementasi model dan fitur CRUD menggunakan Flutter.
- `catatan-keputusan-data.md` – Dokumentasi keputusan dalam pengelolaan data.
- `screenshot-daftar.png` – Tampilan daftar data peminjaman setelah penambahan data.
- `screenshot-hapus.png` – Tampilan dialog konfirmasi penghapusan data.

## Refleksi

Bagian yang paling menantang adalah menjaga kesesuaian antara atribut pada model Peminjaman, proses CRUD, dan kebutuhan sistem yang telah ditentukan pada Tugas 4. Hal ini karena setiap proses harus menggunakan atribut dan identitas data yang konsisten agar penambahan, pembacaan, perubahan status, serta penghapusan data dapat berjalan dengan benar. Melalui tugas ini, saya memahami bahwa perancangan model data perlu dilakukan dengan memperhatikan kebutuhan fitur agar implementasi aplikasi lebih terstruktur.

## Pernyataan Penggunaan AI

AI digunakan sebagai alat bantu dalam memahami instruksi tugas, menyusun dokumentasi, dan membantu proses penulisan kode. Seluruh hasil implementasi perlu diperiksa dan disesuaikan kembali dengan kebutuhan aplikasi PustakaKu.
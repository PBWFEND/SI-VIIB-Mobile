# Catatan Keputusan Data — PustakaKu

## 1. Pendahuluan

Catatan keputusan data ini menjelaskan pertimbangan dalam menentukan model data dan pengelolaan data lokal pada aplikasi PustakaKu. Keputusan yang diambil mengacu pada dokumen kebutuhan Tugas 4, terutama kebutuhan F-04, F-05, dan F-08, serta ketentuan Tugas 7 mengenai implementasi CRUD menggunakan Flutter.

## 2. Tabel Keputusan Data

| Keputusan | Pilihan | Alasan (Merujuk Kebutuhan) |
|---|---|---|
| Field model | Menggunakan field `id`, `nama`, `nim`, `judulBuku`, `tanggal`, dan `status` pada entitas Peminjaman. | Field tersebut digunakan untuk mencatat identitas peminjam, buku yang dipinjam, tanggal, dan status peminjaman sesuai F-04 dan F-05. |
| Kunci data (`id`) | Menggunakan ID unik bertipe String yang dibuat secara otomatis berdasarkan waktu saat data ditambahkan. | ID digunakan untuk membedakan setiap data peminjaman dan menjadi acuan ketika melakukan Update (F-08) maupun Delete. |
| Operasi Create | Menambahkan data peminjaman melalui form yang berisi nama, NIM, dan pilihan judul buku. | Mendukung F-04, yaitu mahasiswa dapat mengajukan peminjaman buku yang tersedia. |
| Operasi Read | Menampilkan seluruh data peminjaman menggunakan `ListView.builder`. | Mendukung F-05, yaitu mahasiswa dapat melihat status peminjaman yang telah diajukan. |
| Operasi Update | Mengubah status peminjaman menjadi Diproses, Disetujui, atau Ditolak dengan mencari data berdasarkan ID menggunakan `indexWhere`. | Mendukung F-08, yaitu petugas dapat memperbarui status peminjaman mahasiswa. |
| Operasi Delete | Menghapus data menggunakan `removeWhere` berdasarkan ID setelah pengguna menyetujui konfirmasi melalui `AlertDialog`. | Memenuhi ketentuan operasi Delete pada Tugas 7 agar data dapat dihapus secara terkontrol. |
| Pengelolaan state | Menggunakan `StatefulWidget`, `List<Peminjaman>`, dan `setState()`. | Memastikan perubahan data pada operasi CRUD langsung diperbarui pada tampilan aplikasi. |
| Keputusan persistensi | Menggunakan penyimpanan sementara di dalam memori aplikasi (in-memory) tanpa database maupun package tambahan. | Menyesuaikan batasan Tugas 7 yang mengutamakan pengelolaan data lokal menggunakan API bawaan Flutter. |

## 3. Pertimbangan Model Data

Entitas utama yang digunakan adalah `Peminjaman` karena fokus pengembangan Tugas 7 adalah pengelolaan transaksi peminjaman buku. Setiap data memiliki ID unik agar proses perubahan dan penghapusan dapat dilakukan berdasarkan identitas data, bukan berdasarkan posisi atau indeks dalam daftar.

Field `status` diberikan nilai awal "Diproses" ketika mahasiswa menambahkan data peminjaman. Selanjutnya, status dapat diperbarui menjadi "Disetujui" atau "Ditolak" melalui fitur Update.

## 4. Pertimbangan Operasi CRUD

Implementasi CRUD dilakukan menggunakan daftar data bertipe `List<Peminjaman>` yang dikelola di dalam State dari `StatefulWidget`.

- **Create:** Data baru ditambahkan setelah pengguna mengisi form peminjaman dengan benar.
- **Read:** Data yang tersimpan ditampilkan dalam bentuk kartu menggunakan `ListView.builder`.
- **Update:** Sistem mencari data berdasarkan ID menggunakan `indexWhere`, kemudian mengganti objek lama dengan objek baru yang memiliki status terbaru.
- **Delete:** Sistem menampilkan dialog konfirmasi sebelum menghapus data berdasarkan ID menggunakan `removeWhere`.

Setiap operasi yang mengubah data menggunakan `setState()` agar perubahan langsung terlihat pada antarmuka aplikasi.

## 5. Keputusan Persistensi Data

Pada Tugas 7, PustakaKu menggunakan penyimpanan sementara (in-memory). Data hanya tersedia selama aplikasi berjalan dan akan kembali kosong ketika aplikasi dimulai ulang atau halaman di-refresh.

Keputusan ini diambil karena fokus tugas adalah memahami model data, pengelolaan state, dan operasi CRUD lokal tanpa menggunakan package tambahan. Penggunaan database atau penyimpanan permanen dapat dipertimbangkan pada pengembangan aplikasi berikutnya.

## 6. Kesimpulan

Keputusan model data dan pengelolaan CRUD pada PustakaKu disusun berdasarkan kebutuhan fungsional yang telah ditentukan pada Tugas 4 serta ketentuan Tugas 7. Dengan menggunakan satu entitas utama, ID unik, dan pengelolaan state melalui `setState()`, proses penambahan, penampilan, pembaruan, dan penghapusan data peminjaman dapat dilakukan secara terstruktur.
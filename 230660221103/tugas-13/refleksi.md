# Refleksi Tugas 13 — Testing, Debugging, dan Perbaikan

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Refleksi Pembelajaran

Melalui kegiatan pengujian dan debugging pada Pertemuan 13, saya menyadari bahwa fitur yang tampak berjalan normal pada skenario ideal masih dapat menyimpan celah bug seperti duplikasi data akibat penekanan ganda tombol simpan saat jeda proses asinkron. Penggunaan alur debugging berbasis bukti (reproduksi skenario, perumusan hipotesis, perbaikan terfokus dengan flag `_sedangMenyimpan`, serta pengujian regresi otomatis menggunakan `flutter_test`) memastikan perbaikan yang dilakukan benar-benar menutup akar masalah tanpa merusak fitur validasi maupun penghapusan data yang sudah berjalan baik. Praktik menjalankan `flutter analyze` dan menulis widget test otomatis juga meningkatkan keyakinan terhadap kestabilan kode sebelum melangkah ke tahap integrasi akhir project.
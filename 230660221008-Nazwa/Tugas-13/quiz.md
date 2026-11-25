# Jawaban Quiz Pertemuan 13 — Testing, Debugging, dan Perbaikan

| | |
|:--|:--|
| **Nama** | Nazwa Umaira Nanindia Ramdhani |
| **NIM** | 230660221008 |
| **Kelas** | SI-VIIB |
| **Project Acuan** | Pengaduan Fasilitas Kampus |

---

## Soal 1 — Test Case
Komponen utama test case:
1. ID Test Case: Kode unik pengenal skenario pengujian (misalnya TC-01).   
2. Skenario: Nama atau ringkasan kasus yang diuji.   
3. Kondisi Awal (Precondition): Keadaan sistem atau halaman sebelum pengujian dimulai (misalnya form kosong dan sesi login aktif).   
4. Langkah Pengujian: Urutan tindakan yang dilakukan penguji secara berurutan.   
5. Input: Nilai data spesifik yang dimasukkan ke dalam form atau fungsi.   
6. Expected Result: Hasil yang seharusnya terjadi menurut spesifikasi kebutuhan dan aturan validasi.   
7. Actual Result: Hasil nyata yang ditunjukkan aplikasi saat pengujian dijalankan.   
8. Status: Penilaian akhir apakah pengujian Lulus atau Gagal berdasarkan kecocokan expected dan actual result.   

Perbedaan Expected Result dan Actual Result:
Expected result dirumuskan sebelum pengujian dieksekusi berdasarkan aturan bisnis/validasi yang disepakati, sedangkan actual result dicatat setelah langkah pengujian benar-benar dijalankan pada aplikasi. Jika actual result tidak sesuai dengan expected result, berarti ditemukan cacat (bug) yang perlu ditelusuri. 

## Soal 2 — Jenis Testing
1. Jenis Testing: Static Analysis	
Perbedaan Fokus dan Cara Kerja:	Memeriksa kode sumber tanpa menjalankan aplikasi menggunakan flutter analyze untuk mendeteksi error sintaks, kesalahan tipe data, dan pelanggaran aturan lint.
Contoh Penerapan: Mendeteksi variabel final yang belum diinisialisasi atau pemanggilan setState yang tidak tepat sebelum aplikasi dijalankan.
2. Jenis Testing: Unit Test
Perbedaan Fokus dan Cara Kerja:	Menguji satu fungsi, method, atau class logika secara terisolasi tanpa merender komponen tampilan (UI).
Contoh Penerapan: Menguji PengaduanValidator.validasiNim('') mengembalikan pesan 'NIM wajib diisi.'.
3. Jenis Testing: Widget Test   
Perbedaan Fokus dan Cara Kerja: Menguji tampilan dan interaksi komponen UI (Widget) pada lingkungan uji virtual flutter_test tanpa memerlukan perangkat fisik atau emulator.	
Contoh Penerapan: Menyimulasikan ketukan tombol kirim pada HalamanPengaduanAman dan memverifikasi teks pesan error muncul di layar.
4. Jenis Testing: Integration Test      
Perbedaan Fokus dan Cara Kerja:	Menguji alur menyeluruh aplikasi (end-to-end) pada lingkungan runtime nyata (browser, emulator, atau perangkat fisik) mulai dari interaksi pengguna hingga pembaruan daftar data.
Contoh Penerapan: Membuka aplikasi di Chrome, login, mengisi form pengaduan valid, mengirim request, dan memastikan tiket tampil di daftar.
5. Jenis Testing: Manual Functional Test   
Perbedaan Fokus dan Cara Kerja:	Pengujian yang dilakukan langsung oleh penguji mengikuti skenario pengguna secara manual, terutama untuk memeriksa tampilan visual dan fitur perangkat keras.
Contoh Penerapan: Menguji penolakan permission galeri/foto di perangkat dan memastikan pesan pemulihan muncul tanpa menghapus isian form sebelumnya.

## Soal 3 — Widget Test
Dalam package flutter_test, kelima elemen tersebut bekerja secara berurutan untuk menyimulasikan interaksi pengguna:   
1. pumpWidget(): Memasang (render) widget yang akan diuji (biasanya dibungkus MaterialApp) ke dalam lingkungan pengujian virtual WidgetTester.   
2. find: Mencari dan menunjuk widget target di dalam widget tree berdasarkan teks (find.text), key (find.byKey), ikon (find.byIcon), atau tipe widget (find.byType).   
3. tap(): Menyimulasikan aksi ketukan/sentuhan jari pengguna pada widget yang ditemukan oleh find (misalnya menekan tombol kirim).   
4. pump(): Memicu proses pembangunan ulang (rebuild) frame antarmuka agar perubahan state setelah interaksi tap() terlihat di widget tree; dapat diberi parameter Duration untuk menunggu proses asinkron/timer selesai.   
5. expect(): Membandingkan kondisi aktual pada widget tree (misalnya menggunakan matcher findsOneWidget atau findsNothing) dengan expected result untuk menentukan pengujian lulus atau gagal.

## Soal 4 — Debugging
Langkah debugging berbasis bukti untuk menemukan penyebab tombol simpan menghasilkan dua data saat ditekan dua kali:   
1. Reproduksi bug secara konsisten: Buka form pengaduan, isi seluruh kolom dengan data valid, lalu ketuk tombol kirim dua kali secara cepat untuk memastikan duplikasi data selalu dapat diulang.   
2. Catat input dan actual result: Dokumentasikan data yang dimasukkan beserta bukti actual result berupa masuknya dua tiket pengaduan identik ke dalam daftar.   
3. Periksa pesan analyzer dan log aktivitas: Tinjau log konsol atau audit log aplikasi untuk memverifikasi apakah pemanggilan fungsi pengiriman data benar-benar tereksekusi dua kali dalam rentang milidetik yang berdekatan.   
4. Telusuri method dan state terkait: Periksa properti onPressed pada tombol kirim dan variabel penanda status proses (seperti flag bool _sedangMengirim) di dalam class State.   
5. Susun hipotesis penyebab: Tombol kirim tetap berada dalam status aktif (onPressed != null) selama proses penyimpanan asinkron (await) berjalan, sehingga ketukan kedua tetap memicu callback penyimpanan.   
6. Perbaiki satu penyebab secara terfokus: Ubah onPressed tombol menjadi _sedangMengirim ? null : _kirimFormPengaduan dan pastikan flag _sedangMengirim diset true saat proses dimulai serta dikembalikan ke false setelah selesai atau gagal.   
7. Jalankan test regresi: Ulangi skenario ketukan ganda cepat dan jalankan seluruh test case lain untuk membuktikan hanya satu data yang tersimpan tanpa merusak alur pengiriman normal.

## Soal 5 — Regresi
Alasan test yang sudah lulus perlu dijalankan kembali setelah perbaikan bug:
Perbaikan kode pada satu bagian dapat memunculkan kerusakan baru (regresi) pada fitur lain yang berbagi state, validator, atau fungsi yang sama. Menjalankan ulang test case yang sebelumnya sudah lulus memastikan perbaikan bug tidak merusak fungsionalitas lama yang sudah berjalan benar.   

Contoh pada form pengaduan fasilitas kampus:
Misalnya pada form pengaduan ditemukan bug bahwa tombol kirim dapat diketuk dua kali, lalu diperbaiki dengan menambahkan kondisi _sedangMengirim = true saat pengiriman dimulai. Apabila developer lupa mengembalikan _sedangMengirim = false di dalam blok catch ketika terjadi error jaringan atau HTTP 401, maka tombol kirim akan terkunci selamanya setelah kegagalan pertama. Dengan menjalankan ulang test case skenario gagal koneksi dan pengiriman ulang, regresi tombol terkunci tersebut langsung terdeteksi sebelum aplikasi dirilis. 

## Soal 6 — Integritas Testing
Menghapus assertion (expect()) atau mengubah expected result hanya agar pengujian berstatus lulus adalah praktik yang salah karena:   
1. Menghilangkan fungsi deteksi cacat: Assertion adalah inti verifikasi dalam pengujian; jika expect() dihapus, test akan selalu lulus meskipun aplikasi gagal menampilkan pesan validasi atau menyimpan data yang salah.   
2. Menyembunyikan bug ke dalam produk akhir: Mengubah expected result agar mengikuti perilaku kode yang keliru (misalnya mengubah expected result input NIM kosong menjadi "data berhasil disimpan") membuat aplikasi meloloskan data tidak valid dan merusak keandalan sistem saat digunakan pengguna nyata. 
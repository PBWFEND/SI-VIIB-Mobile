## TUGAS 1 PAB — IDENTIFIKASI KEBUTUHAN APLIKASI BERGERAK
Sistem Informasi Absensi Pegawai Puskesmas Berbasis Mobile

Identitas Mahasiswa
Keterangan	Identitas
Nama	[Adrian Nugraha]
NIM	[230660221087]
Program Studi	Sistem Informasi
Mata Kuliah	Pemrograman Aplikasi Bergerak
Kelas	[SI-VIIB]


## 1. Deskripsi Sistem

Sistem Informasi Absensi Pegawai Puskesmas Berbasis Mobile merupakan aplikasi yang dirancang untuk membantu proses pencatatan kehadiran pegawai puskesmas secara digital melalui smartphone. Pengguna utama aplikasi ini adalah dokter, perawat, bidan, petugas administrasi, dan tenaga kesehatan lainnya, sedangkan kepala puskesmas atau petugas kepegawaian bertindak sebagai pengelola dan pemantau data absensi. Permasalahan yang terjadi pada proses absensi konvensional adalah pencatatan kehadiran yang masih dilakukan secara manual menggunakan buku atau tanda tangan sehingga berpotensi menimbulkan kesalahan pencatatan, manipulasi kehadiran, keterlambatan rekapitulasi, dan kesulitan dalam memantau kedisiplinan pegawai. Oleh karena itu, dibutuhkan aplikasi mobile yang memungkinkan pegawai melakukan absensi masuk dan pulang secara praktis melalui smartphone. Aplikasi ini memanfaatkan karakteristik aplikasi bergerak berupa konteks bergerak, yaitu penggunaan GPS untuk mengetahui lokasi pegawai ketika melakukan absensi, serta interaksi sentuh, yaitu penggunaan tombol absensi yang mudah diakses melalui layar smartphone. Selain itu, aplikasi dapat memanfaatkan kamera untuk mengambil foto sebagai bukti kehadiran dan konektivitas internet untuk mengirimkan data absensi ke server puskesmas. Dengan adanya aplikasi ini, proses pencatatan kehadiran diharapkan menjadi lebih efektif, efisien, transparan, dan terintegrasi dengan sistem informasi kepegawaian puskesmas.

## 2. Diagram Arsitektur Aplikasi

Aplikasi menggunakan arsitektur Client–Server, yaitu aplikasi mobile bertindak sebagai client yang berkomunikasi dengan backend Sistem Informasi melalui HTTP Request dan HTTP Response. Data kehadiran pegawai diproses oleh backend dan disimpan dalam database puskesmas.

## Diagram Arsitektur

!Diagram Arsitektur Aplikasi Absensi Puskesmas

Alur Kerja Sistem
Pegawai membuka aplikasi absensi melalui smartphone.
Pegawai melakukan login menggunakan akun masing-masing.
Pegawai memilih menu absensi masuk atau absensi pulang.
Aplikasi mengambil data waktu, lokasi GPS, dan foto apabila diperlukan.
Aplikasi mengirimkan HTTP Request kepada backend SI puskesmas.
Backend melakukan validasi identitas pegawai, waktu, dan lokasi absensi.
Database menyimpan data absensi pegawai.
Backend mengirimkan HTTP Response berupa status berhasil atau gagal.
Aplikasi menampilkan hasil absensi kepada pegawai.
Kepala puskesmas atau petugas administrasi dapat memantau rekapitulasi melalui sistem administrasi.
Pembagian Tanggung Jawab Sistem
Komponen	Tanggung Jawab
Aplikasi Mobile	Login, absensi masuk, absensi pulang, pengambilan lokasi, foto, dan melihat riwayat absensi
Backend SI	Validasi akun, validasi lokasi, pengaturan aturan absensi, dan pengolahan data
Database	Menyimpan data pegawai, jadwal kerja, dan riwayat absensi
Admin	Mengelola data pegawai, jadwal kerja, dan laporan kehadiran melalui sistem administrasi

## 3. Tabel Analisis Kebutuhan

Berikut identifikasi kebutuhan berdasarkan permasalahan proses absensi pegawai puskesmas.

No.	Permintaan	Pengguna	Karakteristik Mobile yang Terkait	Fitur Aplikasi	Materi Pemenuh
1	Pegawai dapat login menggunakan akun masing-masing	Dokter, perawat, bidan, staf	Layar kecil dan interaksi sentuh	Halaman login menggunakan NIP/username dan password	Minggu 3, 5–6, 12
2	Pegawai dapat melakukan absensi masuk	Seluruh pegawai	Interaksi sentuh dan sesi penggunaan singkat	Tombol absensi masuk dengan pencatatan waktu otomatis	Minggu 3, 5–6, 9–10
3	Pegawai dapat melakukan absensi pulang	Seluruh pegawai	Interaksi sentuh dan sesi penggunaan singkat	Tombol absensi pulang dan pencatatan waktu	Minggu 5–6, 9–10
4	Sistem dapat mencatat lokasi pegawai ketika melakukan absensi	Seluruh pegawai	Konteks bergerak dan fitur perangkat	Pengambilan koordinat GPS saat absensi	Minggu 11–12
5	Pegawai dapat mengambil foto sebagai bukti kehadiran	Seluruh pegawai	Konteks bergerak dan pemanfaatan kamera	Fitur kamera untuk mengambil foto saat absensi	Minggu 11–12
6	Pegawai dapat melihat riwayat absensi sebelumnya	Seluruh pegawai	Layar kecil dan sesi penggunaan singkat	Halaman riwayat absensi berdasarkan tanggal	Minggu 3, 5–6, 9–10
7	Pegawai tetap dapat melihat riwayat absensi terakhir ketika internet terputus	Seluruh pegawai	Konektivitas terbatas	Penyimpanan lokal untuk cache riwayat absensi	Minggu 7
8	Pegawai menerima pengingat waktu absensi masuk dan pulang	Seluruh pegawai	Sesi penggunaan singkat dan konteks bergerak	Notifikasi pengingat jadwal absensi	Minggu 11
9	Kepala puskesmas dapat melihat rekapitulasi kehadiran seluruh pegawai	Kepala puskesmas	Tidak relevan secara langsung dengan aplikasi mobile pegawai	Di luar lingkup aplikasi mobile pegawai (backend SI/sistem admin)	Di luar lingkup (backend SI)
10	Admin dapat menambah, mengubah, dan menghapus data pegawai	Petugas administrasi	Tidak relevan secara langsung dengan aplikasi mobile pegawai	Di luar lingkup aplikasi mobile pegawai (sistem administrasi)	Di luar lingkup (backend SI)
11	Sistem memvalidasi apakah pegawai melakukan absensi sesuai jadwal dan lokasi yang ditentukan	Sistem/petugas administrasi	Konteks bergerak dan konektivitas	Pengiriman data GPS dan waktu untuk divalidasi server	Minggu 9–10, 12
12	Kepala puskesmas dapat mengunduh laporan absensi bulanan	Kepala puskesmas	Tidak relevan secara langsung dengan aplikasi mobile pegawai	Di luar lingkup aplikasi mobile pegawai (laporan sistem admin)	Di luar lingkup (backend SI)
Analisis Kebutuhan

Berdasarkan tabel di atas, aplikasi mobile difokuskan pada aktivitas pegawai yang berhubungan langsung dengan proses kehadiran, seperti login, absensi masuk, absensi pulang, pengambilan lokasi, pengambilan foto, dan melihat riwayat absensi.

Sementara itu, pengelolaan data pegawai, pengaturan jadwal kerja, rekapitulasi seluruh pegawai, dan pembuatan laporan bulanan merupakan tanggung jawab backend SI atau sistem administrasi. Pemisahan tersebut dilakukan agar aplikasi mobile tidak mengambil alih seluruh proses bisnis yang seharusnya dikelola oleh server.

## 4. Bukti Environment Siap

Bukti berikut menunjukkan bahwa lingkungan pengembangan Flutter dan Dart telah dipersiapkan dan aplikasi Flutter pertama berhasil dijalankan.

### 4.1 Flutter Doctor Sebelum Perbaikan

File: flutter-doctor/sebelum.png

!Flutter Doctor Sebelum Perbaikan

Keterangan: Dokumentasi hasil pemeriksaan konfigurasi Flutter menggunakan perintah flutter doctor -v sebelum dilakukan perbaikan terhadap permasalahan yang ditemukan.

### 4.2 Flutter Doctor Sesudah Perbaikan

File: flutter-doctor/sesudah.png

!Flutter Doctor Sesudah Perbaikan

Keterangan: Dokumentasi hasil pemeriksaan Flutter setelah proses konfigurasi dan perbaikan lingkungan pengembangan selesai dilakukan.

### 4.3 Aplikasi Flutter Berhasil Dijalankan

File: aplikasi.png

!Aplikasi Flutter Berjalan

Keterangan: Dokumentasi aplikasi Flutter pertama yang berhasil dijalankan menggunakan browser Chrome, emulator Android, atau perangkat fisik.

### 5. Refleksi

Fitur perangkat yang paling relevan untuk aplikasi absensi pegawai puskesmas adalah GPS karena dapat membantu mencatat lokasi pegawai ketika melakukan absensi sehingga proses kehadiran lebih terkontrol. Selain itu, fitur kamera dapat digunakan untuk mengambil foto sebagai bukti pendukung bahwa pegawai benar-benar melakukan absensi di lingkungan puskesmas. Kedua fitur tersebut
# Jawaban Quiz Pertemuan 14 — Integrasi Project dan Penyempurnaan UI/UX

| | |
|:--|:--|
| **Nama** | Nazwa Umaira Nanindia Ramdhani |
| **NIM** | 230660221008 |
| **Kelas** | SI-VIIB |
| **Project Acuan** | Pengaduan Fasilitas Kampus |

---

## Soal 1 — Integrasi Fitur
Alasan integrasi fitur memerlukan satu model data bersama:
Integrasi tidak sekadar menggabungkan beberapa halaman ke dalam satu project, melainkan memastikan halaman daftar, halaman detail, halaman form, dan fitur filter membaca serta memperbarui kontrak entitas yang sama. Dengan satu model bersama (misalnya class Pengaduan dan enum StatusPengajuan), objek dapat dikirim langsung antarhalaman menggunakan id unik tanpa konversi manual dan tetap aman secara tipe data (type-safe).

Risiko apabila setiap halaman memiliki model sendiri:
1. Ketidakcocokan nama field dan tipe data: Misalnya halaman daftar menyimpan status sebagai String ("Menunggu"), sedangkan halaman detail memakai int (1), sehingga memicu percabangan konversi yang rumit dan rawan error runtime.   
2. Data tidak sinkron antarhalaman: Ketika status pengaduan fasilitas kampus diubah pada halaman detail, halaman daftar utama tetap menampilkan status lama karena kedua halaman mengelola struktur objek yang berbeda.   
3. Beban pemeliharaan berulang (maintenance overhead): Penambahan satu atribut baru (seperti lokasi atau tanggalKejadian) harus diubah di banyak file model terpisah dan berisiko terlewat.   

## Soal 2 — Sumber Data
Pengertian satu sumber data (Single Source of Truth):
Seluruh operasi pengambilan, penambahan, pembaruan, dan penghapusan data ditempatkan secara terpusat pada satu lapisan service atau repository sehingga tidak ada halaman yang menyimpan salinan data terpisah secara mandiri.

Hubungan antara Service, State Halaman, dan Widget:
1. Komponen	Tanggung Jawab dalam : Service / Repository
Alur Data :	Mengambil, menyimpan, menyaring, dan memperbarui data secara terpusat berdasarkan id unik.
Contoh pada Pengaduan Fasilitas Kampus : PengaduanService menyimpan daftar tiket, menambah laporan baru dari form, dan mengubah StatusPengajuan.

2. Komponen	Tanggung Jawab dalam : State Halaman
Alur Data :	Menyimpan hasil data sementara dari service beserta flag keadaan (memuat, kosong, gagal) lalu memanggil setState() saat data berubah agar UI langsung diperbarui tanpa muat ulang manual.
Contoh pada Pengaduan Fasilitas Kampus : HalamanUtamaPengaduanState memuat daftar dari PengaduanService dan langsung memperbarui tampilan daftar begitu form selesai menyimpan laporan.

3. Komponen	Tanggung Jawab dalam : Widget (UI) 
Alur Data :	Menampilkan data yang disediakan oleh state dan meneruskan interaksi pengguna (ketukan tombol simpan, filter, atau ubah status) kembali ke state/service.
Contoh pada Pengaduan Fasilitas Kampus : Kartu tiket menampilkan judul, lokasi, dan chip status, lalu meneruskan aksi ketuk ke halaman detail.

## Soal 3 — Tata Letak Responsif
Kapan LayoutBuilder lebih tepat daripada MediaQuery.sizeOf:
LayoutBuilder lebih tepat digunakan ketika keputusan tata letak bergantung pada ruang lebar aktual yang diberikan oleh widget induk (constraints.maxWidth), bukan ukuran keseluruhan layar perangkat. MediaQuery.sizeOf hanya membaca ukuran jendela global (cocok untuk padding luar halaman), sedangkan LayoutBuilder tetap akurat ketika widget ditempatkan di dalam panel terbagi (split-view), dialog, atau jendela browser yang diubah ukurannya tanpa mengubah orientasi perangkat.

Contoh kasus pada halaman daftar dan detail:
Pada halaman Pengaduan Fasilitas Kampus, LayoutBuilder memeriksa titik henti (breakpoint) constraints.maxWidth >= 720:   
1. Lebar sempit (< 720 px, misalnya ponsel 400 px): Menampilkan daftar laporan dalam 1 kolom vertikal (ListView); ketika pengguna mengetuk kartu tiket, detail dibuka melalui navigasi halaman penuh.   
2. Lebar luas (>= 720 px, misalnya browser desktop/tablet 900 px): Menampilkan 2 kolom berdampingan (Row) — kolom kiri berisi panel filter dan daftar tiket, sedangkan kolom kanan langsung menampilkan panel detail tiket yang dipilih tanpa terjadi RenderFlex overflowed.

## Soal 4 — Keadaan Antarmuka
Alasan keadaan kosong, gagal, dan memuat harus dibedakan:
Ketiganya menggambarkan kondisi proses yang berbeda dan menuntut respons tindakan pengguna yang berbeda pula:

1. Keadaan memuat (loading): Aplikasi sedang mengambil atau mengirim data, sehingga menampilkan indikator progres agar pengguna menunggu.   
2. Keadaan kosong (empty): Proses pengambilan data berhasil, tetapi belum ada tiket yang tercatat atau hasil filter tidak menemukan kecocokan; aplikasi menampilkan penjelasan dan tombol pemulihan seperti "Buat Pengaduan Baru" atau "Reset Filter".   
3. Keadaan gagal (error): Terjadi gangguan jaringan, server, atau sesi berakhir; aplikasi menampilkan pesan aman yang mudah dipahami beserta tombol "Coba Lagi".

Akibat apabila ketiganya ditampilkan dengan pesan yang sama (misalnya hanya "Tidak ada data"):
Pengguna tidak dapat membedakan apakah aplikasi sedang memproses permintaan, daftar memang masih kosong, atau koneksi internet sedang terputus. Akibatnya, saat terjadi kegagalan koneksi pengguna tidak memperoleh tombol Coba Lagi dan mengira seluruh laporan pengaduannya hilang, sedangkan saat proses loading pengguna mengira aplikasi macet lalu menekan tombol berulang kali.

## Soal 5 — Aksesibilitas
Tiga pemeriksaan aksesibilitas dasar beserta target praktis dan penerapannya pada Flutter:
1. Target Sentuh (Touch Target Size):
Target praktis: Minimal 48 × 48 piksel.   
Cara menerapkan: Menetapkan minimumSize: const Size.fromHeight(48) pada FilledButton / OutlinedButton dan menggunakan IconButton standar agar tombol mudah ditekan jari pada layar ponsel tanpa salah ketuk.   
2. Kontras Warna Teks (Color Contrast):
Target praktis: Rasio kontras minimal 4.5 : 1 untuk teks normal terhadap latar belakangnya.   
Cara menerapkan: Mengambil pasangan warna dari Theme.of(context).colorScheme (misalnya onSurface di atas surface atau onPrimaryContainer di atas primaryContainer) dan menghindari penggunaan teks abu-abu muda di atas latar putih.   
3. Label Aksi & Makna Status Non-Warna:
Target praktis: Setiap tombol ikon memiliki deskripsi aksi yang terbaca pembaca layar (screen reader) dan status tidak hanya bergantung pada warna.   
Cara menerapkan: Menambahkan properti tooltip pada setiap IconButton (contoh: tooltip: 'Muat ulang daftar') serta menyertakan teks status eksplisit ('Menunggu', 'Diproses', 'Selesai') di dalam badge status, bukan sekadar warna merah atau hijau.

## Soal 6 — Candidate Release
Komponen catatan rilis (Release Notes) candidate release:
1. Nomor versi dengan penanda kandidat rilis (contoh: 1.0.0-rc.1).   
2. Tanggal build dan versi Flutter & Dart yang digunakan.   
3. Target platform (misalnya Web Chrome dan emulator/perangkat Android).   
4. Daftar fitur utama yang sudah terintegrasi dalam satu alur.   
5. Daftar perbaikan pada versi kandidat tersebut.   
6. Batasan pengujian yang masih ada.   
7. Cara menjalankan atau memasang aplikasi.   

Alasan versi bertanda rc (Release Candidate) perlu dicatat dan diuji pihak lain sebelum dinyatakan final:

1. Menandai kesiapan uji pra-final dengan ruang perbaikan terukur: Akhiran -rc.1 menandakan seluruh fitur inti telah terintegrasi dan siap diuji menyeluruh, namun bila ditemukan cacat selama pengujian, perbaikannya dapat dicatat sebagai -rc.2 sebelum versi final 1.0.0 ditetapkan.   
2. Menghindari bias pengembang (developer blind spot): Pengembang cenderung hanya menguji skenario yang sudah ia hafal; pengujian oleh pihak lain menggunakan Skenario Uji Penerima membantu menemukan hambatan alur navigasi, ketidakkonsistenan tampilan pada lebar layar berbeda, atau kekurangan umpan balik pengguna yang terlewat oleh pembuat kode. 
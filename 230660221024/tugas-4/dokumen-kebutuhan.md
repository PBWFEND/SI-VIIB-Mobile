# Dokumen Kebutuhan --- Aplikasi Absensi Organisasi Mahasiswa

-   **Nama:** Ridho Akmal Aulia
-   **NIM:** 230660221024
-   **Kelas:** SI-VIIB
-   **Mata Kuliah:** Pemrograman Aplikasi Bergerak
-   **Domain Sistem:** Aplikasi Absensi Organisasi Mahasiswa
-   **Tenggat:** Sebelum Pertemuan 5

------------------------------------------------------------------------

## 1. Deskripsi Aplikasi

Aplikasi Absensi Organisasi Mahasiswa (selanjutnya disebut *Absensi OM*)
adalah aplikasi mobile yang membantu anggota organisasi mahasiswa
melakukan check-in kehadiran kegiatan dan membantu panitia mencatat
kehadiran secara terpusat. Saat ini, absensi masih menggunakan daftar
hadir kertas sehingga catatan setiap kegiatan berpotensi tersimpan
terpisah dan menyulitkan penyusunan rekap kehadiran.

Solusi berbentuk aplikasi mobile dipilih karena anggota dapat melakukan
check-in langsung dari ponsel di lokasi kegiatan, sedangkan panitia
dapat memantau kehadiran tanpa harus memegang lembar kertas. Penyimpanan
dan pengolahan rekap data kehadiran dilakukan oleh backend Sistem
Informasi, sementara aplikasi mobile menyediakan antarmuka bagi anggota
dan panitia sesuai kewenangannya.

------------------------------------------------------------------------

## 2. User Persona

### Persona 1 --- Dimas, Anggota Organisasi Mahasiswa

  -----------------------------------------------------------------------
  Komponen                            Isi
  ----------------------------------- -----------------------------------
  Nama dan peran                      Dimas --- mahasiswa anggota aktif
                                      organisasi kemahasiswaan

  Tujuan                              Melakukan check-in kehadiran
                                      kegiatan tanpa harus mencari
                                      panitia dan memeriksa apakah
                                      kehadirannya sudah tercatat

  Kendala                             Jadwal kuliah padat sehingga sering
                                      tiba di lokasi kegiatan mendekati
                                      waktu mulai; tidak selalu bertemu
                                      panitia di awal acara

  Perangkat dan konteks               Ponsel Android pribadi; digunakan
                                      di lokasi kegiatan seperti aula,
                                      lapangan, atau ruang rapat

  Frekuensi penggunaan                1--3 kali per minggu selama masa
                                      kegiatan aktif organisasi
  -----------------------------------------------------------------------

### Persona 2 --- Sari, Panitia Absensi

  -----------------------------------------------------------------------
  Komponen                            Isi
  ----------------------------------- -----------------------------------
  Nama dan peran                      Sari --- mahasiswa anggota divisi
                                      kesekretariatan yang bertugas
                                      sebagai panitia absensi

  Tujuan                              Membuka sesi absensi saat kegiatan
                                      dimulai dan memantau daftar anggota
                                      yang sudah tercatat hadir selama
                                      kegiatan berlangsung

  Kendala                             Harus melayani banyak anggota
                                      sekaligus di lokasi dan tidak dapat
                                      memegang daftar hadir kertas sambil
                                      mengatur jalannya acara

  Perangkat dan konteks               Ponsel Android pribadi; digunakan
                                      di lokasi kegiatan saat acara
                                      berlangsung

  Frekuensi penggunaan                Setiap kegiatan organisasi
                                      diselenggarakan, sekitar 2--4 kali
                                      per bulan
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 3. Kebutuhan Fungsional

  -----------------------------------------------------------------------
  ID                      Rumusan Kebutuhan       Terkait Persona
  ----------------------- ----------------------- -----------------------
  F-01                    Anggota dapat melihat   Persona 1
                          daftar kegiatan
                          organisasi yang
                          memiliki sesi absensi
                          beserta ringkasan
                          jadwal dan status sesi.

  F-02                    Anggota dapat melihat   Persona 1
                          detail kegiatan (nama,
                          jadwal, lokasi, dan
                          status sesi absensi)
                          sebelum melakukan
                          check-in.

  F-03                    Anggota dapat mencatat  Persona 1
                          kehadiran dengan
                          menekan tombol check-in
                          pada kegiatan yang
                          sesinya sedang dibuka.

  F-04                    Anggota dapat melihat   Persona 1
                          status dan riwayat
                          kehadirannya sendiri
                          pada kegiatan yang
                          pernah diikuti.

  F-05                    Panitia dapat membuka   Persona 2
                          dan menutup sesi
                          absensi pada kegiatan
                          yang menjadi tanggung
                          jawabnya.

  F-06                    Panitia dapat melihat   Persona 2
                          daftar anggota yang
                          sudah tercatat hadir
                          pada sesi absensi yang
                          sedang berjalan.

  F-07                    Panitia dapat membuat   Persona 2
                          kegiatan baru yang akan
                          memiliki sesi absensi.

  F-08                    Pengurus dapat melihat  Persona 1 dan Persona 2
                          rekap kehadiran anggota
                          per kegiatan untuk
                          keperluan evaluasi.

  F-09                    Anggota dapat menerima  Persona 1
                          notifikasi pengingat
                          ketika kegiatan yang
                          diikutinya akan
                          berlangsung.
  -----------------------------------------------------------------------

### 3.1 Uji Keterukuran Kebutuhan Fungsional

  -----------------------------------------------------------------------
  ID                                  Bagaimana Diverifikasi?
  ----------------------------------- -----------------------------------
  F-01                                Buka aplikasi dengan akun anggota;
                                      daftar kegiatan tampil dengan nama,
                                      jadwal, dan status sesi.

  F-02                                Pilih salah satu kegiatan dari
                                      daftar; halaman detail menampilkan
                                      nama, jadwal, lokasi, dan status
                                      sesi.

  F-03                                Pada kegiatan berstatus **Dibuka**,
                                      tekan tombol check-in; status
                                      kehadiran anggota berubah menjadi
                                      tercatat.

  F-04                                Buka halaman riwayat; daftar
                                      kegiatan yang pernah diikuti tampil
                                      beserta status kehadiran.

  F-05                                Login sebagai panitia; tombol
                                      buka/tutup sesi mengubah status
                                      sesi kegiatan.

  F-06                                Pada sesi yang sedang berjalan,
                                      halaman daftar kehadiran panitia
                                      menampilkan nama anggota yang sudah
                                      check-in.

  F-07                                Login sebagai panitia; formulir
                                      kegiatan baru dapat disimpan dan
                                      kegiatan muncul pada daftar.

  F-08                                Login sebagai pengurus; rekap
                                      kehadiran menampilkan jumlah
                                      anggota yang hadir per kegiatan.

  F-09                                Anggota menerima notifikasi pada
                                      ponsel sebelum kegiatan dimulai;
                                      pengujian dilakukan setelah materi
                                      fitur perangkat dipelajari.
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 4. Kebutuhan Nonfungsional

  -----------------------------------------------------------------------
  ID                Kategori          Rumusan           Kriteria Terukur
  ----------------- ----------------- ----------------- -----------------
  NF-01             Kegunaan          Anggota dapat     Check-in selesai
                                      menyelesaikan     maksimal 3
                                      check-in          langkah: buka
                                      kehadiran dari    aplikasi → pilih
                                      halaman utama.    kegiatan → tekan
                                                        tombol check-in.

  NF-02             Kinerja           Daftar kegiatan   Daftar kegiatan
                                      tampil setelah    tampil kurang
                                      aplikasi dibuka.  dari 3 detik pada
                                                        jaringan kampus.

  NF-03             Keamanan          Riwayat kehadiran Anggota lain
                                      hanya dapat       tidak dapat
                                      diakses oleh      melihat riwayat
                                      pemilik akun dan  kehadiran anggota
                                      pengurus          tertentu melalui
                                      berwenang.        aplikasi.

  NF-04             Kompatibilitas    Aplikasi dapat    Halaman utama
                                      dijalankan pada   berjalan tanpa
                                      target web        error pada kedua
                                      (Chrome) dan      target.
                                      Android.
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 5. Prioritas Fitur (MoSCoW)

  -----------------------------------------------------------------------
  Prioritas               ID Kebutuhan            Alasan
  ----------------------- ----------------------- -----------------------
  Must have               F-01, F-02, F-03, F-04, Kelima kebutuhan ini
                          F-05                    merupakan inti tujuan
                                                  aplikasi: anggota dapat
                                                  menemukan kegiatan,
                                                  melihat detail,
                                                  melakukan check-in, dan
                                                  memeriksa kehadiran;
                                                  panitia dapat membuka
                                                  atau menutup sesi.
                                                  Tanpa kelimanya,
                                                  aplikasi tidak
                                                  menyelesaikan masalah
                                                  absensi kertas.

  Should have             F-06, F-07              Penting untuk
                                                  memperlancar tugas
                                                  panitia, tetapi
                                                  sementara dapat
                                                  dikerjakan secara
                                                  manual, misalnya
                                                  panitia mencatat
                                                  kegiatan baru langsung
                                                  di backend. Dikerjakan
                                                  setelah kebutuhan Must
                                                  have selesai.

  Could have              F-08                    Memberi nilai tambah
                                                  bagi pengurus untuk
                                                  evaluasi kehadiran,
                                                  tetapi bukan penghambat
                                                  kegiatan utama. Dapat
                                                  dikerjakan bila waktu
                                                  tersisa.

  Won't have (saat ini)   F-09                    Fitur notifikasi
                                                  pengingat memerlukan
                                                  materi fitur perangkat
                                                  (notifikasi lokal/push)
                                                  yang baru dibahas pada
                                                  pertemuan minggu ke-11.
                                                  Fitur ditunda, bukan
                                                  dihapus dari daftar
                                                  kebutuhan.
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 6. User Flow

### 6.1 Identitas Alur

  -----------------------------------------------------------------------
  Aspek                               Isi
  ----------------------------------- -----------------------------------
  Nama alur                           Melakukan check-in kehadiran
                                      kegiatan

  Aktor                               Persona 1 --- Dimas (anggota
                                      organisasi)

  Tujuan alur                         Kehadiran anggota tercatat pada
                                      sesi absensi kegiatan yang sedang
                                      dibuka
  -----------------------------------------------------------------------

### 6.2 Diagram User Flow

``` mermaid
flowchart TD
    S(["Mulai: anggota membuka aplikasi"]) --> A["Halaman daftar kegiatan: nama, jadwal, status sesi"]
    A --> B["Pilih kegiatan yang ingin dihadiri"]
    B --> C["Halaman detail kegiatan: nama, jadwal, lokasi, status sesi"]
    C --> D{"Sesi absensi sedang dibuka?"}
    D -- "Tidak" --> E["Tampilkan pesan: Sesi belum dibuka atau sudah ditutup"]
    E --> A
    D -- "Ya" --> F["Tekan tombol Check-in"]
    F --> G["Kirim permintaan check-in ke backend"]
    G --> H{"Kehadiran berhasil tercatat?"}
    H -- "Tidak" --> I["Tampilkan pesan gagal: duplikat atau gangguan jaringan"]
    I --> C
    H -- "Ya" --> J["Tampilkan konfirmasi: Kehadiran tercatat"]
    J --> T(["Tujuan tercapai: kehadiran anggota tercatat"])
```

### 6.3 Daftar Langkah

  -------------------------------------------------------------------------
           No.          Jenis            Langkah/Halaman   Bila Gagal
  --------------------- ---------------- ----------------- ----------------
            1           Mulai            Anggota membuka   ---
                                         aplikasi.

            2           Halaman          Halaman daftar    ---
                                         kegiatan
                                         menampilkan nama,
                                         jadwal, dan
                                         status sesi.

            3           Halaman          Anggota memilih   ---
                                         kegiatan yang
                                         ingin dihadiri.

            4           Halaman          Halaman detail    ---
                                         kegiatan
                                         menampilkan nama,
                                         jadwal, lokasi,
                                         dan status sesi.

            5           Keputusan        Apakah sesi       Jika tidak,
                                         absensi sedang    tampilkan pesan
                                         dibuka?           dan kembali ke
                                                           daftar kegiatan.

            6           Halaman          Anggota menekan   ---
                                         tombol
                                         **Check-in**.

            7           Proses           Aplikasi mengirim Jika jaringan
                                         permintaan        terganggu,
                                         check-in ke       tampilkan pesan
                                         backend.          kegagalan.

            8           Keputusan        Apakah kehadiran  Jika tidak,
                                         berhasil tercatat tampilkan pesan
                                         tanpa duplikasi?  gagal dan
                                                           kembali ke
                                                           halaman detail.

            9           Halaman          Aplikasi          ---
                                         menampilkan
                                         konfirmasi
                                         **Kehadiran
                                         tercatat**.

           10           Tujuan           Kehadiran anggota ---
                                         tercatat.
  -------------------------------------------------------------------------

Jumlah langkah di luar titik mulai dan tujuan: **8** (No. 2--9). Jumlah
keputusan: **2** (No. 5 dan No. 8), masing-masing memiliki cabang gagal
yang ditindaklanjuti.

------------------------------------------------------------------------

## 7. Pemetaan Kebutuhan ke Antarmuka

  -------------------------------------------------------------------------------------
  ID Kebutuhan   Rumusan (Ringkas) Prioritas      Halaman yang   Widget yang
                                                  Memenuhi       Direncanakan
                                                                 (Pertemuan 3)
  -------------- ----------------- -------------- -------------- ----------------------
  F-01           Melihat daftar    Must           Halaman daftar `Scaffold` +
                 kegiatan                         kegiatan       `Column` +
                                                                 `ListView.builder` +
                                                                 `Card`

  F-02           Melihat detail    Must           Halaman detail `Scaffold` +
                 kegiatan dan                     kegiatan       `Column` + `Row` +
                 status sesi                                     `Container` badge

  F-03           Melakukan         Must           Halaman detail `ElevatedButton` +
                 check-in                         kegiatan       indikator proses dalam
                 kehadiran                                       `Column`

  F-04           Melihat status    Must           Halaman        `ListView.builder` +
                 dan riwayat                      riwayat        `ListTile`
                 kehadiran                        kehadiran

  F-05           Membuka/menutup   Must           Halaman        `Scaffold` +
                 sesi absensi                     pengelolaan    `Column` +
                                                  sesi (panitia) `ElevatedButton`

  F-06           Melihat daftar    Should         Halaman daftar `ListView.builder` +
                 anggota hadir                    kehadiran      `ListTile`
                                                  (panitia)

  F-07           Membuat kegiatan  Should         Halaman        `Scaffold` + `Column`;
                 baru                             formulir       formulir detail
                                                  kegiatan       dibahas pada pertemuan
                                                  (panitia)      lanjutan

  F-08           Melihat rekap     Could          Halaman rekap  `ListView.builder` +
                 kehadiran                        (pengurus)     `Row`

  F-09           Notifikasi        Won't          Belum          ---
                 pengingat                        direncanakan
                                                  untuk
                                                  implementasi
                                                  saat ini
  -------------------------------------------------------------------------------------

------------------------------------------------------------------------

## Catatan

Dokumen ini menjadi dasar perancangan antarmuka aplikasi Absensi
Organisasi Mahasiswa. Kebutuhan dan prioritas fitur dapat ditinjau
kembali ketika implementasi berkembang dan materi perkuliahan berikutnya
telah dibahas.

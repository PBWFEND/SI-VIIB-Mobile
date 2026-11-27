# Catatan Integrasi REST API — FasKampus

## 1. Pendahuluan

Pada Tugas 9, aplikasi FasKampus dikembangkan dengan mengintegrasikan REST API menggunakan Flutter dan Dart.

Integrasi API dilakukan untuk mempelajari proses pertukaran data antara aplikasi dengan server. API yang digunakan dalam praktikum ini adalah JSONPlaceholder sebagai layanan simulasi REST API.

Terdapat dua metode HTTP yang diterapkan, yaitu GET untuk mengambil data dan POST untuk mengirim data.

## 2. Endpoint API

API yang digunakan:

`https://jsonplaceholder.typicode.com`

Berikut endpoint yang diterapkan dalam aplikasi:

| No. | Endpoint | Metode HTTP | Fungsi |
|---|---|---|---|
| 1 | `/posts` | GET | Mengambil daftar data dari server. |
| 2 | `/posts` | POST | Mengirim data pengajuan baru ke server simulasi. |

### 2.1 GET — Mengambil Data

URL:

`https://jsonplaceholder.typicode.com/posts`

Metode: `GET`

Proses GET digunakan untuk mengambil daftar data dari server. Data yang diterima berupa JSON array, kemudian diubah menjadi objek `DataPengajuan` menggunakan fungsi `fromJson()`.

Contoh respons JSON:

```json
{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere",
  "body": "quia et suscipit..."
}
```

Aplikasi mengambil maksimal 10 data dari respons API untuk ditampilkan pada halaman integrasi REST API.

### 2.2 POST — Mengirim Data

URL:

`https://jsonplaceholder.typicode.com/posts`

Metode: `POST`

Proses POST digunakan untuk mengirim data pengajuan fasilitas melalui form yang tersedia pada halaman API.

Contoh payload JSON:

```json
{
  "namaFasilitas": "Aula Kampus",
  "tanggal": "2026-11-26",
  "jamMulai": "08:00",
  "jamSelesai": "10:00",
  "tujuan": "Seminar organisasi mahasiswa",
  "status": "Menunggu",
  "title": "Aula Kampus",
  "body": "Seminar organisasi mahasiswa",
  "userId": 1
}
```

Contoh respons JSON dari server:

```json
{
  "namaFasilitas": "Aula Kampus",
  "tanggal": "2026-11-26",
  "jamMulai": "08:00",
  "jamSelesai": "10:00",
  "tujuan": "Seminar organisasi mahasiswa",
  "status": "Menunggu",
  "title": "Aula Kampus",
  "body": "Seminar organisasi mahasiswa",
  "userId": 1,
  "id": 101
}
```

Respons POST digunakan untuk menunjukkan bahwa data berhasil dikirim. JSONPlaceholder merupakan API simulasi, sehingga data yang dikirim tidak disimpan secara permanen sebagai data backend FasKampus.

## 3. Model Data

Model data menggunakan class `DataPengajuan` yang terdapat pada file `data_pengajuan.dart`.

Model ini digunakan untuk menampung data pengajuan fasilitas kampus.

Atribut yang digunakan:

| Atribut | Tipe Data | Keterangan |
|---|---|---|
| `id` | String | Identitas pengajuan. |
| `namaFasilitas` | String | Nama fasilitas yang dipinjam. |
| `tanggal` | String | Tanggal peminjaman. |
| `jamMulai` | String | Waktu mulai peminjaman. |
| `jamSelesai` | String | Waktu selesai peminjaman. |
| `tujuan` | String | Tujuan kegiatan. |
| `status` | String | Status pengajuan. |

### 3.1 JSON Parsing

Proses JSON parsing dilakukan menggunakan factory constructor:

`DataPengajuan.fromJson(Map<String, dynamic> json)`

Fungsi ini bertugas mengubah data JSON dari server menjadi objek Dart.

Beberapa atribut disesuaikan dengan struktur respons JSONPlaceholder. Contohnya, atribut `title` digunakan sebagai sumber nama fasilitas dan atribut `body` digunakan sebagai sumber tujuan kegiatan.

Dengan demikian, data dari API dapat ditampilkan menggunakan struktur model yang sudah disiapkan untuk aplikasi FasKampus.

## 4. Struktur Service API

File `service_api.dart` digunakan untuk memisahkan proses komunikasi dengan server dari tampilan aplikasi.

Class `PengajuanService` memiliki fungsi utama:

1. `ambilDaftarPengajuan()` — Mengirim permintaan GET dan mengambil daftar data dari server.
2. `kirimPengajuan()` — Mengirim data pengajuan menggunakan metode POST.
3. `dispose()` — Menutup HTTP client setelah tidak digunakan.

Pemisahan ini membuat kode komunikasi API lebih terstruktur dan memudahkan pengelolaan data.

## 5. Penanganan Kondisi Aplikasi

Pada file `halaman_api.dart`, terdapat tiga kondisi utama ketika aplikasi melakukan pengambilan data.

### 5.1 Loading State

Loading state ditampilkan ketika aplikasi sedang menunggu respons dari server.

Komponen yang digunakan adalah `CircularProgressIndicator` disertai teks:

`Memuat data dari server...`

### 5.2 Success State

Success state ditampilkan ketika permintaan GET berhasil dan data diterima dari server.

Data kemudian ditampilkan dalam bentuk daftar yang berisi nama fasilitas, tanggal, tujuan kegiatan, dan ID data.

### 5.3 Error State

Error state ditampilkan ketika proses pengambilan data gagal.

Aplikasi menampilkan:
- Ikon kegagalan koneksi.
- Pesan bahwa data gagal dimuat.
- Informasi kesalahan yang diterima.
- Tombol **Coba Lagi** untuk mengulangi permintaan GET.

## 6. Penanganan Error dan Timeout

Penanganan error dilakukan pada service API menggunakan mekanisme `try-catch`.

Beberapa kondisi yang ditangani antara lain:

| Kondisi | Penanganan |
|---|---|
| HTTP status tidak sesuai | Menampilkan informasi kegagalan permintaan. |
| Koneksi mengalami timeout | Menampilkan pesan bahwa permintaan melewati batas waktu. |
| Kesalahan format JSON | Menangani `FormatException`. |
| Kegagalan koneksi | Menangani `http.ClientException`. |
| Permintaan berhasil | Data diproses dan ditampilkan pada halaman aplikasi. |

Batas waktu permintaan API yang digunakan adalah 10 detik. Dengan adanya penanganan tersebut, aplikasi dapat memberikan informasi ketika komunikasi dengan server mengalami masalah.

## 7. Kesimpulan

Melalui integrasi REST API ini, aplikasi FasKampus sudah menerapkan proses pengambilan dan pengiriman data menggunakan HTTP GET dan POST.

Aplikasi juga memiliki tampilan loading, success, dan error sehingga pengguna dapat mengetahui kondisi proses komunikasi dengan server.

Penggunaan model data, JSON parsing, dan service API membantu membuat struktur program lebih terorganisasi. JSONPlaceholder digunakan sebagai media simulasi pembelajaran dan belum menjadi backend permanen untuk aplikasi FasKampus.
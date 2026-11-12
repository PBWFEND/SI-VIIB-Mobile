# Catatan Integrasi API — Tugas 9

* **Nama / NIM:** Nazwa Umaira Nanindia Ramdhani / 230660221008
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pengaduan Fasilitas Kampus
* **Model Data Utama:** `LaporanFasilitas`

---

## 1. Endpoint yang Digunakan

Integrasi REST API pada aplikasi Pengaduan Fasilitas Kampus menggunakan layanan simulasi publik JSONPlaceholder sebagai backend terpusat untuk membaca daftar laporan kerusakan dan mengirimkan laporan pengaduan baru.

| Operasi | Metode HTTP | URL Endpoint | Payload Request |
|:--------|:------------|:-------------|:----------------|
| Ambil daftar laporan | `GET` | `https://jsonplaceholder.typicode.com/posts` | — |
| Kirim laporan baru | `POST` | `https://jsonplaceholder.typicode.com/posts` | `{"fasilitas": "Proyektor Ruang 301", "kategori": "Elektronik", "kendala": "Lampu proyektor redup", "status": "Menunggu", "pelapor": "Felix"}` |

### Ketentuan Header & Format Pertukaran Data
* **Format Data:** Seluruh komunikasi request dan response menggunakan format **JSON** (*JavaScript Object Notation*).
* **Header Wajib (`POST`):** Menyertakan `'Content-Type': 'application/json; charset=UTF-8'` agar server mengenali body request sebagai objek JSON.
* **Format Response:**
  * Operasi `GET` mengembalikan **JSON Array** berisi daftar objek laporan dengan status HTTP `200 OK`.
  * Operasi `POST` mengembalikan **JSON Object** dari laporan yang baru dibuat beserta `id` baru dari server dengan status HTTP `201 Created`.

---

## 2. Struktur Model Data

Data JSON dari server diuraikan (*deserialization*) menjadi objek Dart bertipe kuat menggunakan *factory constructor* `LaporanFasilitas.fromJson()` dan diubah kembali menjadi format Map menggunakan `toJson()` saat dikirim ke server.

| Field | Tipe Dart | Key JSON | Sumber Nilai |
|:------|:----------|:---------|:-------------|
| `id` | `String` | `"id"` | Server (dikonversi aman dari `int`/`dynamic` ke `String` dengan nilai default `'0'`) |
| `fasilitas` | `String` | `"fasilitas"` / `"title"` | Server (`title` saat simulasi `GET` dari `/posts`, atau `fasilitas` dari balasan `POST`) |
| `kategori` | `String` | `"kategori"` | Input form mahasiswa saat `POST`; nilai default `'Umum'` jika tidak tersedia dari server |
| `kendala` | `String` | `"kendala"` / `"body"` | Server (`body` saat simulasi `GET` dari `/posts`, atau `kendala` dari balasan `POST`) |
| `status` | `String` | `"status"` | Nilai awal `'Menunggu'` saat laporan dikirim (`POST`) maupun sebagai default saat `GET` |
| `pelapor` | `String` | `"pelapor"` | Identitas pengguna pelapor (contoh: `'Felix'`), dengan fallback `'Mahasiswa (Felix)'` |

### Penanganan Nilai Kosong (*Null-Safety*)
Setiap pemetaan field di dalam `LaporanFasilitas.fromJson()` dilengkapi operator *null-coalescing* (`??`) dan konversi tipe yang aman (`?.toString()`). Hal ini mencegah aplikasi mengalami *runtime crash* (`TypeError`) apabila server mengirimkan nilai `null` atau struktur JSON yang tidak lengkap.

---

## 3. Penanganan Error

Seluruh logika pemanggilan HTTP diisolasi di dalam lapisan service (`PengaduanApiService` pada `service-api.dart`) dan dilengkapi tiga lapis pengaman agar aplikasi tetap stabil saat terjadi gangguan jaringan:

1. **Pengecekan Status Code HTTP:**
   * Aplikasi memeriksa `response.statusCode` sebelum melakukan `jsonDecode`.
   * Untuk `GET`, hanya status `200` yang diproses sebagai data valid. Untuk `POST`, hanya status `201` (atau `200`) yang dianggap berhasil.
   * Jika server mengembalikan kode error seperti `404` (*Not Found*) atau `500` (*Internal Server Error*), service melempar `Exception` dengan keterangan kode HTTP yang jelas.
2. **Batas Waktu Tunggu (*Timeout*):**
   * Setiap pemanggilan `http.get` dan `http.post` diberi batas waktu `.timeout(const Duration(seconds: 10))`.
   * Jika server tidak merespons dalam 10 detik, `TimeoutException` akan ditangkap dan diubah menjadi pesan ramah pengguna (*"Waktu tunggu habis (timeout). Periksa koneksi internet Anda."*).
3. **Blok `try-catch` & Pemulihan Antarmuka (*Retry*):**
   * Seluruh proses request dibungkus blok `try-catch` untuk menangkap `SocketException` / `http.ClientException` (saat perangkat offline atau URL salah) maupun kegagalan *parsing* JSON.
   * Pada antarmuka (`halaman-api.dart`), error tersebut tidak memunculkan layar merah, melainkan menampilkan pesan error yang informatif beserta tombol **"Coba Lagi"** (*retry*) agar pengguna dapat memuat ulang data tanpa menutup aplikasi.
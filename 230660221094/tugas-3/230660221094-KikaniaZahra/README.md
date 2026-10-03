# SIPUSKAM — Tugas Pertemuan 3

## Identitas

**Nama:** Kikania Zahra
**NPM:** 230660221094
**Mata Kuliah:** Pemrograman Aplikasi Bergerak (PAB)
**Tugas:** Pertemuan 3 — Struktur Widget Flutter
**Project:** SIPUSKAM

---

## Deskripsi

SIPUSKAM merupakan aplikasi mobile berbasis Flutter yang dikembangkan sebagai implementasi materi **Pertemuan 3: Struktur Widget dan Widget Tree**.

Pada tugas ini, aplikasi dibuat untuk memahami struktur dasar Flutter serta hubungan antara widget **parent** dan **child** dalam membangun tampilan aplikasi.

---

## Tujuan

Tujuan pengerjaan tugas ini adalah:

1. Memahami struktur dasar aplikasi Flutter.
2. Memahami penggunaan `MaterialApp` dan `Scaffold`.
3. Memahami konsep **Widget Tree** pada Flutter.
4. Mengimplementasikan beberapa widget dasar Flutter.
5. Menjalankan aplikasi menggunakan Flutter pada perangkat/browser.

---

## Struktur Widget Tree

Struktur widget pada aplikasi SIPUSKAM secara umum adalah:

```text
runApp()
└── SipuskamApp
    └── MaterialApp
        └── HomePage
            └── Scaffold
                ├── AppBar
                ├── body
                │   └── Column
                │       ├── Padding
                │       └── Expanded
                │           └── ListView.builder
                │               └── Card
                └── FloatingActionButton
```

Widget Tree tersebut menunjukkan hubungan hierarki antara widget utama dengan widget yang berada di dalamnya.

---

## Widget yang Digunakan

### 1. `MaterialApp`

Digunakan sebagai widget utama aplikasi Flutter yang menyediakan konfigurasi dasar seperti tema dan halaman awal aplikasi.

### 2. `Scaffold`

Digunakan sebagai struktur dasar halaman yang menyediakan bagian seperti:

* `AppBar`
* `body`
* `FloatingActionButton`

### 3. `AppBar`

Digunakan untuk menampilkan bagian atas aplikasi yang berisi judul halaman.

### 4. `Column`

Digunakan untuk menyusun beberapa widget secara vertikal.

### 5. `Padding`

Digunakan untuk memberikan jarak antara isi widget dengan batas di sekitarnya.

### 6. `Expanded`

Digunakan agar widget di dalam `Column` dapat menggunakan ruang yang tersedia.

### 7. `ListView.builder`

Digunakan untuk menampilkan daftar data secara dinamis dan dapat digulir.

### 8. `Card`

Digunakan sebagai wadah untuk menampilkan informasi dalam bentuk kartu.

### 9. `FloatingActionButton`

Digunakan sebagai tombol aksi utama yang berada pada bagian bawah halaman.

---

## Widget Tree Image

Dokumentasi Widget Tree dapat dilihat pada file:

**`widget-tree-sipuskam-rapi.png`**

Gambar tersebut menunjukkan hubungan hierarki widget yang digunakan dalam aplikasi SIPUSKAM.

---

## Struktur Folder

```text
sipuskam/
├── lib/
│   └── main.dart
├── widget-tree-sipuskam-rapi.png
└── README.md
```

---

## Cara Menjalankan Project

Pastikan Flutter SDK sudah terpasang dan dapat digunakan.

Jalankan perintah berikut pada terminal:

```bash
flutter pub get
```

Kemudian jalankan aplikasi:

```bash
flutter run -d chrome
```

Atau dapat menggunakan perangkat/emulator yang tersedia:

```bash
flutter run
```

---

## Kesimpulan

Melalui tugas ini, struktur dasar aplikasi Flutter dan konsep **Widget Tree** dapat dipahami dengan melihat hubungan antara widget parent dan child. Penggunaan `MaterialApp`, `Scaffold`, `AppBar`, `Column`, `Expanded`, `ListView.builder`, `Card`, dan `FloatingActionButton` menjadi dasar dalam membangun antarmuka aplikasi SIPUSKAM.

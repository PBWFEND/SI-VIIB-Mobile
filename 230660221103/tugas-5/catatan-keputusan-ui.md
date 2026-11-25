# Catatan Keputusan UI/UX — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Tabel Keputusan Desain Antarmuka

| Keputusan | Pilihan Anda | Alasan (Merujuk Kebutuhan / Persona / Prinsip Mobile) |
| :--- | :--- | :--- |
| **Warna benih (*seed color*)** | `Colors.deepOrange` dengan skema `ColorScheme.fromSeed` (Material 3) | Warna oranye hangat secara psikologis menggugah selera makan dan memberikan identitas visual yang kuat untuk domain kantin, sementara `ColorScheme.fromSeed` menjaga kontras dan konsistensi warna otomatis di seluruh komponen. |
| **Bentuk status ketersediaan** | `Chip` berwarna menggunakan operator ternary (`secondaryContainer` untuk "Tersedia" dan `errorContainer` untuk "Habis") | Memenuhi prinsip **feedback & konsistensi** serta membantu persona Dinda (mahasiswa dengan sesi penggunaan singkat) membedakan stok makanan dalam sekali lirik tanpa harus membaca detail teks. |
| **Posisi & bentuk aksi utama** | `FloatingActionButton.extended` bertuliskan "Lihat Keranjang" di pojok kanan bawah layar | Memenuhi prinsip **target sentuh memadai** (area tekan > 48×48 dp) dan ergonomis untuk jangkauan ibu jari saat pengguna dalam konteks bergerak menuju kantin, sekaligus mendukung alur menuju **F-04**. |
| **Hierarki teks & kartu daftar** | Judul menggunakan `textTheme.titleLarge` tebal, keterangan menggunakan `textTheme.bodySmall` redup, dibungkus dalam `Card` + `ListTile` | Memenuhi prinsip **hierarki visual & keterbacaan** pada layar ponsel berukuran kecil sehingga nama menu (**F-01**) langsung menonjol dibanding informasi nama stan dan harga. |
| **Penanganan keadaan kosong (*empty state*)** | `Center` berisi ikon `Icons.no_meals_outlined` dan teks keterangan ketika `daftarMenu.isEmpty` | Mencegah layar tampak putih kosong tanpa penjelasan apabila seluruh stan belum membuka menu atau data gagal dimuat, sehingga pengguna tetap mendapat kejelasan status sistem. |
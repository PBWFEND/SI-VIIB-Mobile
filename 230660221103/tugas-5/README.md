# Tugas 5: Prototype UI/UX

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB
* **Domain Sistem Informasi:** Pemesanan & Antrean Kantin Kampus

---

## 1. Deskripsi Singkat Tugas

Tugas ini menerjemahkan dokumen analisis kebutuhan (Tugas 4) aplikasi **Kantin Kampus Digital** menjadi *Information Architecture* (IA), rancangan *wireframe low-fidelity* dua layar (layar utama katalog menu beserta keadaan kosong dan layar pendukung keranjang pesanan), catatan keputusan UI/UX berbasis lima prinsip antarmuka mobile, serta implementasi halaman utama menggunakan Flutter Material 3 (`ColorScheme.fromSeed`)[cite: 21, 22].

---

## 2. Daftar Berkas

* `information-architecture.md` — Inventaris layar, diagram peta layar (IA), dan justifikasi pemilihan layar utama[cite: 21, 22].
* `wireframe.png` — Sketsa tata letak *low-fidelity* beranotasi (sumber: `wireframe.excalidraw`)[cite: 21, 22].
* `halaman-utama.dart` — Kode implementasi layar utama Flutter dengan tema terpusat[cite: 21, 22].
* `screenshot-halaman.png` — Tangkapan layar hasil eksekusi halaman utama pada Google Chrome[cite: 21, 22].
* `catatan-keputusan-ui.md` — Dokumentasi alasan pemilihan warna, status, aksi utama, dan hierarki visual[cite: 21, 22].

---

## 3. Refleksi

Bagian yang paling menantang untuk dipertahankan konsistensinya adalah **menjaga keselarasan antara anotasi pada wireframe, implementasi komponen kode Flutter, dan catatan keputusan UI** agar tidak ada widget tambahan yang muncul di kode tanpa dasar kebutuhan dari Tugas 4[cite: 21, 22]. Penyesuaian penggunaan warna dari `Theme.of(context).colorScheme` menggantikan warna manual (*hardcoded*) juga membutuhkan ketelitian agar kontras teks pada komponen `Chip` status tetap mudah dibaca. Melalui proses ini, saya memahami bahwa merancang *wireframe* terlebih dahulu jauh mempercepat penulisan struktur *widget tree* di Flutter.

---

Deklarasi penggunaan AI: Gemini — membantu menyusun kerangka pemetaan warna `ColorScheme.fromSeed` pada komponen `Card`, `ListTile`, dan `Chip` serta memvalidasi kesesuaian catatan keputusan UI dengan prinsip antarmuka mobile; seluruh rancangan dan kode disesuaikan kembali oleh penulis[cite: 21, 22].
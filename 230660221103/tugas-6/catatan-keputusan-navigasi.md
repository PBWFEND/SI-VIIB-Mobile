# Catatan Keputusan Navigasi & Interaksi — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## Tabel Keputusan Navigasi & Interaksi

| Keputusan | Pilihan Anda | Alasan (Merujuk IA / Kebutuhan) |
| :--- | :--- | :--- |
| **Nama route** | Peta terpusat pada `MaterialApp`: `'/'` (Katalog), `'/detail'` (Detail Menu), dan `'/pesan'` (Form Pemesanan) | Memetakan langsung layar dari IA Tugas 5 dengan penamaan huruf kecil konsisten yang mudah ditelusuri ke kebutuhan **F-01**, **F-03**, dan **F-04** tanpa risiko salah ketik nama kelas halaman. |
| **Data antarlayar** | Mengirim objek `DataMenu` melalui `arguments` saat navigasi dari `'/'` ke `'/detail'`, dibaca secara *read-only* dengan pengecekan `args is DataMenu ? args : null`[cite: 24, 25] | Memastikan halaman detail menampilkan informasi spesifik item yang diketuk pengguna (**F-01** & **F-03**) sekaligus mencegah aplikasi *crash* apabila route dibuka tanpa membawa data (*null safety*). |
| **Validator tiap field** | Validasi wajib isi (`trim().isEmpty`) pada Nama Pemesan dan Nama Menu, serta validasi numerik (`int.tryParse` > 0) pada Jumlah Porsi, ditambah pembersihan controller di `dispose()`[cite: 24, 25] | Mencegah masuknya data pesanan kosong, spasi saja, atau jumlah porsi tidak valid ke sistem (**F-03** & **F-04**) serta menjaga kebersihan memori perangkat saat layar form ditutup (`Navigator.pop`). |
| **Feedback tiap aksi** | Pesan error validator di bawah kolom form saat input salah, serta `SnackBar` konfirmasi rincian pesanan saat submit berhasil sebelum kembali ke katalog[cite: 24, 25] | Memberikan kepastian langsung kepada mahasiswa (persona Dinda) bahwa pesanannya telah diproses (simulasi) sehingga tidak menekan tombol kirim berulang kali di sela jadwal kuliah yang singkat. |
| **Mekanisme kembali** | Tombol `FilledButton` ("Kembali ke Daftar Menu") pada `'/detail'` dan `OutlinedButton` ("Batal") pada `'/pesan'` menggunakan `Navigator.pop(context)`, tanpa tombol kembali pada `'/'` | Menjamin layar dalam selalu memiliki jalan kembali yang jelas menuju katalog utama, sekaligus mencegah pengguna menutup aplikasi secara tidak sengaja saat berada di halaman awal (`initialRoute`). |
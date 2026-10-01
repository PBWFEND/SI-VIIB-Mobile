# Tugas 1 : Identifikasi Kebutuhan Aplikasi Bergerak
*Nama:* Annisa Nur Sabariyah
*NIM:* 230660221085
*Kelas:* SI-VIIB

---

## 2.1 Deskripsi Sistem 
Aplikasi *ReserverSpace* dikembangakan untuk memudahkan mahasiswa melakukan pemesanan untuk mengecek ketersediaan ruangan diskusi serta laboratorium kampus secara *realetime*. Saat ini, mahasiswa yang sering harus mendatangi gedung secara fisik hanya untuk melihat jadwal pemakaian ruang yang tertempel di dindingan, yang berisiko menyebabkan pemesanan ganda atau bentrok jadwal. Pengembanngan berbasis aplikasi *Moble* dipilih karena mendungkung *Konteks bergerak*, di mana mahasiswa membutuhkan kepastian ketersedian ruangan saat sedang berpindah antarkelas, serta *sesi penggunaan singkat* yang memungkinkan mahasiswa melakukan klaim atau pengecekan ruangan secara cepat hanya dalam hitungan detik tanpa harus mengoprasikan komputer laptop.

---

## 2.2 Daigram Arsitektur

berikut adalah gambaran arsitektur komunikasi dua arah antara aplikasi mobile, backend SI, dan database.

```mermaid
flowchart LR
	A["Aplikasi Mobile<br>(Flutter)"] -->|"HTTP Request<br>(JSON)"| B["Backend SI Pemesanan Ruang<br>(REST API)"]
	B -->|"Query & Transaksi Pemesanan"| C[("Database Ruangan")]
	C -->|"Data Ruang & Jadwal"| B
	B -->|"HTTP Response<br>(JSON)"| A

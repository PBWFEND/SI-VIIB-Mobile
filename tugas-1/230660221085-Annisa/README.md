## Tugas 1 Identifikasi Kebutuhan Aplikasi Bergerak
**Nama:** Annisa  
**NIM:** 230660221085  
**Kelas:** SI-VIIB

---

## 2.1 Deskripsi Sistem
Aplikasi **ReserveSpace** dikembangkan untuk memudahkan mahasiswa melakukan pemesanan dan mengecek ketersediaan ruang diskusi serta laboratorium kampus secara *real-time*. Saat ini, mahasiswa sering harus mendatangi gedung secara fisik hanya untuk melihat jadwal pemakaian ruang yang tertempel di dinding, yang berisiko menyebabkan pemesanan ganda atau bentrok jadwal. Pengembangan berbasis aplikasi *mobile* dipilih karena mendukung **konteks bergerak**, di mana mahasiswa membutuhkan kepastian ketersediaan ruang saat sedang berpindah antarkelas, serta **sesi penggunaan singkat** yang memungkinkan mahasiswa melakukan klaim atau pengecekan ruang secara cepat hanya dalam hitungan detik tanpa harus mengoperasikan komputer laptop.

---

## 2.2 Diagram Arsitektur

Berikut adalah gambaran arsitektur komunikasi dua arah antara aplikasi mobile, backend SI, dan database:

```mermaid
flowchart LR
	A["Aplikasi Mobile<br>(Flutter)"] -->|"HTTP Request<br>(JSON)"| B["Backend SI Pemesanan Ruang<br>(REST API)"]
	B -->|"Query & Transaksi Pemesanan"| C[("Database Ruangan")]
	C -->|"Data Ruang & Jadwal"| B
	B -->|"HTTP Response<br>(JSON)"| A

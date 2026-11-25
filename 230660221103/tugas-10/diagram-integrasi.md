# Diagram Integrasi Data dan Proses Bisnis — Kantin Kampus Digital

* **Nama:** Reina Anatasya Kusumah Putri
* **NIM:** 230660221103
* **Kelas:** SI-VIIB

---

## 1. Diagram Alur Integrasi Paralel (`Future.wait`)

```mermaid
sequenceDiagram
    actor Mhs as Pengelola / Mahasiswa
    participant UI as HalamanIntegrasiPesanan
    participant Svc as IntegrasiKantinService
    participant Users as GET /users
    participant Posts as GET /posts

    Mhs->>UI: Buka halaman antrean terintegrasi
    UI->>UI: setState(_sedangMemuat = true)
    UI->>Svc: ambilPesananTerintegrasi()
    par Eksekusi Paralel Future.wait
        Svc->>Users: HTTP GET /users
        Svc->>Posts: HTTP GET /posts
    end
    Users-->>Svc: 200 OK (JSON Daftar Pemesan)
    Posts-->>Svc: 200 OK (JSON Daftar Pesanan)
    Svc->>Svc: Gabungkan berdasarkan pesanan.userId == pemesan.id
    Svc-->>UI: List<PesananTerintegrasi>
    UI->>UI: setState(_sedangMemuat = false, _semuaPesanan = hasil)
    UI-->>Mhs: Tampilkan kartu pesanan lengkap dengan nama pemesan & status
class PengaduanValidator {
  static const int panjangMinLokasi = 3;
  static const int panjangMaxLokasi = 80;
  static const int panjangMinDeskripsi = 10;
  static const int panjangMaxDeskripsi = 500;
  static const int batasUkuranFotoByte = 5 * 1024 * 1024;
  static const List ekstensiFotoValid = ['jpg', 'jpeg', 'png', 'webp'];

  static String? validasiNim(String? value) {
    final nim = value?.trim() ?? '';
    if (nim.isEmpty) {
      return 'NIM wajib diisi.';
    }
    final regexAngka = RegExp(r'^[0-9]{10,12}$');
    if (!regexAngka.hasMatch(nim)) {
      return 'NIM harus berupa 10 sampai 12 digit angka.';
    }
    return null;
  }

  static String? validasiEmail(String? value) {
    final email = value?.trim().toLowerCase() ?? '';
    if (email.isEmpty) {
      return 'Email wajib diisi untuk notifikasi status pengaduan.';
    }
    if (email.length > 100) {
      return 'Email maksimal 100 karakter.';
    }
    final regexEmail = RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
    if (!regexEmail.hasMatch(email)) {
      return 'Format email tidak valid (contoh: mahasiswa@kampus.ac.id).';
    }
    return null;
  }

  static String? validasiLokasi(String? value) {
    final lokasi = value?.trim() ?? '';
    if (lokasi.isEmpty) {
      return 'Lokasi ruangan atau fasilitas wajib diisi.';
    }
    if (lokasi.length < panjangMinLokasi) {
      return 'Lokasi minimal $panjangMinLokasi karakter.';
    }
    if (lokasi.length > panjangMaxLokasi) {
      return 'Lokasi maksimal $panjangMaxLokasi karakter.';
    }
    return null;
  }

  static String? validasiTanggalKejadian(
    String? value, {
    DateTime? referensiSekarang,
  }) {
    final teksTanggal = value?.trim() ?? '';
    if (teksTanggal.isEmpty) {
      return 'Tanggal temuan kerusakan wajib diisi (YYYY-MM-DD).';
    }

    final regexIso = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regexIso.hasMatch(teksTanggal)) {
      return 'Gunakan format tanggal YYYY-MM-DD (contoh: 2026-11-25).';
    }

    final DateTime? tanggalParsed = DateTime.tryParse(teksTanggal);
    if (tanggalParsed == null) {
      return 'Tanggal tidak valid pada kalender.';
    }

    final bagian = teksTanggal.split('-');
    final tahun = int.parse(bagian[0]);
    final bulan = int.parse(bagian[1]);
    final hari = int.parse(bagian[2]);
    if (tanggalParsed.year != tahun ||
        tanggalParsed.month != bulan ||
        tanggalParsed.day != hari) {
      return 'Tanggal kalender tidak valid.';
    }

    final sekarang = referensiSekarang ?? DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final tanggalInput = DateTime(tahun, bulan, hari);

    if (tanggalInput.isAfter(hariIni)) {
      return 'Tanggal kejadian tidak boleh melebihi hari ini.';
    }

    final batasTerlama = hariIni.subtract(const Duration(days: 30));
    if (tanggalInput.isBefore(batasTerlama)) {
      return 'Tanggal kejadian maksimal 30 hari terakhir.';
    }

    return null;
  }

  static String? validasiDeskripsi(String? value) {
    final deskripsi = value?.trim() ?? '';
    if (deskripsi.isEmpty) {
      return 'Deskripsi kerusakan wajib diisi.';
    }
    if (deskripsi.length < panjangMinDeskripsi) {
      return 'Deskripsi minimal $panjangMinDeskripsi karakter agar jelas bagi petugas.';
    }
    if (deskripsi.length > panjangMaxDeskripsi) {
      return 'Deskripsi maksimal $panjangMaxDeskripsi karakter.';
    }
    return null;
  }

  static String? validasiLampiranFoto({
    required String namaFile,
    required int ukuranByte,
  }) {
    final namaBersih = namaFile.trim();
    if (namaBersih.isEmpty) {
      return 'Nama berkas lampiran tidak valid.';
    }

    final ekstensi = namaBersih.contains('.')
        ? namaBersih.split('.').last.toLowerCase()
        : '';
    if (!ekstensiFotoValid.contains(ekstensi)) {
      return 'Format berkas harus JPG, JPEG, PNG, atau WEBP.';
    }

    if (ukuranByte <= 0) {
      return 'Berkas foto kosong atau rusak.';
    }

    if (ukuranByte > batasUkuranFotoByte) {
      return 'Ukuran foto maksimal 5 MB.';
    }

    return null;
  }
}

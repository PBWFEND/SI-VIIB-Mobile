// Tugas 12: Validasi dan Keamanan Praktis — Modul Validator & Token Storage
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — penyusunan aturan validator berlapis, sanitasi input, dan abstraksi penyimpanan token

/// Kumpulan validator terpusat untuk form Kantin Kampus Digital
class ValidatorKantin {
  /// 1. Validator Nama Pemesan (wajib diisi, minimal 3 karakter, maksimal 60 karakter, hanya huruf/spasi)
  static String? validasiNamaPemesan(String? value) {
    final teks = value?.trim() ?? '';
    if (teks.isEmpty) {
      return 'Nama pemesan wajib diisi.';
    }
    if (teks.length < 3) {
      return 'Nama pemesan minimal 3 karakter.';
    }
    if (teks.length > 60) {
      return 'Nama pemesan maksimal 60 karakter.';
    }
    final polaNama = RegExp(r"^[a-zA-Z\s'.-]+$");
    if (!polaNama.hasMatch(teks)) {
      return 'Nama hanya boleh berisi huruf dan tanda baca standar.';
    }
    return null;
  }

  /// 2. Validator Email Mahasiswa (wajib diisi, format email standar, maksimal 100 karakter)
  static String? validasiEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email mahasiswa wajib diisi untuk konfirmasi pesanan.';
    }
    if (email.length > 100) {
      return 'Email maksimal 100 karakter.';
    }
    final polaEmail = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!polaEmail.hasMatch(email)) {
      return 'Format email tidak valid (contoh: reina@kampus.ac.id).';
    }
    return null;
  }

  /// 3. Validator Jumlah Porsi (wajib angka bulat positif rentang 1 s.d. 50)
  static String? validasiJumlahPorsi(String? value) {
    final teks = value?.trim() ?? '';
    if (teks.isEmpty) {
      return 'Jumlah porsi wajib diisi.';
    }
    final jumlah = int.tryParse(teks);
    if (jumlah == null) {
      return 'Jumlah porsi harus berupa angka bulat.';
    }
    if (jumlah < 1 || jumlah > 50) {
      return 'Jumlah porsi harus di antara 1 sampai 50 porsi per transaksi.';
    }
    return null;
  }

  /// 4. Validator Nomor Meja / Stan (wajib diisi, angka 1 s.d. 99)
  static String? validasiNomorMeja(String? value) {
    final teks = value?.trim() ?? '';
    if (teks.isEmpty) {
      return 'Nomor meja atau kode pengambilan wajib diisi.';
    }
    final nomor = int.tryParse(teks);
    if (nomor == null || nomor < 1 || nomor > 99) {
      return 'Masukkan nomor meja yang valid (1 - 99).';
    }
    return null;
  }

  /// 5. Validator Catatan Pesanan (opsional, maksimal 150 karakter, cegah karakter tag HTML)
  static String? validasiCatatan(String? value) {
    final teks = value?.trim() ?? '';
    if (teks.length > 150) {
      return 'Catatan pesanan maksimal 150 karakter.';
    }
    if (teks.contains('<') || teks.contains('>')) {
      return 'Catatan tidak boleh mengandung karakter < atau >.';
    }
    return null;
  }
}

/// Kontrak penyimpanan token yang aman (pada production dipetakan ke flutter_secure_storage)
abstract class TokenStorage {
  Future<void> simpan(String token);
  Future<String?> baca();
  Future<void> hapus();
}

/// Implementasi penyimpanan sesi sementara tanpa hardcode secret maupun logging token
class SesiTokenStorage implements TokenStorage {
  String? _tokenTersimpan;

  @override
  Future<void> simpan(String token) async {
    _tokenTersimpan = token;
  }

  @override
  Future<String?> baca() async {
    return _tokenTersimpan;
  }

  @override
  Future<void> hapus() async {
    _tokenTersimpan = null;
  }
}
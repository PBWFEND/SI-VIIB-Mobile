abstract class TokenStorage {
  Future simpan(String token);
  Future baca();
  Future hapus();
  Future memilikiSesiAktif();
}

class SecureSessionTokenStorage implements TokenStorage {
  String? _tokenTersimpan;

  @override
  Future simpan(String token) async {
    final bersih = token.trim();
    if (bersih.isEmpty) {
      throw ArgumentError('Token sesi tidak boleh kosong.');
    }
    _tokenTersimpan = bersih;
  }

  @override
  Future baca() async {
    return _tokenTersimpan;
  }

  @override
  Future hapus() async {
    _tokenTersimpan = null;
  }

  @override
  Future memilikiSesiAktif() async {
    return _tokenTersimpan != null && _tokenTersimpan!.isNotEmpty;
  }
}

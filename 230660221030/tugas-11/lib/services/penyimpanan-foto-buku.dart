import 'dart:typed_data';

import 'package:sembast/blob.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class PenyimpananFotoBuku {
  Database? _database;

  final _store = stringMapStoreFactory.store('foto_buku');

  // Membuka database IndexedDB
  Future<Database> get database async {
    _database ??= await databaseFactoryWeb.openDatabase(
      'pustakaku_foto.db',
    );

    return _database!;
  }

  // Menyimpan foto berdasarkan ID buku
  Future<void> simpanFoto(String idBuku, Uint8List bytes) async {
    final db = await database;

    await _store.record(idBuku).put(db, {
      'foto': Blob(bytes),
    });
  }

  // Mengambil foto berdasarkan ID buku
  Future<Uint8List?> ambilFoto(String idBuku) async {
    final db = await database;

    final data = await _store.record(idBuku).get(db);

    if (data == null) {
      return null;
    }

    final foto = data['foto'] as Blob;

    return foto.bytes;
  }

  // Menghapus foto buku
  Future<void> hapusFoto(String idBuku) async {
    final db = await database;

    await _store.record(idBuku).delete(db);
  }
}
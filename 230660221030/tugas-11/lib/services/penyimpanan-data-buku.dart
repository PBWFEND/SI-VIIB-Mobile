import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class PenyimpananDataBuku {
  Database? _database;

  final _store = stringMapStoreFactory.store('data_buku');

  Future<Database> get database async {
    _database ??= await databaseFactoryWeb.openDatabase(
      'pustakaku_data.db',
    );

    return _database!;
  }

  // Menyimpan seluruh daftar buku
  Future<void> simpanSemuaBuku(
    List<Map<String, dynamic>> daftarBuku,
  ) async {
    final db = await database;

    await db.transaction((transaction) async {
      await _store.delete(transaction);

      for (final buku in daftarBuku) {
        await _store.record(buku['id'] as String).put(
          transaction,
          buku,
        );
      }
    });
  }
 
  // Mengambil seluruh data buku
  Future<List<Map<String, dynamic>>> ambilSemuaBuku() async {
    final db = await database;

    final records = await _store.find(db);

    return records
        .map((record) => Map<String, dynamic>.from(record.value))
        .toList();
  }
}


import 'package:file_picker/file_picker.dart';

class LampiranService {
  /// Memilih satu dokumen dari perangkat.
  ///
  /// Format yang diperbolehkan:
  /// PDF, DOC, dan DOCX.
  ///
  /// Mengembalikan PlatformFile jika berhasil.
  /// Mengembalikan null jika pengguna membatalkan.
  Future<PlatformFile?> pilihDokumen() async {
    final hasil = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    return hasil;
  }
}
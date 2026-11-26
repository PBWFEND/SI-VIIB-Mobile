import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class InfoFileNaskah {
  final String namaFile;
  final String ekstensi;
  final int ukuranByte;
  final String? pathLokal;

  InfoFileNaskah({
    required this.namaFile,
    required this.ekstensi,
    required this.ukuranByte,
    this.pathLokal,
  });

  String get ukuranTerbaca {
    if (ukuranByte < 1024) return '$ukuranByte B';
    if (ukuranByte < 1024 * 1024) {
      return '${(ukuranByte / 1024).toStringAsFixed(1)} KB';
    }
    return '${(ukuranByte / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

class FileNaskahService {
  static const int _batasUkuranByte = 2 * 1024 * 1024; // 2 MB
  static const List<String> _ekstensiDiizinkan = ['pdf', 'doc', 'docx'];

  Future<InfoFileNaskah?> pilihFileNaskah() async {
    try {
      final FilePickerResult? hasil = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _ekstensiDiizinkan,
        allowMultiple: false,
        withData: kIsWeb,
      );

      // Pengguna membatalkan dialog pemilihan file
      if (hasil == null || hasil.files.isEmpty) {
        return null;
      }

      final PlatformFile file = hasil.files.first;
      final String ekstensi = (file.extension ?? '').toLowerCase();

      if (!_ekstensiDiizinkan.contains(ekstensi)) {
        throw Exception(
          'Format file tidak didukung. Pilih dokumen PDF, DOC, atau DOCX.',
        );
      }

      if (file.size <= 0) {
        throw Exception('File kosong atau tidak dapat dibaca oleh perangkat.');
      }

      if (file.size > _batasUkuranByte) {
        throw Exception(
          'Ukuran file melebihi batas maksimal 2 MB. Pilih file naskah yang lebih ringkas.',
        );
      }

      if (kIsWeb && file.bytes == null) {
        throw Exception('Gagal membaca isi file naskah dari browser.');
      }

      return InfoFileNaskah(
        namaFile: file.name,
        ekstensi: ekstensi,
        ukuranByte: file.size,
        pathLokal: kIsWeb ? null : file.path,
      );
    } on PlatformException catch (e) {
      if (e.code.toLowerCase().contains('permission') ||
          e.code.toLowerCase().contains('denied')) {
        throw Exception(
          'Izin akses penyimpanan ditolak. Aktifkan izin penyimpanan/file pada pengaturan perangkat.',
        );
      }
      throw Exception(
          'Gagal mengakses penyimpanan perangkat: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}

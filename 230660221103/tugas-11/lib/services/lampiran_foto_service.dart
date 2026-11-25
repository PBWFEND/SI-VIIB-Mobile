// Tugas 11: Integrasi Fitur Perangkat — Service Layer
// Nama  : Reina Anatasya Kusumah Putri
// NIM   : 230660221103
// Kelas : SI-VIIB
// Bantuan: Gemini — pemisahan lifecycle image_picker ke service layer dan penanganan pembatalan vs error

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

/// Kelas pembungkus hasil pemilihan foto agar service tidak menampilkan widget langsung
class HasilPilihFoto {
  const HasilPilihFoto({
    required this.namaFile,
    required this.pathFile,
    required this.bytesGambar,
    required this.ukuranKb,
  });

  final String namaFile;
  final String pathFile;
  final Uint8List bytesGambar;
  final double ukuranKb;
}

/// Exception khusus ketika izin perangkat ditolak pengguna/browser
class IzinPerangkatDitolakException implements Exception {
  const IzinPerangkatDitolakException(this.pesan);
  final String pesan;

  @override
  String toString() => pesan;
}

class LampiranFotoService {
  LampiranFotoService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  // Batas maksimal ukuran file lampiran bukti pembayaran (5 MB)
  static const int _batasUkuranBytes = 5 * 1024 * 1024;

  /// Mengambil foto dari kamera atau memilih gambar dari galeri/file perangkat.
  /// Mengembalikan null apabila pengguna membatalkan pemilihan (bukan error).
  Future<HasilPilihFoto?> pilihBuktiFoto({
    required ImageSource sumber,
  }) async {
    try {
      final XFile? fileTerpilih = await _picker.pickImage(
        source: sumber,
        maxWidth: 1600,
        imageQuality: 85,
      );

      // Nilai null menandakan pengguna menekan batal / menutup pemilih gambar
      if (fileTerpilih == null) {
        return null;
      }

      final Uint8List bytes = await fileTerpilih.readAsBytes();

      // Validasi ukuran file agar tidak membebani memori/jaringan
      if (bytes.length > _batasUkuranBytes) {
        throw Exception(
          'Ukuran gambar melebihi batas maksimal 5 MB. Pilih gambar yang lebih ringkas.',
        );
      }

      return HasilPilihFoto(
        namaFile: fileTerpilih.name,
        pathFile: fileTerpilih.path,
        bytesGambar: bytes,
        ukuranKb: bytes.length / 1024,
      );
    } on PlatformException catch (e) {
      // Menangani kondisi permission kamera/galeri ditolak oleh sistem/browser
      final kode = e.code.toLowerCase();
      if (kode.contains('denied') || kode.contains('permission')) {
        throw const IzinPerangkatDitolakException(
          'Izin akses kamera atau galeri ditolak. Aktifkan izin pada pengaturan browser/perangkat Anda lalu coba lagi.',
        );
      }
      throw Exception('Gagal mengakses perangkat kamera/galeri: ${e.message ?? e.code}');
    } catch (e) {
      if (e is IzinPerangkatDitolakException) rethrow;
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
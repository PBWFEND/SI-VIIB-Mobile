import 'package:image_picker/image_picker.dart';

class FotoBukuService {
  final ImagePicker _picker = ImagePicker();

  // Memilih foto dari galeri
  Future<XFile?> pilihDariGaleri() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 80,
    );
  }
}
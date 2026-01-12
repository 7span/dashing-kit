
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaService {
  MediaService._internal();

  static final instance = MediaService._internal();

  /// Pick Images from Camera or Gallery
  Future<File?> pickImage({
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    final pickedFile = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}

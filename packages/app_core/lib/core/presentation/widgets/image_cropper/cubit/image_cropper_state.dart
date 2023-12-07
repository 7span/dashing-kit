import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// State
class CustomImageCropperState {
  CustomImageCropperState({
    this.imageFileList,
    this.selectedImage,
    this.selectedIndex = 0,
    this.croppedFileList,
  });
  final List<XFile>? imageFileList;
  final XFile? selectedImage;
  final int selectedIndex;
  final List<CroppedFile>? croppedFileList;

  CustomImageCropperState copyWith({
    List<XFile>? imageFileList,
    XFile? selectedImage,
    int? selectedIndex,
    List<CroppedFile>? croppedFileList,
  }) {
    return CustomImageCropperState(
      imageFileList: imageFileList ?? this.imageFileList,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      croppedFileList: croppedFileList ?? this.croppedFileList,
    );
  }
}

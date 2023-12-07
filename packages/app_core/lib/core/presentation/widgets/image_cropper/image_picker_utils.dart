import 'dart:io';

import 'package:app_core/app/enum.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_core/app/helpers/permission/permission_helper.dart';
import 'package:app_core/app/helpers/permission/permission_manager.dart';

class ImagePickerUtils {
  factory ImagePickerUtils() {
    return _singleton;
  }

  ImagePickerUtils._internal();

  static final ImagePickerUtils _singleton = ImagePickerUtils._internal();
  static CroppedFile? croppedFile;
  static final _permissionManager = PermissionManager();
  static late BuildContext? _buildContext;

  static void show({
    required BuildContext context,
    required VoidCallback onGalleryClicked,
    required VoidCallback onCameraClicked,
  }) {
    _buildContext = context;
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext buildContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  final result = await _requestPermission(MediaPermission.photo);
                  if (result.result == PermissionResult.granted) {
                    onGalleryClicked();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  final result = await _requestPermission(MediaPermission.camera);
                  if (result.result == PermissionResult.granted) {
                    onCameraClicked();
                  } else {}
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<XFile>? imageFileList = [];

  ///Request permission
  static Future<List<XFile>?> selectImages(BuildContext context) async {
    _buildContext = context;

    ///Select multiple Images
    final result = await _requestPermission(MediaPermission.photo);
    if (result.result == PermissionResult.granted) {
      List<XFile>? selectedImages;
      await ImagePicker().pickMultiImage().then((pickedFile) {
        if (pickedFile.isNotEmpty) {
          selectedImages = pickedFile;
        }
      });
      return selectedImages;
    }
    return null;
  }

  ///Crop Image
  static Future<String?> cropImage(XFile? pickedFile, BuildContext context) async {
    CroppedFile? croppedFile;
    if (pickedFile != null) {
      const ratio = CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      );
      await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: ratio,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: context.colorScheme.foreground,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      ).then((value) {
        if (value != null) {
          croppedFile = value;
          //selectedPhotoStream.add(croppedFile);
          return croppedFile?.path;
        }
      });
      return croppedFile?.path;
    }
    return null;
  }

  ///Select single Image
  static Future<String?> pickImage({
    required BuildContext context,
    bool useCamera = false,
    bool crop = true,
    CropAspectRatio ratio = const CropAspectRatio(
      ratioX: 1,
      ratioY: 1,
    ),
  }) async {
    croppedFile = null;
    await ImagePicker()
        .pickImage(source: useCamera ? ImageSource.camera : ImageSource.gallery, imageQuality: 60)
        .then((pickedFile) async {
      if (pickedFile == null || !File(pickedFile.path).existsSync()) {
        return Stream.error(Exception('No image picked!'));
      }
      if (crop) {
        await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          compressFormat: ImageCompressFormat.png,
          aspectRatio: ratio,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: context.colorScheme.foreground,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ],
        ).then((value) {
          if (value != null) {
            croppedFile = value;
            return croppedFile?.path;
          }
        });
      } else {
        croppedFile = CroppedFile(pickedFile.path);
      }
    });
    return croppedFile?.path;
  }

  static Future<PermissionResultData> _requestPermission(MediaPermission permission) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (permission == MediaPermission.photo) {
      ///Request permission for android 12 or lower
      if (androidInfo.version.sdkInt <= 32) {
        return _permissionManager.requestPermission(MediaPermission.storage, _buildContext!);
      } else {
        ///Request permission for android 13+
        return _permissionManager.requestPermission(MediaPermission.photo, _buildContext!);
      }
    } else {
      return _permissionManager.requestPermission(permission, _buildContext!);
    }
  }
}

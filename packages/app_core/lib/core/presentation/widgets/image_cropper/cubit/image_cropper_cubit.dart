// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: join_return_with_assignment

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:app_core/core/presentation/widgets/image_cropper/cubit/image_cropper_state.dart';
import 'package:app_core/core/presentation/widgets/image_cropper/image_picker_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageCropperCubit extends Cubit<CustomImageCropperState> {
  CustomImageCropperCubit() : super(CustomImageCropperState());

  void initialize(List<XFile>? imageFileList) {
    emit(state.copyWith(
        imageFileList: imageFileList, selectedImage: imageFileList?[0]));
  }

  void selectImage(int index) {
    emit(state.copyWith(
        selectedImage: state.imageFileList?[index], selectedIndex: index));
  }

  Future<void> cropImage(BuildContext context) async {
    await ImagePickerUtils.cropImage(state.selectedImage, context)
        .then((value) {
      if (value != null) {
        final updatedList = List<XFile>.from(state.imageFileList ?? [])
          ..removeAt(state.selectedIndex)
          ..insert(state.selectedIndex, XFile(value));
        emit(state.copyWith(
            imageFileList: updatedList, selectedImage: XFile(value)));
      }
    });
  }

  void saveImages(BuildContext context) {
    final croppedList = state.imageFileList
        ?.map((element) => CroppedFile(element.path))
        .toList();
    emit(state.copyWith(croppedFileList: croppedList));
    context.popRoute(croppedList);
  }
}

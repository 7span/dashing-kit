// // ignore_for_file: constant_identifier_names
//
// import 'dart:io';
//
// import 'package:api_client/api_client.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:media_service/src/cubit/media_cubit.dart';
//
// class MediaService {
//   MediaService._internal();
//
//   static final instance = MediaService._internal();
//
//   /// Pick Images from Camera or Gallery
//   Future<File?> pickImage({
//     ImageSource imageSource = ImageSource.camera,
//   }) async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: imageSource,
//       imageQuality: 50,
//     );
//     if (pickedFile != null) {
//       return File(pickedFile.path);
//     } else {
//       return null;
//     }
//   }
//
//   /// Pick File from Device
//   Future<List<File>?> pickMedia({
//     bool allowMultiple = false,
//     List<String>? allowedExtensions,
//   }) async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowMultiple: allowMultiple,
//       compressionQuality: 50,
//       allowedExtensions: allowedExtensions ?? ['jpg', 'png', 'pdf'],
//     );
//     if (result == null) {
//       return null;
//     }
//     final pickedFiles = <File>[];
//     for (final file in result.xFiles) {
//       final sizeInBytes = File(file.path).lengthSync();
//       final sizeInMb = sizeInBytes / (1024 * 1024);
//       if (sizeInMb < 5) {
//         pickedFiles.add(File(file.path));
//       }
//     }
//     return pickedFiles;
//   }
//
//   Future<int?> uploadMedia({
//     required ApiClient client,
//     required BuildContext context,
//     required MediaSource mediaSource,
//   }) async {
//     final mediaId = await context.read<MediaCubit>().uploadMedia(
//       apiClient: client,
//       mediaSource: mediaSource,
//     );
//     return mediaId;
//   }
//
//   Future<int?> uploadMediaWithId({
//     required ApiClient client,
//     required BuildContext context,
//     required MediaSource mediaSource,
//     required File file,
//   }) async {
//     final mediaId = await context
//         .read<MediaCubit>()
//         .uploadMediaWithId(
//           apiClient: client,
//           mediaSource: mediaSource,
//           file: file,
//         );
//     return mediaId;
//   }
//
//   Future<void> deleteMedia({
//     required ApiClient client,
//     required BuildContext context,
//     required List<int> mediaIds,
//   }) => context.read<MediaCubit>().deleteMedia(client, mediaIds);
// }
//
// extension MediaHelper on File {
//   String get getSizeInMb {
//     final sizeInBytes = lengthSync();
//     final sizeInMb = sizeInBytes / (1024 * 1024);
//     return sizeInMb.toString();
//   }
//
//   String get fileName => path.split('.').last;
// }
//
// enum MediaSource {
//   reply,
//   product,
//   biz_cover,
//   digital_product,
//   biz_profile_picture,
//   page_cover,
//   campaign_mobile,
//   store_banner,
//   campaign_broadcast,
//   product_category,
//   contact_profile_picture,
// }

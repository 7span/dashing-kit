import 'package:auto_route/auto_route.dart';
import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/presentation/widgets/image_cropper/image_picker_utils.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ImageCropperTest extends StatefulWidget {
  const ImageCropperTest({super.key});

  @override
  State<ImageCropperTest> createState() => _ImageCropperTestState();
}

class _ImageCropperTestState extends State<ImageCropperTest> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await ImagePickerUtils.selectImages(context).then((data) async {
          if (data != null) {
            // ignore: unused_local_variable
            final result = context.pushRoute(CustomImageCropperRoute(imageFileList: data));

            ///in result get cropped image files
          }
        });
      },
      icon: Icon(
        Icons.add_photo_alternate_outlined,
        color: context.colorScheme.foreground,
      ),
    );
  }
}

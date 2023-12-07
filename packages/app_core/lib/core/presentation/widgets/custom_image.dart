import 'package:app_core/gen/assets.gen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///How to use this widget
///Example
/*
CustomImageWidget(
    imageUrl: YourNetworkUrl ?? '',
    height: 32,
    width: 32,
 );
*/

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    required this.imageUrl,
    super.key,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.height = 72,
    this.width = 72,
    this.color,
  });
  final String imageUrl;
  final BorderRadiusGeometry borderRadius;
  final double height;
  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final lastValue =
        imageUrl.isNotEmpty ? imageUrl.split('/').last.split('?').first : 0;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: borderRadius),
      child: imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              key: Key(lastValue.toString()),
              cacheKey: lastValue.toString(),
              placeholder: (context, value) {
                return noImage(height, width, color);
              },
              errorWidget: (context, error, value) {
                return noImage(height, width, color);
              },
            )
          : noImage(height, width, color),
    );
  }
}

Widget noImage(double height, double width, Color? color) {
  return SvgPicture.asset(
    Assets.images.noImage.path,
    height: height,
    width: width,
    fit: BoxFit.cover,
  );
}

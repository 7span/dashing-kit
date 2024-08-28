// ignore_for_file: unused_element

import 'dart:io';

import 'package:app_ui/src/theme/utils/utils.dart';
import 'package:app_ui/src/widgets/atoms/atoms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

/// We need to show different placeholder images when the data type is PDF or Video
/// That's why we're getting the Media Type from the constructor and checking based on it
enum AppMediaType { image, doc, video }

enum AppImageSource { network, memory, blank }

class AppNetworkImage extends StatefulWidget {
  const AppNetworkImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.blurHashURL,
    this.initials,
    this.shape = BoxShape.rectangle,
    this.rawMediaType = 'image/jpeg',
    this.imageHeight = 68,
    this.imageWidth = 68,
    this.placeHolderBackgroundColor,
    this.imageSource = AppImageSource.network,
    this.borderRadius = AppBorderRadius.xsmall4,
  });

  /// Network Image URL
  final String? imageUrl;

  /// Memory Image Path
  final File? imageFile;

  final String? rawMediaType;

  /// Blur Image URL
  final String? blurHashURL;

  /// Initials in case the image is not present
  final String? initials;

  /// Image Shape
  final BoxShape shape;

  final double imageHeight;
  final double imageWidth;

  final Color? placeHolderBackgroundColor;

  final AppImageSource imageSource;
  final double borderRadius;

  @override
  State<AppNetworkImage> createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends State<AppNetworkImage> {
  late AppMediaType mediaType;

  @override
  void initState() {
    super.initState();
    setMediaType();
  }

  void setMediaType() {
    switch (widget.rawMediaType) {
      case 'image/jpeg':
        mediaType = AppMediaType.image;
      case 'application/pdf':
        mediaType = AppMediaType.doc;
      default:
        mediaType = AppMediaType.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.shape == BoxShape.circle
          ? BorderRadius.circular(1000)
          : BorderRadius.circular(widget.borderRadius),

      /// Here we've set height width to 68 as per Figma's design
      child: OctoImage.fromSet(
        width: widget.imageWidth,
        height: widget.imageHeight,
        fit: BoxFit.cover,
        image: widget.imageSource == AppImageSource.network
            ? CachedNetworkImageProvider(widget.imageUrl ?? '')
            : MemoryImage(widget.imageFile!.readAsBytesSync()),
        octoSet: blurHash(
          widget.blurHashURL,
          widget.initials,
          mediaType,
          placeHolderBackgroundColor: widget.placeHolderBackgroundColor,
        ),
      ),
    );
  }
}

/// Simple set to show [OctoPlaceholder.circularProgressIndicator] as
/// placeholder and [OctoError.icon] as error.
OctoSet blurHash(
  String? hash,
  String? initials,
  AppMediaType mediaType, {
  BoxFit? fit,
  Text? errorMessage,
  Color? placeHolderBackgroundColor,
}) {
  return OctoSet(
    placeholderBuilder: blurHashPlaceholderBuilder(hash, initials, fit: fit),
    errorBuilder: blurHashErrorBuilder(
      fit: fit,
      initials: initials,
      mediaType: mediaType,
      placeHolderBackgroundColor: placeHolderBackgroundColor,
    ),
  );
}

/// If the user has not provided the [hash], then show the normal placeholder instead of Blurred
/// Preview of the Image
OctoPlaceholderBuilder blurHashPlaceholderBuilder(String? hash, String? initials, {BoxFit? fit}) {
  return (context) => hash != null ? BlurHash(hash: hash) : _PlaceHolderWidget(initials: initials);
}

/// The error builder is same as the Placeholder Builder
OctoErrorBuilder blurHashErrorBuilder({
  required AppMediaType mediaType,
  BoxFit? fit,
  String? initials,
  Text? message,
  IconData? icon,
  Color? iconColor,
  double? iconSize,
  Color? placeHolderBackgroundColor,
}) {
  return OctoError.placeholderWithErrorIcon(
    (context) => _PlaceHolderWidget(
      initials: initials,
      mediaType: mediaType,
      placeHolderBackgroundColor: placeHolderBackgroundColor,
    ),
    iconColor: Colors.transparent,
  );
}

class _PlaceHolderWidget extends StatelessWidget {
  const _PlaceHolderWidget({
    super.key,
    this.initials,
    this.mediaType,
    this.placeHolderBackgroundColor,
  });

  final String? initials;
  final AppMediaType? mediaType;
  final Color? placeHolderBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: placeHolderBackgroundColor ?? context.colorScheme.primary500,
        borderRadius: BorderRadius.circular(AppBorderRadius.xsmall4),
      ),
      child: mediaType != null && mediaType == AppMediaType.doc
          ? const AppText.base(text: 'PDF')
          : AppText.base(text: initials?.toUpperCase() ?? 'N/A'),
    );
  }
}

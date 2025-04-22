import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart'
    as widgetbook;

@widgetbook.UseCase(
  name: 'All-in-One Showcase with Knobs (using list)',
  type: AppNetworkImage,
)
Widget allInOneShowcaseWithKnobs(BuildContext context) {
  final imageUrl = context.knobs.string(
    label: 'Image URL',
    initialValue: 'https://picsum.photos/200',
  );

  final blurHash = context.knobs.string(
    label: 'BlurHash',
    initialValue: 'L6PZfSi_.AyE_3t7t7R**0o#DgR4',
  );

  final initials = context.knobs.string(
    label: 'Initials',
    initialValue: 'AB',
  );

  final mediaType = context.knobs.list<String?>(
    label: 'Media Type',
    options: ['image/jpeg', 'application/pdf', 'video/mp4', null],
    labelBuilder: (value) => value ?? 'null',
    initialOption: 'image/jpeg',
  );

  final shape = context.knobs.list<BoxShape>(
    label: 'Shape',
    options: [BoxShape.rectangle, BoxShape.circle],
    labelBuilder:
        (shape) => shape == BoxShape.circle ? 'Circle' : 'Rectangle',
    initialOption: BoxShape.rectangle,
  );

  final imageHeight =
      context.knobs.double
          .slider(
            label: 'Height',
            initialValue: 100,
            min: 32,
            max: 300,
          )
          .toDouble();

  final imageWidth =
      context.knobs.double
          .slider(
            label: 'Width',
            initialValue: 100,
            min: 32,
            max: 300,
          )
          .toDouble();

  final borderRadius =
      context.knobs.double
          .slider(
            label: 'Border Radius',
            initialValue: 8,
            min: 0,
            max: 50,
          )
          .toDouble();

  final backgroundColor = context.knobs.list<Color>(
    label: 'Placeholder Color',
    options: [
      Colors.grey,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.transparent,
    ],
    labelBuilder: (color) {
      if (color == Colors.grey) return 'Grey';
      if (color == Colors.red) return 'Red';
      if (color == Colors.blue) return 'Blue';
      if (color == Colors.green) return 'Green';
      return 'Transparent';
    },
    initialOption: Colors.grey,
  );

  return AppScaffold(
    backgroundColor: context.colorScheme.grey300,

    body: Center(
      child: AppNetworkImage(
        imageUrl: imageUrl,
        blurHashURL: blurHash,
        rawMediaType: mediaType,
        shape: shape,
        initials: initials,
        borderRadius: borderRadius,
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        placeHolderBackgroundColor: backgroundColor,
      ),
    ),
  );
}

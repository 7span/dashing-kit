import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AppTypographyData extends Equatable {
  const AppTypographyData({
    required this.paragraph,
    required this.title,
  });

  factory AppTypographyData.regular() => const AppTypographyData(
        title: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        paragraph: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );

  final TextStyle title;
  final TextStyle paragraph;

  @override
  List<Object?> get props => [title, paragraph];
}

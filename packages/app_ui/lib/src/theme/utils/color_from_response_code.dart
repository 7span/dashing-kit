import 'package:flutter/material.dart';

Color getStatusColorFromCode(String? code) {
  switch (code) {
    case 'grey':
      return const Color(0xff607d8b);
    case 'red':
      return const Color(0xfff44336);
    case 'pink':
      return const Color(0xffe91e63);
    case 'purple':
      return const Color(0xff9c27b0);
    case 'indigo':
      return const Color(0xff3f51b5);
    case 'blue':
      return const Color(0xff2196f3);
    case 'cyan':
      return const Color(0xff00bcd4);
    case 'green':
      return const Color(0xff4caf50);
    case 'lime':
      return const Color(0xffcddc39);
    case 'amber':
      return const Color(0xffffc107);
    case 'orange':
      return const Color(0xffff9800);
    case 'brown':
      return const Color(0xff795548);
    case 'gray':
      return const Color(0xff808080);
    case 'light-grey':
      return const Color(0xffD3D3D3);
  }

  return Colors.transparent;
}

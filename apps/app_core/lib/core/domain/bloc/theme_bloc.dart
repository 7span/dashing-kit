import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' show Brightness, MaterialApp;
import 'package:flutter_bloc/flutter_bloc.dart';

/// This class is used for setting the theme of your app from any screen. This BLoC
/// will be put on top of [MaterialApp], so that anyone can change the theme for it.
///
/// It also comes with a set of extension that anyone can use.
class ThemeBloc extends Cubit<AppThemeColorMode> {
  ThemeBloc() : super(AppThemeColorMode.light);

  void switchTheme(Brightness brightness) {
    emit(brightness == Brightness.dark ? AppThemeColorMode.light : AppThemeColorMode.dark);
  }
}

import 'package:app_core/core/presentation/screens/error_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/domain/bloc/theme_bloc.dart';

/// This class contains the [MaterialApp] widget. In this class, we're
/// doing the following things:
///
/// * Initialization of [AppRouter]
/// * Setup of [EasyLocalization] for the localization
/// * Setup of [ErrorWidget.builder] in case of any error in debug and release mode
/// * Setting up [Theme] along with [ThemeBloc] so that the user can change
/// the theme from anywhere in the App.
class App extends StatelessWidget {
  App({super.key});

  /// Here we're initializing the theme bloc so that we can change the theme anywhere from the App
  List<BlocProvider<dynamic>> get providers => <BlocProvider<dynamic>>[
        BlocProvider<ThemeBloc>(
          create: (BuildContext context) => ThemeBloc(),
        ),
      ];

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    /// Refer this link for the localization package:
    /// https://pub.dev/packages/easy_localization
    return EasyLocalization(
      supportedLocales: const [
        Locale('en'),
      ],
      path: 'assets/l10n',
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: providers,
        child: BlocBuilder<ThemeBloc, AppThemeColorMode>(
          builder: (BuildContext context, AppThemeColorMode themeMode) {
            return AppResponsiveTheme(
              colorMode: themeMode,
              child: MaterialApp.router(
                routerConfig: _appRouter.config(),
                title: 'Fitness App',
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                builder: (BuildContext context, Widget? widget) {
                  ErrorWidget.builder = (details) {
                    return ErrorScreen(details: details);
                  };
                  return widget!;
                },
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        ),
      ),
    );
  }
}

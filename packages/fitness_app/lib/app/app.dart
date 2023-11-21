import 'package:fitness_app/core/presentation/screens/error_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitness_app/app/routes/app_router.dart';
import 'package:fitness_app/app/theme/app_theme.dart';
import 'package:fitness_app/core/domain/bloc/theme_bloc.dart';

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
        Locale('en', 'US'),
        Locale('en', 'IN'),
      ],
      path: 'assets/l10n',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiBlocProvider(
        providers: providers,
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (BuildContext context, ThemeMode themeMode) {
            return MaterialApp.router(
              routerConfig: _appRouter.config(),
              title: 'Boilerplate code',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
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
            );
          },
        ),
      ),
    );
  }
}

import 'package:app_core/core/data/services/network_helper.service.dart';
import 'package:app_core/core/presentation/screens/error_screen.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/domain/bloc/theme_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// This class contains the [MaterialApp] widget. In this class, we're
/// doing the following things:
///
/// * Initialization of [AppRouter]
// ignore: comment_references
/// * Setup of [Slang] for the localization
/// * Setup of [ErrorWidget.builder] in case of any error in debug and release mode
/// * Setting up [Theme] along with [ThemeBloc] so that the user can change
/// the theme from anywhere in the App.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
    /// https://pub.dev/packages/slang
    return TranslationProvider(
      child: MultiBlocProvider(
        providers: providers,
        child: BlocBuilder<ThemeBloc, AppThemeColorMode>(
          builder: (BuildContext context, AppThemeColorMode themeMode) {
            return AppResponsiveTheme(
              colorMode: themeMode,
              child: MaterialApp.router(
                routerConfig: _appRouter.config(),
                title: 'CRM App',
                locale: TranslationProvider.of(context).flutterLocale,
                supportedLocales: AppLocaleUtils.supportedLocales,
                localizationsDelegates: GlobalMaterialLocalizations.delegates,
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

  @override
  void dispose() {
    NetWorkInfoService.instance.dispose();
    super.dispose();
  }
}

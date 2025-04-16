// ignore_for_file: require_trailing_commas
import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/app_config.dart';
import 'package:app_core/app/enum.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/app/observers/app_bloc_observer.dart';
import 'package:app_core/core/data/services/firebase_crashlytics_service.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_core/core/data/services/logout_service.dart';
import 'package:app_core/core/data/services/network_helper.service.dart';
import 'package:app_core/firebase_options.dart' as firebase_prod;
import 'package:app_core/firebase_options_development.dart'
as firebase_dev;
import 'package:app_core/firebase_options_staging.dart'
as firebase_staging;
import 'package:app_notification_service/notification_service.dart';
import 'package:app_subscription/app_subscription_api.dart';
import 'package:app_translations/app_translations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// This function is one of the core function that should be run before we even
/// reach to the [MaterialApp] This function initializes the following:
///
/// * [AppBlocObserver] for printing the events and state logs
/// * [HiveService] for getting and setting the Userdata
Future<void> bootstrap(FutureOr<Widget> Function() builder,
    Env env,) async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialzing realtime network info service
  NetWorkInfoService.instance.init();
  initializeSingletons();
  AppConfig.setEnvConfig(env);

  await Future.wait([
    LocaleSettings.useDeviceLocale(),
    getIt<IHiveService>().init(),

    /// Initialize firebase
    Firebase.initializeApp(
      name: 'Boilerplate-v2',
      options: switch (env) {
        Env.development =>
        firebase_dev.DefaultFirebaseOptions.currentPlatform,
        Env.staging =>
        firebase_staging.DefaultFirebaseOptions.currentPlatform,
        Env.production =>
        firebase_prod.DefaultFirebaseOptions.currentPlatform,
      },
    ),
    baseApiClient.init(
      baseURL: AppConfig.baseApiUrl,
      isApiCacheEnabled: false,
    ),
    userApiClient.init(
      baseURL: AppConfig.userApiUrl,
      isApiCacheEnabled: false,
    ),
    getIt<NotificationServiceInterface>().init(switch (env) {
      Env.development => AppConfig.oneSignalAppId,
      Env.staging => AppConfig.oneSignalAppId,
      Env.production => AppConfig.oneSignalAppId,
    }, shouldLog: env != Env.production),
  ]);

  // enableLeakTracking();

  Bloc.observer = getIt<AppBlocObserver>();

  // MemoryAllocations.instance.addListener((ObjectEvent event) {
  //   dispatchObjectEvent(event.toMap());
  // });=

  /// Initialize firebase crashlytics
  FirebaseCrashlyticsService.init();

  runApp(await builder());
}

void initializeSingletons() {
  getIt
    ..registerSingleton<Logger>(
      Logger(
        filter: ProductionFilter(),
        printer: PrettyPrinter(),
        output: ConsoleOutput(),
      ),
    )
    ..registerLazySingleton(RestApiClient.new,
        instanceName: 'user')..registerLazySingleton(
      RestApiClient.new, instanceName: 'base')
    ..registerSingleton(AppBlocObserver())..registerSingleton<
      IHiveService>(const HiveService())..registerSingleton(
      CustomInAppPurchase())
    ..registerLazySingleton<LogoutService>(LogoutService.new)
    ..registerSingleton<NotificationServiceInterface>(
      OneSignalService(),
    );
}

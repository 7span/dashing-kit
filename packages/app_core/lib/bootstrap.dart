import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/app_config.dart';
import 'package:app_core/app/enum.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/app/observers/app_bloc_observer.dart';
import 'package:app_core/core/data/services/firebase_crashlytics_service.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_core/core/data/services/network_helper.service.dart';
import 'package:app_translations/app_translations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:app_core/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

/// This function is one of the core function that should be run before we even
/// reach to the [MaterialApp] This function initializes the following:
///
/// * [HydratedBloc] for caching the state
/// * [AppBlocObserver] for printing the events and state logs
/// * [HiveService] for getting and setting the Userdata
Future<void> bootstrap(FutureOr<Widget> Function() builder, Env env) async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialization of Firebase
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ///  Initializing localizations
  LocaleSettings.useDeviceLocale();

  /// Initialzing realtime network info service
  NetWorkInfoService.instance.init();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );

  //! Should be removed in future
  if (NetWorkInfoService.instance.connectionStatus == ConnectionStatus.online) {
    await HydratedBloc.storage.clear();
  }
  // enableLeakTracking();
  initializeSingletons();
  AppConfig.setEnvConfig(env);

  await Future.wait([
    getIt<IHiveService>().init(),

    ///setting up the GraphQL configurations
    openApiClient.init(isApiCacheEnabled: false, baseURL: AppConfig.baseApiUrl),
    closeApiClient.init(isApiCacheEnabled: false, baseURL: AppConfig.baseApiUrl),
  ]);

  /// If the user has already logged in, then set the authorization token for the Closed API endpoint
  getIt<IHiveService>().getAccessToken().fold(
        () => null,
        (token) => closeApiClient.setAuthorizationToken(token, AppConfig.baseApiUrl),
      );

  Bloc.observer = getIt<AppBlocObserver>();

  // MemoryAllocations.instance.addListener((ObjectEvent event) {
  //   dispatchObjectEvent(event.toMap());
  // });

  /// Initialize firebase
  await Firebase.initializeApp(
    name: 'BoilerplateV2',
    options: FirebaseOptions(
      apiKey: AppConfig.firebaseAPIKey,
      appId: AppConfig.firebaseAppId,
      messagingSenderId: AppConfig.firebaseMessagingSenderId,
      projectId: AppConfig.firebaseProjectId,
      iosBundleId: AppConfig.iosBundleId,
    ),
  );

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
    ..registerLazySingleton(ApiClient.new, instanceName: 'open')
    ..registerLazySingleton(ApiClient.new, instanceName: 'close')
    ..registerSingleton(AppBlocObserver())
    ..registerSingleton<IHiveService>(const HiveService());
}

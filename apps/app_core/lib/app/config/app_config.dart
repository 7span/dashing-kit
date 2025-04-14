// ignore_for_file: non_constant_identifier_names

import 'package:app_core/app/enum.dart';
import 'package:envied/envied.dart';
import 'package:fpdart/fpdart.dart';

part 'app_config.g.dart';

/// This class is used for initializing the environment config as well as getting and setting the
/// environment variables such as [environmentName], [baseApiUrl] etc.
///
/// Here we're using [Envied] package to set the environment variables because this
/// package offers encryption along with end to end security.
/// [Doc Link](https://cavin-7span.github.io/Dash-Docs/docs/tutorial-basics/configuring-environment-variables)
final class AppConfig {
  const AppConfig();

  static String get environmentName => _getEnvironmentName;

  static String get baseApiUrl => _getBaseApiUrl;
  static String get oneSignalAppId => _getOneSignalAppId;
  static String get userApiUrl => _getUserApiUrl;

  static String get iosAppStoreId => _getIosAppStoreId;
  static Env environment = Env.development;

  /// This variable is used to ensure that a user can setup the config only one time.
  static bool _isSetupComplete = false;

  static Unit setEnvConfig(Env env) {
    if (!_isSetupComplete) {
      environment = env;
      _isSetupComplete = true;
    }
    return unit;
  }

  static String get _getEnvironmentName {
    switch (environment) {
      case Env.development:
        return EnvDev.ENV_NAME;
      case Env.production:
        return EnvProd.ENV_NAME;
      case Env.staging:
        return EnvStaging.ENV_NAME;
    }
  }

  static String get _getUserApiUrl {
    switch (environment) {
      case Env.development:
        return EnvDev.USER_API_URL;
      case Env.production:
        return EnvProd.USER_API_URL;
      case Env.staging:
        return EnvStaging.USER_API_URL;
    }
  }

  static String get _getIosAppStoreId {
    switch (environment) {
      case Env.development:
        return EnvDev.IOS_APP_STORE_ID;
      case Env.production:
        return EnvProd.IOS_APP_STORE_ID;
      case Env.staging:
        return EnvStaging.IOS_APP_STORE_ID;
    }
  }

  static String get _getBaseApiUrl {
    switch (environment) {
      case Env.development:
        return EnvDev.BASE_API_URL;
      case Env.production:
        return EnvProd.BASE_API_URL;
      case Env.staging:
        return EnvStaging.BASE_API_URL;
    }
  }

  static String get _getOneSignalAppId {
    switch (environment) {
      case Env.development:
        return EnvDev.ONESIGNAL_APP_ID;
      case Env.production:
        return EnvProd.ONESIGNAL_APP_ID;
      case Env.staging:
        return EnvStaging.ONESIGNAL_APP_ID;
    }
  }
}

@Envied(path: '.env.dev')
abstract class EnvDev {
  @EnviedField(varName: 'ONESIGNAL_APP_ID', obfuscate: true)
  static final String ONESIGNAL_APP_ID = _EnvDev.ONESIGNAL_APP_ID;

  @EnviedField(varName: 'USER_API_URL', obfuscate: true)
  static final String USER_API_URL = _EnvDev.USER_API_URL;

  @EnviedField(varName: 'BASE_API_URL', obfuscate: true)
  static final String BASE_API_URL = _EnvDev.BASE_API_URL;

  @EnviedField(varName: 'IOS_APP_STORE_ID', obfuscate: true)
  static final String IOS_APP_STORE_ID = _EnvDev.IOS_APP_STORE_ID;

  @EnviedField(varName: 'ENV', obfuscate: true)
  static final String ENV_NAME = _EnvDev.ENV_NAME;
}

@Envied(path: '.env.staging')
abstract class EnvStaging {

  @EnviedField(varName: 'ONESIGNAL_APP_ID', obfuscate: true)
  static final String ONESIGNAL_APP_ID = _EnvDev.ONESIGNAL_APP_ID;

  @EnviedField(varName: 'USER_API_URL', obfuscate: true)
  static final String USER_API_URL = _EnvStaging.USER_API_URL;

  @EnviedField(varName: 'BASE_API_URL', obfuscate: true)
  static final String BASE_API_URL = _EnvStaging.BASE_API_URL;

  @EnviedField(varName: 'IOS_APP_STORE_ID', obfuscate: true)
  static final String IOS_APP_STORE_ID = _EnvStaging.IOS_APP_STORE_ID;

  @EnviedField(varName: 'ENV', obfuscate: true)
  static final String ENV_NAME = _EnvStaging.ENV_NAME;
}

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'ONESIGNAL_APP_ID', obfuscate: true)
  static final String ONESIGNAL_APP_ID = _EnvDev.ONESIGNAL_APP_ID;

  @EnviedField(varName: 'USER_API_URL', obfuscate: true)
  static final String USER_API_URL = _EnvProd.USER_API_URL;

  @EnviedField(varName: 'BASE_API_URL', obfuscate: true)
  static final String BASE_API_URL = _EnvProd.BASE_API_URL;

  @EnviedField(varName: 'IOS_APP_STORE_ID', obfuscate: true)
  static final String IOS_APP_STORE_ID = _EnvProd.IOS_APP_STORE_ID;

  @EnviedField(varName: 'ENV', obfuscate: true)
  static final String ENV_NAME = _EnvProd.ENV_NAME;
}

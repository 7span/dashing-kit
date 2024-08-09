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

  static String get _getBaseApiUrl {
    switch (environment) {
      case Env.development:
        return EnvDev.ENV_BASE_API_URL;
      case Env.production:
        return EnvProd.ENV_BASE_API_URL;
      case Env.staging:
        return EnvStaging.ENV_BASE_API_URL;
    }
  }
}

@Envied(path: '.env.dev')
abstract class EnvDev {
  @EnviedField(varName: 'BASE_API_URL', obfuscate: true)
  static final String ENV_BASE_API_URL = _EnvDev.ENV_BASE_API_URL;
  @EnviedField(varName: 'ENV', obfuscate: true)
  static final String ENV_NAME = _EnvDev.ENV_NAME;
}

@Envied(path: '.env.staging')
abstract class EnvStaging {
  @EnviedField(varName: 'BASE_API_URL', obfuscate: true)
  static final String ENV_BASE_API_URL = _EnvStaging.ENV_BASE_API_URL;
  @EnviedField(varName: 'ENV', obfuscate: true)
  static final String ENV_NAME = _EnvStaging.ENV_NAME;
}

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'BASE_API_URL', obfuscate: true)
  static final String ENV_BASE_API_URL = _EnvProd.ENV_BASE_API_URL;
  @EnviedField(varName: 'ENV', obfuscate: true)
  static final String ENV_NAME = _EnvProd.ENV_NAME;
}

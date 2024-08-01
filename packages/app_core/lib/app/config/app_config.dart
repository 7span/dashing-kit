// ignore_for_file: non_constant_identifier_names

import 'dart:io';

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

  static String get firebaseAPIKey => _getFirebaseAPIKey;

  static String get firebaseAppId => _getFirebaseAppId;

  static String get firebaseMessagingSenderId => _getFirebaseMessagingSenderId;

  static String get firebaseProjectId => _getFirebaseProjectId;

  static String get iosBundleId => _getIOSBundleID;

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

  static String get _getFirebaseAPIKey {
    switch (environment) {
      case Env.development:
        return Platform.isIOS ? EnvDev.FIREBASE_APIKEY_IOS : EnvDev.FIREBASE_APIKEY_ANDROID;
      case Env.staging:
        return Platform.isIOS ? EnvStaging.FIREBASE_APIKEY_IOS : EnvStaging.FIREBASE_APIKEY_ANDROID;
      case Env.production:
        return Platform.isIOS ? EnvProd.FIREBASE_APIKEY_IOS : EnvProd.FIREBASE_APIKEY_ANDROID;
    }
  }

  static String get _getFirebaseAppId {
    switch (environment) {
      case Env.development:
        return Platform.isIOS ? EnvDev.FIREBASE_APP_ID_IOS : EnvDev.FIREBASE_APP_ID_ANDROID;
      case Env.staging:
        return Platform.isIOS ? EnvStaging.FIREBASE_APP_ID_IOS : EnvStaging.FIREBASE_APP_ID_ANDROID;
      case Env.production:
        return Platform.isIOS ? EnvProd.FIREBASE_APP_ID_IOS : EnvProd.FIREBASE_APP_ID_ANDROID;
    }
  }

  static String get _getFirebaseMessagingSenderId {
    switch (environment) {
      case Env.development:
        return EnvDev.FIREBASE_MESSAGING_SENDER_ID;
      case Env.staging:
        return EnvStaging.FIREBASE_MESSAGING_SENDER_ID;
      case Env.production:
        return EnvProd.FIREBASE_MESSAGING_SENDER_ID;
    }
  }

  static String get _getFirebaseProjectId {
    switch (environment) {
      case Env.development:
        return EnvDev.FIREBASE_PROJECT_ID;
      case Env.staging:
        return EnvStaging.FIREBASE_PROJECT_ID;
      case Env.production:
        return EnvProd.FIREBASE_PROJECT_ID;
    }
  }

  static String get _getIOSBundleID {
    switch (environment) {
      case Env.development:
        return EnvDev.IOS_BUNDLE_ID;
      case Env.staging:
        return EnvStaging.IOS_BUNDLE_ID;
      case Env.production:
        return EnvProd.IOS_BUNDLE_ID;
    }
  }
}

@Envied(path: '.env.dev')
abstract class EnvDev {
  @EnviedField(varName: 'BASE_API_URL', obfuscate: true)
  static final String ENV_BASE_API_URL = _EnvDev.ENV_BASE_API_URL;
  @EnviedField(varName: 'ENV', obfuscate: true)
  static final String ENV_NAME = _EnvDev.ENV_NAME;
  @EnviedField(varName: 'FIREBASE_APIKEY_ANDROID', obfuscate: true)
  static final String FIREBASE_APIKEY_ANDROID = _EnvDev.FIREBASE_APIKEY_ANDROID;
  @EnviedField(varName: 'FIREBASE_APIKEY_IOS', obfuscate: true)
  static final String FIREBASE_APIKEY_IOS = _EnvDev.FIREBASE_APIKEY_IOS;
  @EnviedField(varName: 'FIREBASE_APP_ID_ANDROID', obfuscate: true)
  static final String FIREBASE_APP_ID_ANDROID = _EnvDev.FIREBASE_APP_ID_ANDROID;
  @EnviedField(varName: 'FIREBASE_APP_ID_IOS', obfuscate: true)
  static final String FIREBASE_APP_ID_IOS = _EnvDev.FIREBASE_APP_ID_IOS;
  @EnviedField(varName: 'FIREBASE_MESSAGING_SENDER_ID', obfuscate: true)
  static final String FIREBASE_MESSAGING_SENDER_ID = _EnvDev.FIREBASE_MESSAGING_SENDER_ID;
  @EnviedField(varName: 'FIREBASE_PROJECT_ID', obfuscate: true)
  static final String FIREBASE_PROJECT_ID = _EnvDev.FIREBASE_PROJECT_ID;
  @EnviedField(varName: 'IOS_BUNDLE_ID', obfuscate: true)
  static final String IOS_BUNDLE_ID = _EnvDev.IOS_BUNDLE_ID;
}

///TODO:Change env file cuurently staging pointing to dev
@Envied(path: '.env.dev')
abstract class EnvStaging {
  @EnviedField(varName: 'BASE_API_URL', obfuscate: true)
  static final String ENV_BASE_API_URL = _EnvStaging.ENV_BASE_API_URL;
  @EnviedField(varName: 'ENV', obfuscate: true)
  static final String ENV_NAME = _EnvStaging.ENV_NAME;
  @EnviedField(varName: 'FIREBASE_APIKEY_ANDROID', obfuscate: true)
  static final String FIREBASE_APIKEY_ANDROID = _EnvStaging.FIREBASE_APIKEY_ANDROID;
  @EnviedField(varName: 'FIREBASE_APIKEY_IOS', obfuscate: true)
  static final String FIREBASE_APIKEY_IOS = _EnvStaging.FIREBASE_APIKEY_IOS;
  @EnviedField(varName: 'FIREBASE_APP_ID_ANDROID', obfuscate: true)
  static final String FIREBASE_APP_ID_ANDROID = _EnvStaging.FIREBASE_APP_ID_ANDROID;
  @EnviedField(varName: 'FIREBASE_APP_ID_IOS', obfuscate: true)
  static final String FIREBASE_APP_ID_IOS = _EnvStaging.FIREBASE_APP_ID_IOS;
  @EnviedField(varName: 'FIREBASE_MESSAGING_SENDER_ID', obfuscate: true)
  static final String FIREBASE_MESSAGING_SENDER_ID = _EnvStaging.FIREBASE_MESSAGING_SENDER_ID;
  @EnviedField(varName: 'FIREBASE_PROJECT_ID', obfuscate: true)
  static final String FIREBASE_PROJECT_ID = _EnvStaging.FIREBASE_PROJECT_ID;
  @EnviedField(varName: 'IOS_BUNDLE_ID', obfuscate: true)
  static final String IOS_BUNDLE_ID = _EnvStaging.IOS_BUNDLE_ID;
}

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'BASE_API_URL', obfuscate: true)
  static final String ENV_BASE_API_URL = _EnvProd.ENV_BASE_API_URL;
  @EnviedField(varName: 'ENV', obfuscate: true)
  static final String ENV_NAME = _EnvProd.ENV_NAME;
  @EnviedField(varName: 'FIREBASE_APIKEY_ANDROID', obfuscate: true)
  static final String FIREBASE_APIKEY_ANDROID = _EnvProd.FIREBASE_APIKEY_ANDROID;
  @EnviedField(varName: 'FIREBASE_APIKEY_IOS', obfuscate: true)
  static final String FIREBASE_APIKEY_IOS = _EnvProd.FIREBASE_APIKEY_IOS;
  @EnviedField(varName: 'FIREBASE_APP_ID_ANDROID', obfuscate: true)
  static final String FIREBASE_APP_ID_ANDROID = _EnvProd.FIREBASE_APP_ID_ANDROID;
  @EnviedField(varName: 'FIREBASE_APP_ID_IOS', obfuscate: true)
  static final String FIREBASE_APP_ID_IOS = _EnvProd.FIREBASE_APP_ID_IOS;
  @EnviedField(varName: 'FIREBASE_MESSAGING_SENDER_ID', obfuscate: true)
  static final String FIREBASE_MESSAGING_SENDER_ID = _EnvProd.FIREBASE_MESSAGING_SENDER_ID;
  @EnviedField(varName: 'FIREBASE_PROJECT_ID', obfuscate: true)
  static final String FIREBASE_PROJECT_ID = _EnvProd.FIREBASE_PROJECT_ID;
  @EnviedField(varName: 'IOS_BUNDLE_ID', obfuscate: true)
  static final String IOS_BUNDLE_ID = _EnvProd.IOS_BUNDLE_ID;
}

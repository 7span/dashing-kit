import 'package:firebase_remote_config/firebase_remote_config.dart';

///In your firebase console, you can set the default values for your app.
///The json will looks like this:
///{"android":{"version":"1.0.1","allow_cancel":true},"ios":{"version":"1.0.0","allow_cancel":true}}
///And the key name of the json will be "force_update"
///You can modify the json and key name in the firebase console and here as well.
class FirebaseRemoteConfigService {
  factory FirebaseRemoteConfigService() =>
      _instance ??= FirebaseRemoteConfigService._();

  FirebaseRemoteConfigService._()
    : _remoteConfig = FirebaseRemoteConfig.instance;

  static FirebaseRemoteConfigService? _instance;

  final FirebaseRemoteConfig _remoteConfig;

  bool getBool(String key) => _remoteConfig.getBool(key);

  String getString(String key) => _remoteConfig.getString(key);

  Future<void> _setConfigSettings() async =>
      _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );

  Future<void> _setDefaults() async {
    await _remoteConfig.setDefaults(const {
      'android': '''
    {
      "version": "1.0.0",
      "allow_cancel": true
    }
    ''',
      'ios': '''
    {
      "version": "1.0.0",
      "allow_cancel": true
    }
    ''',
    });
  }

  Future<void> initialize() async {
    await _setConfigSettings();
    await _setDefaults();
    await fetchAndActivate();
  }

  Future<void> fetchAndActivate() async {
    await _remoteConfig.fetchAndActivate();
  }

  String getForceUpdateConfig() {
    return _remoteConfig.getString('force_update');
  }
}

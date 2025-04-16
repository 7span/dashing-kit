import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_core/core/data/models/force_update_config_model.dart';
import 'package:app_core/core/data/services/firebase_remote_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

/// A client that handles force update functionality in the application
class ForceUpdateClient {
  /// Creates a [ForceUpdateClient] with the required iOS App Store ID
  ///
  /// Optionally accepts a custom Firebase Remote Config service
  ForceUpdateClient({required this.iosAppStoreId, required this.remoteConfigService});

  /// The iOS App Store ID for the application
  final String iosAppStoreId;

  /// The Firebase Remote Config service used to fetch update configurations
  final FirebaseRemoteConfigService remoteConfigService;

  /// Logger name constant
  static const _name = 'Force Update';

  /// Determines if an app update is required based on version comparison
  ///
  /// Returns true if the current app version is less than the required version
  Future<bool> isAppUpdateRequired() async {
    // Skip update check for web or unsupported platforms
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android)) {
      return false;
    }

    final requiredVersionStr = await _fetchRequiredVersion();
    if (requiredVersionStr.isEmpty) {
      log('Remote Config: required_version not set. Ignoring.', name: _name);
      return false;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    // Extract semantic version using regex
    final currentVersionStr = RegExp(r'\d+\.\d+\.\d+').matchAsPrefix(currentVersion)!.group(0)!;

    // Parse versions for comparison
    final parsedRequiredVersion = Version.parse(requiredVersionStr);
    final parsedCurrentVersion = Version.parse(currentVersionStr);

    final updateRequired = parsedCurrentVersion < parsedRequiredVersion;

    log(
      'Update ${updateRequired ? '' : 'not '}required. '
      'Current version: $parsedCurrentVersion, required version: $parsedRequiredVersion',
      name: _name,
    );

    return updateRequired;
  }

  /// Returns the appropriate app store URL based on the platform
  ///
  /// Returns null if the platform is not supported or required data is missing
  Future<String?> storeUrl() async {
    if (kIsWeb) return null;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosAppStoreId.isNotEmpty ? 'https://apps.apple.com/app/id$iosAppStoreId' : null;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final packageInfo = await PackageInfo.fromPlatform();
      return 'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
    } else {
      log('No store URL for platform: ${defaultTargetPlatform.name}', name: _name);
      return null;
    }
  }

  /// Checks if the force update dialog can be dismissed by the user
  ///
  /// Returns true if cancellation is allowed or if configuration can't be fetched
  Future<bool> isAllowCancelEnabled() async {
    // Allow cancel by default for web or unsupported platforms
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android)) {
      return true;
    }

    try {
      await remoteConfigService.fetchAndActivate();
      final forceUpdateJson = remoteConfigService.getForceUpdateConfig();
      if (forceUpdateJson.isEmpty) return true;

      final Map<String, dynamic> forceUpdate = json.decode(forceUpdateJson);
      final platform = _getCurrentPlatformKey();

      if (!forceUpdate.containsKey(platform)) return true;

      final data = ForceUpdateConfig.fromJson(forceUpdate[platform] as Map<String, dynamic>);
      return data.allowCancel as bool? ?? true;
    } catch (e) {
      log('Error checking if cancel is allowed: $e', name: _name);
      return true;
    }
  }

  /// Fetches the required version from remote config
  ///
  /// Returns default version '1.0.0' if config can't be fetched or parsed
  Future<String> _fetchRequiredVersion() async {
    try {
      await remoteConfigService.fetchAndActivate();
      final forceUpdateJson = remoteConfigService.getForceUpdateConfig();
      if (forceUpdateJson.isEmpty) return '1.0.0';

      final Map<String, dynamic> forceUpdate = json.decode(forceUpdateJson);
      final platform = _getCurrentPlatformKey();

      if (!forceUpdate.containsKey(platform)) return '1.0.0';

      final data = ForceUpdateConfig.fromJson(forceUpdate[platform] as Map<String, dynamic>);
      return data.version as String? ?? '1.0.0';
    } catch (e) {
      log('Error parsing force update config: $e', name: _name);
      return '1.0.0';
    }
  }

  /// Helper to get the current platform key for config lookup
  String _getCurrentPlatformKey() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return '';
  }
}

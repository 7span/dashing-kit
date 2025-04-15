import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_core/core/data/models/force_update_config_model.dart';
import 'package:app_core/core/data/services/firebase_remote_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class ForceUpdateClient {
  ForceUpdateClient({
    required this.iosAppStoreId,
    Future<String> Function()? fetchRequiredVersion,
    this.fetchCurrentPatchVersion,
    FirebaseRemoteConfigService? remoteConfigService,
  }) : _remoteConfigService = remoteConfigService ?? FirebaseRemoteConfigService(),
       fetchRequiredVersion =
           fetchRequiredVersion ??
           (() async {
             final remoteConfig = FirebaseRemoteConfigService();
             await remoteConfig.fetchAndActivate();

             final forceUpdateJson = remoteConfig.getForceUpdateConfig();
             if (forceUpdateJson.isEmpty) return '1.0.0';

             try {
               final Map<String, dynamic> forceUpdate = json.decode(forceUpdateJson);

               var platform = '';
               if (Platform.isAndroid) {
                 platform = 'android';
               } else if (Platform.isIOS) {
                 platform = 'ios';
               } else {
                 return '1.0.0';
               }

               if (!forceUpdate.containsKey(platform)) return '1.0.0';
               final data = ForceUpdateConfig.fromJson(
                 forceUpdate[platform] as Map<String, dynamic>,
               );
               return data.version as String? ?? '1.0.0';
             } catch (e) {
               log('Error parsing force update config: $e', name: _name);
               return '1.0.0';
             }
           });

  final Future<String> Function() fetchRequiredVersion;

  final Future<String> Function()? fetchCurrentPatchVersion;

  final String iosAppStoreId;

  final FirebaseRemoteConfigService _remoteConfigService;

  static const _name = 'Force Update';

  Future<bool> isAppUpdateRequired() async {
    // * Only force app update on iOS & Android
    if (kIsWeb ||
        defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    final requiredVersionStr = await fetchRequiredVersion();
    if (requiredVersionStr.isEmpty) {
      log('Remote Config: required_version not set. Ignoring.', name: _name);
      return false;
    }
    final patchVersion = await fetchCurrentPatchVersion?.call();
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = patchVersion ?? packageInfo.version;

    // * On Android, the current version may appear as `^X.Y.Z(.*)`
    // * But semver can only parse this if it's formatted as `^X.Y.Z-(.*)`
    // * and we only care about X.Y.Z, so we can remove the flavor
    final currentVersionStr = RegExp(r'\d+\.\d+\.\d+').matchAsPrefix(currentVersion)!.group(0)!;

    // * Parse versions in semver format
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

  Future<String?> storeUrl() async {
    if (kIsWeb) {
      return null;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // * On iOS, use the given app ID
      return iosAppStoreId.isNotEmpty ? 'https://apps.apple.com/app/id$iosAppStoreId' : null;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final packageInfo = await PackageInfo.fromPlatform();
      // * On Android, use the package name from PackageInfo
      return 'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
    } else {
      log('No store URL for platform: ${defaultTargetPlatform.name}', name: _name);
      return null;
    }
  }

  Future<bool> isAllowCancelEnabled() async {
    if (kIsWeb ||
        defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android) {
      return true;
    }

    try {
      await _remoteConfigService.fetchAndActivate();
      final forceUpdateJson = _remoteConfigService.getForceUpdateConfig();
      if (forceUpdateJson.isEmpty) return true;

      final Map<String, dynamic> forceUpdate = json.decode(forceUpdateJson);

      var platform = '';
      if (Platform.isAndroid) {
        platform = 'android';
      } else if (Platform.isIOS) {
        platform = 'ios';
      } else {
        return true;
      }

      if (!forceUpdate.containsKey(platform)) return true;
      final data = ForceUpdateConfig.fromJson(forceUpdate[platform] as Map<String, dynamic>);
      return data.allowCancel as bool? ?? true;
    } catch (e) {
      log('Error checking if cancel is allowed: $e', name: _name);
      return true;
    }
  }
}

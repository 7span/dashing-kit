import 'dart:io';

import 'package:app_core/app/enum.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  /// Request single [permission]
  ///
  /// Returns true if the permission was granted. False otherwise
  Future<PermissionResultData> requestPermission(MediaPermission permission) async {
    final result = await requestPermissions([permission]);
    return result.values.toList()[0];
  }

  void redirectToSettings() {
    openAppSettings();
  }

  /// Request multiple [permissions]
  ///
  /// Returns the map of [PermissionResultData] of each permission
  Future<Map<MediaPermission, PermissionResultData>> requestPermissions(
    List<MediaPermission> permissions,
  ) async {
    final permissionsToAsk = _mapRuntimePermissions(permissions);

    /// Request permissions
    final statuses = await permissionsToAsk.request();

    return _mapResult(statuses);
  }

  List<Permission> _mapRuntimePermissions(List<MediaPermission> runtimePermissions) {
    final permissions = <Permission>[];

    final permissionMapper = RuntimePermissionMapper();
    for (final permission in runtimePermissions) {
      permissions.add(permissionMapper.map(permission));
    }

    return permissions;
  }

  Map<MediaPermission, PermissionResultData> _mapResult(Map<Permission, PermissionStatus> result) {
    final resultMap = <MediaPermission, PermissionResultData>{};
    final permissionMapper = RuntimePermissionMapper();
    final permissionResultMapper = PermissionResultMapper();

    result.forEach((key, value) {
      resultMap[permissionMapper.reverseMap(key)] =
          PermissionResultData(result: permissionResultMapper.map(value));
    });

    return resultMap;
  }
}

class PermissionResultData {
  PermissionResultData({required this.result});
  PermissionResult result;
}

class RuntimePermissionMapper extends BaseMapper<MediaPermission, Permission> {
  Future<int> getData() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt;
  }

  /// MediaPermission map  [MediaPermission]
  ///
  /// Add any additional permission required in app
  @override
  Permission map(MediaPermission t) {
    if (t == MediaPermission.photo) {
      return Permission.photos;
    } else if (t == MediaPermission.camera) {
      return Permission.camera;
    } else if (t == MediaPermission.storage) {
      return Permission.storage;
    }
    throw UnimplementedError('Unknown permission: $t');
  }

  MediaPermission reverseMap(Permission permission) {
    if (permission == Permission.storage || permission == Permission.photos) {
      return MediaPermission.photo;
    } else if (permission == Permission.camera) {
      return MediaPermission.camera;
    }

    throw UnimplementedError('Unknown permission: $permission');
  }
}

class PermissionResultMapper extends BaseMapper<PermissionStatus, PermissionResult> {
  @override
  PermissionResult map(PermissionStatus t) {
    if (t.isGranted) return PermissionResult.granted;
    if (t.isPermanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    }
    if (t.isLimited) return PermissionResult.granted;
    if (t.isDenied && Platform.isIOS) return PermissionResult.permanentlyDenied;
    return PermissionResult.denied;
  }
}

// ignore: one_member_abstracts
abstract class BaseMapper<T, V> {
  V map(T t);
}

import 'package:bloc_boilerplate/app/enum.dart';
import 'package:bloc_boilerplate/app/helpers/permission/permission_helper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  final _permissionsHelper = PermissionsHelper();
  String? permissions;
  final _runtimePermissionMapper = RuntimePermissionMapper();

  /// RequestPermission shows dialog to allow/deny permission to user
  Future<PermissionResultData> requestPermission(
    MediaPermission permission,
    BuildContext context,
  ) async {
    final result = await _permissionsHelper.requestPermission(permission);
    permissions = permission.toString();
    if (result.result == PermissionResult.granted) {
    } else {
      ///If user don't allow the permission customise your UI here
      if (context.mounted) {
        await _showPermissionInfoDialog(result.result, context);
      }
    }
    return result;
  }


  /// returns true or false based on if permission is granted or not
  Future<bool> getPermissionStatus(MediaPermission runtimePermission) async {
    var isGranted = false;
    final status = await _runtimePermissionMapper.map(runtimePermission).status;
    if (status.isGranted) {
      isGranted = true;
    }
    return isGranted;
  }

  /// If user not grants permission this will show additional information that why the permission is required.
  Future<void> _showPermissionInfoDialog(
    PermissionResult currentResult,
    BuildContext context,
  ) async {
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (builder) => const Padding(
        padding: EdgeInsets.all(5),
        child: AlertDialog(
          title: Text('Permission(s) required'),
          content: Text('Please grant the required permission(s) in order to select image'),
        ),
      ),
      isDismissible: false,
    );
  }
}

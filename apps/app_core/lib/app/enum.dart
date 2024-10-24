/// For setting up the environments
enum Env {
  development('development'),
  staging('staging'),
  production('production');

  const Env(this.value);
  final String value;
}

/// Used in adding the events based on internet connection status
enum ConnectionStatus {
  online,
  offline,
}

enum ButtonType {
  elevated,
  filled,
  tonal,
  outlined,
  text,
}

/// Used as key in **auth_service.dart** file as key for Hive Storage in getting
/// and setting the userdata
enum HiveKeys {
  userData('data'),
  userToken('token');

  const HiveKeys(this.value);

  final String value;
}

/// Permissions enum
enum MediaPermission {
  camera,
  photo,
  storage,
}

enum PermissionResult {
  granted,
  denied,
  permanentlyDenied,
}

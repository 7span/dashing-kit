/// For setting up the environments
enum Env {
  development('development'),
  staging('staging'),
  production('production');

  const Env(this.value);
  final String value;
}

/// For making some computations based on status code.
///
/// See also:
/// * extensions.dart file
enum StatusCode {
  http200(200),
  http201(201),
  http204(204),
  http304(304),
  http400(400),
  http401(401),
  http403(403),
  http404(404),
  http405(405),
  http415(415),
  http422(422),
  http429(429),
  http500(500),
  http000(000);

  const StatusCode(this.value);
  final int value;
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
enum USER {
  data('data'),
  token('token');

  const USER(this.value);

  final String value;
}

/// Used while making the API request to define the type of the request
enum RequestType {
  get,
  post,
  put,
  delete,
}

/// Used in state class for emitting the status of the API
enum ApiStatus { initial, loading, loaded, error }

///Permissions enum
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

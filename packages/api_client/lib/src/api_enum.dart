/// Used while making the API request to define the type of the request
enum RequestType {
  query,
  mutation,
  get,
  put,
  post,
  delete,
  //Used to execute retry api after refresh token
  dynamic,
}

/// Used in state class for emitting the status of the API
enum ApiStatus { initial, loading, loaded, error, empty }

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

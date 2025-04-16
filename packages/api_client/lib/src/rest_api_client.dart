import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_tokens_interceptor.dart';

/// This class is used for connecting with remote data source using Dio
/// as an API Client. This class is responsible for making API requests and
/// sending the response in case of success and error in case of API failure.
final class RestApiClient {
  RestApiClient();

  String baseAPIURL = '';

  ///initialize dio and Hive Cache for API. It is configurable to disable the
  ///cache by providing [isApiCacheEnabled] to false.
  ///
  ///
  /// - [endPointsToEscapeRefreshTokenCheck]: Refresh token expiration check can be escaped for provided endpoints e.g. login, logout etc.
  /// [refreshTokenEndpoint] is must to enable refreshToken API handlation
  ///
  /// - [endPointsToEscapeHeaderToken]: Auto passing of header token can be escaped for provided endpoints e.g. login, refreshToken etc, if provided none, by default it will auto pass header token in every API request header.
  ///
  /// - [onForceLogout] will be called in case if refresh token is also expired
  ///
  /// Additionally, you can pass [skipAuth] as extra param in request options to skip token passing
  ///
  /// Example:
  /// ```dart
  /// final awsApiResponse = await dio.put(
  ///   awsApiCall,
  ///   ....
  ///   options: Options(
  ///     extra: {'skipAuth': true},
  ///     headers: ...,
  ///   ),
  /// );
  /// ```
  ///
  /// Intercepts successful HTTP responses to extract and save user tokens
  /// if the response contains them in the expected structure.
  ///
  /// Supported response format:
  /// ```json
  /// {
  ///   "data": {
  ///     "token": "<access_token>",
  ///     "refreshToken": "<refresh_token>"
  ///   }
  /// }
  /// ```
  ///
  /// Calls the refresh token API with below Request and Response format:
  ///
  /// Sends a POST request with the following body:
  /// ```json
  /// {
  ///   "token": "<refresh_token>"
  /// }
  /// ```
  ///
  /// Expects a response in the format:
  /// ```json
  /// {
  ///   "message": "Token refreshed successfully",
  ///   "data": {
  ///     "token": "<new_access_token>",
  ///     "refreshToken": "<new_refresh_token>"
  ///   }
  /// }
  /// ```
  ///
  /// **Action Required:**
  /// Please inform the backend API team to ensure that both the request and response structures for the following APIs are aligned with the formats described above:
  /// - **Authentication APIs** (e.g. signin, signup)
  /// - **Refresh Token API**
  ///
  /// The request and response structures should match the following:
  ///
  /// - **Request**:
  ///   - For signin/signup:
  ///     ```json
  ///     {
  ///       ...
  ///     }
  ///     ```
  ///   - For refresh token:
  ///     ```json
  ///     {
  ///       "token": "<refresh_token>",
  ///       ...
  ///     }
  ///     ```
  ///
  /// - **Response**:
  ///   - For signin/signup:
  ///     ```json
  ///     {
  ///       "data": {
  ///         "token": "<access_token>",
  ///         "refreshToken": "<refresh_token>",
  ///         ...
  ///       },
  ///       ...
  ///     }
  ///     ```
  ///   - For refresh token:
  ///     ```json
  ///     {
  ///       "data": {
  ///         "token": "<new_access_token>",
  ///         "refreshToken": "<new_refresh_token>",
  ///         ...
  ///       },
  ///       ...
  ///     }
  ///     ```
  ///
  /// To access Tokens in your project module
  ///
  /// It provides methods to fetch authentication tokens(access and refresh)
  ///and clear them during logout.
  ///
  /// Retrieves the stored refresh token.
  ///
  /// Example usage:
  /// ```dart
  /// String refreshToken = HiveApiService.instance.getRefreshToken();
  /// ```
  ///
  /// Retrieves the stored access token.
  ///
  /// Example usage:
  /// ```dart
  /// String accessToken = HiveApiService.instance.getAccessToken();
  /// ```
  ///
  /// Clears both access and refresh tokens (e.g. used during logout).
  ///
  /// Example usage:
  /// ```dart
  /// HiveApiService.instance.clearTokens();
  /// ```
  Future<Unit> init({
    required bool isApiCacheEnabled,
    required String baseURL,
    String? refreshTokenEndpoint,
    List<String> endPointsToEscapeRefreshTokenCheck = const [],
    List<String> endPointsToEscapeHeaderToken = const [],
    void Function()? onForceLogout,
  }) async {
    baseAPIURL = baseURL;
    dio = Dio(
      BaseOptions(
        baseUrl: baseAPIURL,
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    await HiveApiService.instance.init();
    if (isApiCacheEnabled) {
      final dir = await getTemporaryDirectory();
      final options = CacheOptions(
        /// Other store that you can use instead of Hive
        /// store: MemCacheStore(),
        store: HiveCacheStore(dir.path),
        hitCacheOnErrorExcept: [401, 403],
        policy: CachePolicy.forceCache,
        priority: CachePriority.high,
      );

      /// Adding caching interceptor for request
      dio.interceptors.add(DioCacheInterceptor(options: options));
    }
    dio.interceptors.add(
      ApiTokensInterceptor(
        client: this,
        endPointsToEscapeRefreshTokenCheck:
            endPointsToEscapeRefreshTokenCheck,
        endPointsToEscapeHeaderToken: endPointsToEscapeHeaderToken,
        refreshTokenEndpoint: refreshTokenEndpoint,
        onForceLogout: onForceLogout,
      ),
    );

    /// Adding Dio logger in order to print API responses beautifully
    dio.interceptors.add(
      PrettyDioLogger(requestHeader: true, requestBody: true),
    );

    return unit;
  }

  late final Dio dio;

  /// With this function, users can make GET, POST, PUT, DELETE request using
  /// only single function.
  TaskEither<Failure, Response> request({
    required String path,
    RequestType requestType = RequestType.get,
    Map<String, dynamic>? queryParameters,
    Options? options,
    String? saveFilePath,
    Object? body,
  }) => TaskEither.tryCatch(() async {
    switch (requestType) {
      case RequestType.get:
        return dio.get(
          path,
          queryParameters: queryParameters,
          options: options,
          data: body,
        );
      case RequestType.post:
        return dio.post(
          path,
          queryParameters: queryParameters,
          options: options,
          data: body,
        );
      case RequestType.put:
        return dio.put(
          path,
          queryParameters: queryParameters,
          options: Options(contentType: 'image/jpg'),
          data: body,
        );
      case RequestType.delete:
        return dio.delete(path, data: body);
      case RequestType.dynamic:
        return dio.request<dynamic>(
          path,
          queryParameters: queryParameters,
          options: options,
          data: body,
        );
      case RequestType.query:
      case RequestType.mutation:
        throw Exception('can\'t use query / mutation in REST');
    }
  }, (error, stackTrace) => APIFailure(error, stackTrace));
}

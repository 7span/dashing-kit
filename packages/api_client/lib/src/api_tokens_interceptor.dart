import 'package:api_client/api_client.dart';
import 'package:api_client/src/refresh_token_service.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import 'hive.api.service.dart';

class ApiTokensInterceptor extends QueuedInterceptor {
  /// No need to call refresh token if login & logout APIs.
  final List<String> endPointsToEscapeRefreshTokenCheck;
  final List<String> endPointsToEscapeHeaderToken;
  final String? refreshTokenEndpoint;

  final void Function()? onForceLogout;

  final RestApiClient client;

  ///[ApiTokensInterceptor] handles responsibility of storing and passing header token in necessary request and also for managing refresh token expiration, in case of token expiration it will fetch new token using refresh token and will retry the previous API call automatically
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
  ApiTokensInterceptor({
    required this.client,
    required this.endPointsToEscapeRefreshTokenCheck,
    required this.endPointsToEscapeHeaderToken,
    required this.refreshTokenEndpoint,
    this.onForceLogout,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final shouldSkipAuth = options.extra['skipAuth'] == true;
    if (!shouldSkipAuth &&
        !endPointsToEscapeHeaderToken.contains(options.path)) {
      final accessToken = HiveApiService.instance
          .getAccessToken()
          .getOrElse(() => '');
      if (accessToken.trim().isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Ref. https://stackoverflow.com/questions/56740793/using-interceptor-in-dio-for-flutter-to-refresh-token
    final response = err.response;

    if (response == null) {
      return super.onError(err, handler);
    }

    /// Step 1
    /// Check if you need to call refresh token API
    final shouldCallRefreshTokenApi = _needToCallRefreshToken(
      response.statusCode!,
      response.requestOptions,
      endPointsToEscapeRefreshTokenCheck,
      refreshTokenEndpoint,
      onForceLogout,
    );

    if (!shouldCallRefreshTokenApi) {
      return super.onError(err, handler);
    }

    /// Step - 2 Calling the refresh token API
    final refreshedToken =
        await RefreshTokenService(client)
            .fetchRefreshToken(refreshTokenEndpoint!)
            .getOrElse(
              (_) => throw Exception('Failed to refresh token'),
            )
            .run();

    /// Step - 3 and retrying the API call
    if (refreshedToken.trim().isNotEmpty) {
      final requestOpt = response.requestOptions;
      if (requestOpt.headers.containsKey('Authorization')) {
        requestOpt.headers['Authorization'] =
            'Bearer $refreshedToken';
      }

      await _retryApiAfterRefreshToken(requestOpt).map((r) {
        return handler.resolve(r);
      }).run();
    }
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    TaskEither.tryCatch(() async {
      final data = response.data;
      if (data is Map && data['data'] is Map) {
        final token = data['data']['token'];
        final refreshToken = data['data']['refreshToken'];

        if (token != null && refreshToken != null) {
          await UserTokenSaveService.instance
              .setAccessToken(token)
              .flatMap(
                (_) => UserTokenSaveService.instance.setRefreshToken(
                  refreshToken,
                ),
              )
              .run();
        }
      }
    }, (_, _) {}).run();
    super.onResponse(response, handler);
  }

  /// Calls [onLogout] in case the user is unauthorized and the refresh
  /// token is expired
  bool _needToCallRefreshToken(
    int statusCode,
    RequestOptions requestOptions,
    List<String> endPointsToEscape,
    String? refreshTokenEndpoint,
    void Function()? onLogout,
  ) {
    if ((refreshTokenEndpoint ?? '').trim().isEmpty == true) {
      return false;
    }

    if (endPointsToEscape.contains(requestOptions.path)) {
      return false;
    }

    if (statusCode.getStatusCodeEnum.isUserUnAuthorized &&
        requestOptions.path == refreshTokenEndpoint) {
      HiveApiService.instance.clearTokens().run();
      onLogout?.call();
      return false;
    }

    if (statusCode.getStatusCodeEnum.isUserUnAuthorized) {
      return true;
    }

    return false;
  }

  TaskEither<Failure, Response> _retryApiAfterRefreshToken(
    RequestOptions requestOptions,
  ) {
    // Ref. https://github.com/cfug/dio/issues/482
    // https://stackoverflow.com/a/51106300/5370550
    final processedDataTask =
        requestOptions.data is FormData
            ? processFiles(requestOptions.data).map(
              (formData) => requestOptions.copyWith(data: formData),
            )
            : TaskEither.right(
              requestOptions,
            ); // If not FormData, pass original options

    return processedDataTask
        .flatMap(
          (updatedRequestOptions) => client.request(
            path: updatedRequestOptions.path,
            body: updatedRequestOptions.data,
            requestType: RequestType.dynamic,
            queryParameters: updatedRequestOptions.queryParameters,
            options: Options(
              method: updatedRequestOptions.method,
              headers: updatedRequestOptions.headers,
            ),
          ),
        )
        .mapLeft(APIFailure.new);
  }
}

TaskEither<Exception, FormData> processFiles(FormData data) {
  final formData = FormData()..fields.addAll(data.fields);

  final List<TaskEither<Exception, MapEntry<String, MultipartFile>>>
  filesTask =
      data.files
          .map(
            (
              mapFile,
            ) => TaskEither<Exception, MultipartFile>.tryCatch(
              () => MultipartFile.fromFile(
                mapFile.value.filename!,
                filename: mapFile.value.filename,
              ),
              (error, stackTrace) =>
                  Exception("Failed to create MultipartFile: $error"),
            ).map(
              (multipartFile) => MapEntry(mapFile.key, multipartFile),
            ),
          )
          .toList();

  return TaskEither.sequenceList(filesTask).map((entries) {
    formData.files.addAll(entries);
    return formData;
  });
}

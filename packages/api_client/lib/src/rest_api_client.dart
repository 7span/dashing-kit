import 'package:api_client/src/api_enum.dart';
import 'package:api_client/src/api_failure.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// This class is used for connecting with remote data source using Dio
/// as an API Client. This class is responsible for making API requests and
/// sending the response in case of success and error in case of API failure.
final class RestApiClient {
  RestApiClient();

  String baseAPIURL = '';

  ///initialize dio and Hive Cache for API. It is configurable to disable the
  ///cache by providing [isApiCacheEnabled] to false.
  Future<Unit> init({
    required bool isApiCacheEnabled,
    required String baseURL,
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

    /// Adding Dio logger in order to print API responses beautifully
    dio.interceptors.add(
      PrettyDioLogger(requestHeader: true, requestBody: true),
    );
    return unit;
  }

  late final Dio dio;
  //  final dio = Dio(
  //   BaseOptions(
  //     baseUrl: baseAPIURL,
  //     contentType: 'application/json',
  //     connectTimeout: const Duration(seconds: 5),
  //     receiveTimeout: const Duration(seconds: 5),
  //   ),
  // );

  void setAuthorizationToken(String token) {
    dio.options.headers = {'Authorization': 'Bearer $token'};
  }

  /// With this function, users can make GET, POST, PUT, DELETE request using
  /// only single function.
  TaskEither<Failure, Response> request({
    required String path,
    RequestType requestType = RequestType.get,
    Map<String, dynamic>? queryParameters,
    Options? options,
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
      case RequestType.query:
      case RequestType.mutation:
        throw Exception('can\'t use query / mutation in REST');
    }
  }, (error, stackTrace) => APIFailure(error, stackTrace));
}

import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class RepositoryUtils {
  /// This functions checks if the status code is valid or not
  /// and based on that it delegates to the next function or returns error
  /// in case of the Error.
  static Either<Failure, Response> checkStatusCode(Response response) =>
      Either<Failure, Response>.fromPredicate(
        response,
        (response) => response.statusCode?.getStatusCodeEnum.isSuccess ?? false,
        APIFailure.new,
      );

  static Either<Failure, T> mapToModel<T>(
    T Function() convertModelFunction,
  ) =>
      Either<ModelConversionFailure, T>.tryCatch(
        () => convertModelFunction.call(),
        (error, stackTrace) => ModelConversionFailure(
          error: error,
          stackTrace: stackTrace,
        ),
      );

  static Either<Failure, String> getMessageResponse(Response response) {
    return Either.tryCatch(
      // ignore: avoid_dynamic_calls
      () => response.data['message'] as String,
      APIFailure.new,
    );
  }
}

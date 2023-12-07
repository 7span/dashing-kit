import 'package:dio/dio.dart';
import 'package:app_core/core/domain/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:app_core/app/helpers/extensions/extensions.dart';

class RepositoryUtils {
  /// This functions checks if the status code is valid or not
  /// and based on that it delegates to the next function or returns error
  /// in case of the Error.
  static Either<Failure, Response> checkStatusCode(Response response) =>
      Either<Failure, Response>.fromPredicate(
        response,
        (response) => response.statusCode?.getStatusCodeEnum.isSuccess ?? false,
        (error) => APIFailure(error: error),
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
      (error, stackStrace) => APIFailure(
        error: error.toString(),
      ),
    );
  }
}

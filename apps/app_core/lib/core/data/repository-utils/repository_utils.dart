import 'package:api_client/api_client.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

class RepositoryUtils {
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

  static Either<Failure, Response> checkStatusCode(Response response) =>
      Either<Failure, Response>.fromPredicate(
        response,
            (response) => response.statusCode!.getStatusCodeEnum.isSuccess,
            APIFailure.new,
      );
}

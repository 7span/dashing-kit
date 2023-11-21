// ignore_for_file: one_member_abstracts

import 'package:bloc_boilerplate/app/config/api_config.dart';
import 'package:bloc_boilerplate/app/enum.dart';
import 'package:bloc_boilerplate/core/domain/failure.dart';
import 'package:bloc_boilerplate/modules/home/model/post_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

/// This is the abstract representation of the HomeRepository
abstract interface class IHomeRepository {
  /// This functions returns TaskEither. In this, Task is indicating that this function
  /// is returning Future and Either is indicating that the function can either
  /// successfully return a value or return a Failure Object.
  TaskEither<Failure, List<PostModel>> fetchPosts({required int page});
}

/// This repository contains the implementation for [IHomeRepository]
class HomeRepository implements IHomeRepository {
  @override
  TaskEither<Failure, List<PostModel>> fetchPosts({required int page}) =>
      mappingRequest('posts', page);

  /// This mapping request function is basically a wrapper around all of the function
  ///  that makes API requests and handles the validation logic and Failure handling
  TaskEither<Failure, List<PostModel>> mappingRequest(String url, int page) =>
      makefetchPostsRequest(url, page)
          .chainEither(checkStatusCode)
          .chainEither(mapToList)
          .flatMap(mapToModel);

  TaskEither<Failure, Response> makefetchPostsRequest(String url, int page) {
    return ApiClient.request(
      path: url,
      queryParameters: {
        '_page': page,
        '_limit': 10,
      },
      requestType: RequestType.get,
    );
  }

  /// This functions checks if the status code is valid or not
  /// and based on that it delegates to the next function or returns error
  /// in case of the Error.
  Either<Failure, Response> checkStatusCode(Response response) =>
      Either<Failure, Response>.fromPredicate(
        response,
        (response) => response.statusCode == 200 || response.statusCode == 304,
        (error) => APIFailure(error: error),
      );

  /// This function is responsible for converting the repose to the dynamic list
  /// which can also return Failure in case of any casting Error. That's why it
  /// returns Either instead of List<dynamic>
  Either<Failure, List<dynamic>> mapToList(Response response) {
    return Either<Failure, List<dynamic>>.safeCast(
      response.data,
      (error) => ModelConversionFailure(error: error),
    );
  }

  /// This function maps the List<Map<String,dynamic>>  to List<PostModel>. Since this conversion can also
  /// throw error, we have to return TaskEither.
  TaskEither<Failure, List<PostModel>> mapToModel(
    List<dynamic> responseList,
  ) =>
      TaskEither<Failure, List<PostModel>>.tryCatch(
        () async =>
            responseList.map((json) => PostModel.fromJson(json as Map<String, dynamic>)).toList(),
        (error, stackTrace) => ModelConversionFailure(
          error: error,
          stackTrace: stackTrace,
        ),
      );
}

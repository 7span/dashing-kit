// ignore_for_file: one_member_abstracts

import 'package:app_core/app/config/api_config.dart';
import 'package:app_core/app/enum.dart';
import 'package:app_core/core/data/repository-utils/repository_utils.dart';
import 'package:app_core/core/domain/failure.dart';
import 'package:app_core/modules/home/model/post_model.dart';
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
          .chainEither(RepositoryUtils.checkStatusCode)
          .chainEither(mapToList)
          .chainEither(
            (r) => RepositoryUtils.mapToModel(
              () => r
                  .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            ),
          );

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

  /// This function is responsible for converting the repose to the dynamic list
  /// which can also return Failure in case of any casting Error. That's why it
  /// returns Either instead of List<dynamic>
  Either<Failure, List<dynamic>> mapToList(Response response) {
    return Either<Failure, List<dynamic>>.safeCast(
      response.data,
      (error) => ModelConversionFailure(error: error),
    );
  }
}

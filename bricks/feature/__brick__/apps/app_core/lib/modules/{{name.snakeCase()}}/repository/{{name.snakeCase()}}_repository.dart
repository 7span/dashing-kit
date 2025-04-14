// ignore_for_file: avoid_dynamic_calls

import 'package:api_client/api_client.dart';
import 'package:app_core/core/data/repository-utils/repository_utils.dart';
import 'package:app_core/modules/{{name.snakeCase()}}/model/{{name.snakeCase()}}_model.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

abstract interface class I{{name.pascalCase()}}Repository {
  const I{{name.pascalCase()}}Repository();

  TaskEither<Failure, {{name.pascalCase()}}ResponseModel> get{{name.pascalCase()}}Data(int page);

  TaskEither<Failure, {{name.pascalCase()}}ResponseModel> get{{name.pascalCase()}}Details(int id);

  TaskEither<Failure, bool> save{{name.pascalCase()}}(
    int? id,
    String title,
    String description,
  );

  TaskEither<Failure, bool> delete{{name.pascalCase()}}(int id);
}

/// This repository contains the implementation for [I{{name.pascalCase()}}Repository]
class {{name.pascalCase()}}Repository implements I{{name.pascalCase()}}Repository {
  const {{name.pascalCase()}}Repository();

  @override
  TaskEither<Failure, {{name.pascalCase()}}ResponseModel> get{{name.pascalCase()}}Data(int page) =>
      mappingRequest(page);

  /// This mapping request function is basically a wrapper around all of the function
  ///  that makes API requests and handles the validation logic and Failure handling
  TaskEither<Failure, {{name.pascalCase()}}ResponseModel> mappingRequest(int page) =>
      _makeFetchRequest(page)
          .chainEither(RepositoryUtils.checkStatusCode)
          .chainEither(
            (r) => RepositoryUtils.mapToModel(
              () => {{name.pascalCase()}}ResponseModel.fromJson(
                r.data as Map<String, dynamic>,
              ),
            ),
          );

  TaskEither<Failure, Response> _makeFetchRequest(int page) =>
      userApiClient.request(path: 'path', body: {'page': page, 'perPage': 15});

  @override
  TaskEither<Failure, bool> save{{name.pascalCase()}}(
    int? id,
    String title,
    String description,
  ) => userApiClient.request(
    requestType: RequestType.post,
    path: 'path',
    body: {'id': id, 'title': title, 'description': description},
  ).chainEither(RepositoryUtils.checkStatusCode).chainEither((response) {
    return Either.fromPredicate(
      response.data['id'] != null,
      (_) => true,
      (_) => APIFailure(),
    );
  });

  @override
  TaskEither<Failure, bool> delete{{name.pascalCase()}}(int id) {
    return userApiClient.request(requestType: RequestType.delete, path: 'path')
        .chainEither(RepositoryUtils.checkStatusCode)
        .chainEither(
          (response) => Either.fromPredicate(
            response.data['delete{{name.pascalCase()}}'] != null,
            (r) => true,
            (r) => APIFailure(),
          ),
        );
  }

  @override
  TaskEither<Failure,{{name.pascalCase()}}ResponseModel> get{{name.pascalCase()}}Details(int id) =>
      userApiClient.request(path: 'path', body: {'id': id})
          .chainEither(RepositoryUtils.checkStatusCode)
          .chainEither(
            (response) => RepositoryUtils.mapToModel(
              () => {{name.pascalCase()}}ResponseModel.fromJson(
                response.data['{{name.camelCase()}}'] as Map<String, dynamic>,
              ),
            ),
          );
}

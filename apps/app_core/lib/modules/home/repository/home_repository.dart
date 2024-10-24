// ignore_for_file: one_member_abstracts

import 'package:api_client/api_client.dart';
import 'package:app_core/core/data/repository-utils/repository_utils.dart';
import 'package:app_core/modules/home/model/home_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

/// This is the abstract representation of the HomeRepository
abstract class IHomeRepository {
  TaskEither<Failure, HomeModel> getNowPlayingMovies(String path);
}

/// This repository contains the implementation for [IHomeRepository]
class HomeRepository implements IHomeRepository {
  @override
  TaskEither<Failure, HomeModel> getNowPlayingMovies(String path) =>
      makefetchMoviesRequest(path).chainEither(RepositoryUtils.checkStatusCode).chainEither(
            (r) => RepositoryUtils.mapToModel(
              () => HomeModel.fromMap(r.data as Map<String,dynamic>),
            ),
          );

  TaskEither<Failure, Response> makefetchMoviesRequest(String path) =>
      RestApiClient.request(
        path: path,
      );
}

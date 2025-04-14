// ignore_for_file: one_member_abstracts

import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/api_endpoints.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/repository-utils/repository_utils.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_core/modules/home/model/post_response_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IHomeRepository {
  TaskEither<Failure, List<PostResponseModel>> fetchPostData({
    required int page,
    required int limit,
  });

  TaskEither<Failure, bool> setPlayerId(String playerId);
}

class HomeRepository implements IHomeRepository {
  @override
  TaskEither<Failure, List<PostResponseModel>> fetchPostData({
    required int page,
    required int limit,
  }) {
    return makefetchPostsRequest(page, limit)
        .chainEither(RepositoryUtils.checkStatusCode)
        .chainEither(
          (response) => RepositoryUtils.mapToModel(() {
            // ignore: prefer_final_locals
            var postList = <PostResponseModel>[];
            for (final postModel in response.data as List<dynamic>) {
              postList.add(
                PostResponseModel.fromJson(postModel as Map<String, dynamic>),
              );
            }
            return postList;
          }),
        );
  }

  TaskEither<Failure, Response> makefetchPostsRequest(int page, int limit) {
    return baseApiClient.request(
      path: ApiEndpoints.posts,
      queryParameters: {'_page': page, '_limit': limit},
    );
  }

  @override
  TaskEither<Failure, bool> setPlayerId(String playerID) =>
      getIt<IHiveService>()
          .setPlayerId(playerID)
          .flatMap((r) => _sendPlayerIdToServer(playerID).map((r) => true));

  /// Make API call to send the player ID to the server
  TaskEither<Failure, Response> _sendPlayerIdToServer(String playerID) {
    return userApiClient.request(
      path: 'Endpoint',
      queryParameters: {'playerId': playerID},
    );
  }
}

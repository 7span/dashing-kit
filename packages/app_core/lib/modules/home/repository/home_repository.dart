// ignore_for_file: one_member_abstracts

import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/repository-utils/repository_utils.dart';
import 'package:app_core/modules/home/entity/home_entity.dart';
import 'package:app_core/modules/home/model/home_model.dart';
import 'package:fpdart/fpdart.dart';

/// This is the abstract representation of the HomeRepository
abstract interface class IHomeRepository {
  /// This functions returns TaskEither. In this, Task is indicating that this function
  /// is returning Future and Either is indicating that the function can either
  /// successfully return a value or return a Failure Object.
  TaskEither<Failure, HomeEntity> getHomeScreenData(int campaignId);
}

/// This repository contains the implementation for [IHomeRepository]
class HomeRepository implements IHomeRepository {
  @override
  TaskEither<Failure, HomeEntity> getHomeScreenData(int campaignId) => mappingRequest(campaignId);

  /// This mapping request function is basically a wrapper around all of the function
  ///  that makes API requests and handles the validation logic and Failure handling
  TaskEither<Failure, HomeEntity> mappingRequest(int campaignId) =>
      makefetchPostsRequest(campaignId).chainEither(
        (r) {
          return RepositoryUtils.mapToModel(() => HomeData.fromJson(r)).map(
            (model) {
              return HomeEntity(reminderEntity: model.reminders?.data);
            },
          );
        },
      );

  TaskEither<Failure, Map<String, dynamic>> makefetchPostsRequest(int campaignId) =>
      closeApiClient.request(
        request: 'Assets.graphql.getHomeData',
        variables: {
          'page': 1,
          'ticketsAndRemindersCount': 4,
          'quickReplyCount': 2,
          'campaignId': campaignId,
        },
      );
}

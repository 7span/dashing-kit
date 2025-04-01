// ignore_for_file: one_member_abstracts

import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/api_endpoints.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

abstract class IChangePasswordRepository {
  TaskEither<Failure, Unit> changePassword({required String newPassword});
}

class ChangePasswordRepository implements IChangePasswordRepository {
  @override
  TaskEither<Failure, Unit> changePassword({required String newPassword}) =>
      _updatePasswordRequest(
        newPassword,
      ).flatMap((r) => TaskEither.right(unit));

  TaskEither<Failure, Response> _updatePasswordRequest(String newPassword) =>
      getIt<IHiveService>().getUserData().fold(
        (l) => TaskEither.left(APIFailure()),
        (r) => RestApiClient.request(
          requestType: RequestType.put,
          path: '${ApiEndpoints.profile}/${r.first.id}',
          body: {'id': r.first.id, 'password': newPassword},
        ),
      );
}

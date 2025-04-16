// ignore_for_file: require_trailing_commas
import 'dart:io';
import 'dart:math';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/api_endpoints.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/models/user_model.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_notification_service/notification_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

abstract interface class IProfileRepository {
  TaskEither<Failure, UserModel> fetchProfileDetails();

  TaskEither<Failure, Unit> editProfile({required UserModel userModel});

  TaskEither<Failure, String> editProfileImage(File imageFile);

  TaskEither<Failure, bool> deleteUser();

  TaskEither<Failure, Unit> changePassword({required String newPassword});
}

class ProfileRepository implements IProfileRepository {
  @override
  TaskEither<Failure, UserModel> fetchProfileDetails() => _makeProfileRequest(
    requestType: RequestType.get,
  ).chainEither(RepositoryUtils.checkStatusCode).flatMap((r) {
    return TaskEither.tryCatch(() async {
      // UserModel.fromMap(
      //   response.data['data'] as Map<String, dynamic>,
      // ),
      // API response : {id: 2, name: fuchsia rose, year: 2001, color: #C74375, pantone_value: 17-2031}
      return UserModel(
        name: 'Travish',
        email: 'travish@gmail.com',
        id: 21,
        profilePicUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0dmMkOgkOZvSJirdzzW7zcKnBmvfrIe_ghg&s',
      );
    }, (error, stackTrace) => APIFailure());
  });

  @override
  TaskEither<Failure, Unit> editProfile({required UserModel userModel}) =>
      _makeProfileRequest(
            requestType: RequestType.put,
            body: {
              'name': userModel.name,
              'id': userModel.id,
              'image_url': userModel.profilePicUrl,
            },
          )
          .chainEither(RepositoryUtils.checkStatusCode)
          .flatMap(
            (response) => getIt<IHiveService>().setUserData(
              UserModel(
                name: userModel.name,
                email: userModel.email,
                id: userModel.id,
                profilePicUrl: userModel.profilePicUrl,
              ),
            ),
          );

  /// since we are using dummpy api it gives different user id while sign-up and making profile api.
  /// Therefore we are not using the same id stored in Hive.
  TaskEither<Failure, Response> _makeProfileRequest({
    required RequestType requestType,
    Object? body,
  }) => getIt<IHiveService>().getUserData().fold(
    (l) => TaskEither.left(APIFailure()),
    (r) => userApiClient.request(
      requestType: requestType,
      // path: '${ApiEndpoints.profile}/${r.first.id}',
      path: '${ApiEndpoints.profile}/${2}',
      body: body,
    ),
  );

  @override
  TaskEither<Failure, String> editProfileImage(File imageFile) =>
  /// call Edit profile image API
  TaskEither.tryCatch(
    () async => Random().nextInt(100).toString(),
    (error, stackTrace) => APIFailure(),
  );

  TaskEither<Failure, Unit> _clearHiveData() => TaskEither.tryCatch(
    () => getIt<IHiveService>().clearData().run(),
    (error, stackTrace) => APIFailure(),
  );

  @override
  TaskEither<Failure, bool> deleteUser() => _makeDeleteUserRequest().flatMap(
    (_) => _clearHiveData().flatMap((r) {
      getIt<NotificationServiceInterface>().logout();
      return TaskEither<Failure, bool>.of(true);
    }),
  );
  TaskEither<Failure, Response>
  _makeDeleteUserRequest() => _getNotificationId().flatMap(
    (playerID) => userApiClient.request(
      requestType: RequestType.delete,

      /// You have to pass [playerID] as query parameter, while calling logout api
      /// Mock api returns different id in response of authentication everytime.
      /// Since Hive will store those same different ids, this api will not work.
      path: ApiEndpoints.logout,
    ),
  );

  TaskEither<Failure, String> _getNotificationId() => TaskEither.tryCatch(() {
    return getIt<NotificationServiceInterface>()
        .getNotificationSubscriptionId();
  }, APIFailure.new);

  @override
  TaskEither<Failure, Unit> changePassword({required String newPassword}) =>
      _updatePasswordRequest(newPassword)
          .chainEither(RepositoryUtils.checkStatusCode)
          .flatMap((r) => TaskEither.right(unit));

  TaskEither<Failure, Response> _updatePasswordRequest(String newPassword) =>
      getIt<IHiveService>().getUserData().fold(
        (l) => TaskEither.left(APIFailure()),
        (r) => userApiClient.request(
          requestType: RequestType.put,
          path: '${ApiEndpoints.profile}/${r!.id}',
          body: {'id': r.id, 'password': newPassword},
        ),
      );
}

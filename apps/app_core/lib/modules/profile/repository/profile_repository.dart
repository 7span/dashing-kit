// ignore_for_file: require_trailing_commas
import 'dart:io';
import 'dart:math';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/api_endpoints.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/models/user_model.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_ui/app_ui.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

abstract interface class IProfileRepository {
  TaskEither<Failure, UserModel> fetchProfileDetails();

  TaskEither<Failure, Response> editProfile({
    required String? name,
    required String? imageURL,
  });

  TaskEither<Failure, String> editProfileImage(File imageFile);
}

class ProfileRepository implements IProfileRepository {
  @override
  TaskEither<Failure, UserModel> fetchProfileDetails() {
    return makeProfileRequest(
      requestType: RequestType.get,
    ).chainEither((response) {
      return Either.right(
        // UserModel.fromMap(
        //   response.data['data'] as Map<String, dynamic>,
        // ),
        // API response : {id: 2, name: fuchsia rose, year: 2001, color: #C74375, pantone_value: 17-2031}
        UserModel(
          name: 'Travish',
          email: 'travish@gmail.com',
          id: 21,
          profilePicUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0dmMkOgkOZvSJirdzzW7zcKnBmvfrIe_ghg&s',
        ),
      );
    });
  }

  @override
  TaskEither<Failure, Response> editProfile({
    required String? name,
    required String? imageURL,
  }) {
    return makeProfileRequest(
      requestType: RequestType.put,
      body: {'name': name, 'image_url': imageURL},
    ).chainEither(Either.right);
  }

  /// since we are using dummpy api it gives different user id while sign-up and making profile api.
  /// Therefore we are not using the same id stored in Hive.
  TaskEither<Failure, Response> makeProfileRequest({
    required RequestType requestType,
    Object? body,
  }) {
    final getUserDataFromHive = getIt<IHiveService>().getUserData();
    return getUserDataFromHive.fold(
      (l) => TaskEither.left(APIFailure()),
      (r) => RestApiClient.request(
        requestType: requestType,
        // path: '$ApiEndpoints.profile/${r.first.id}',
        path: '$ApiEndpoints.profile/${2}',
        body: body,
      ),
    );
  }

  @override
  TaskEither<Failure, String> editProfileImage(File imageFile) {
    /// call Edit profile image API
    return TaskEither.tryCatch(() async {
      final randomInt = Random().nextInt(
        100,
      ); // Generates a random integer from 0 to 99
      await Future.delayed(2.seconds);
      return randomInt.toString();
    }, (error, stackTrace) => APIFailure());
  }
}

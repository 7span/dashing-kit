import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/api_endpoints.dart';
import 'package:app_core/core/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

abstract interface class IProfileRepository {
  TaskEither<Failure, UserModel> fetchProfileDetails();
}

class ProfileRepository implements IProfileRepository {
  @override
  TaskEither<Failure, UserModel> fetchProfileDetails() {
    return makeProfileDetailRequest().chainEither(
      (response) => Either.right(
        UserModel.fromMap(
          response.data['data'] as Map<String, dynamic>,
        ),
      ),
    );
  }

  TaskEither<Failure, Response> makeProfileDetailRequest() {
    return RestApiClient.request(path: ApiEndpoints.profile);
  }
}

import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/api_endpoints.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/models/user_model.dart';
import 'package:app_core/core/data/repository-utils/repository_utils.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_core/modules/auth/model/auth_request_model.dart';
import 'package:app_core/modules/auth/model/auth_response_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

/// This repository contains the contract for login and logout function
abstract interface class IAuthRepository {
  TaskEither<Failure, AuthResponseModel> login(
    AuthRequestModel authRequestModel,
  );

  TaskEither<Failure, AuthResponseModel> signup(
    AuthRequestModel authRequestModel,
  );

  TaskEither<Failure, bool> logout();

  ///SOCIAL-LOGIN
  TaskEither<Failure, AuthResponseModel> socialLogin({
    required AuthRequestModel requestModel,
  });
}

/// This class contains the implementation for login and logout functions.
// ignore: comment_references
/// This repository connects with [IAuthService] for setting the data of the user
/// that is given by the API Response
class AuthRepository implements IAuthRepository {
  const AuthRepository();

  @override
  TaskEither<Failure, AuthResponseModel> login(
    AuthRequestModel authRequestModel,
  ) => makeLoginRequest(authRequestModel)
      .chainEither(RepositoryUtils.checkStatusCode)
      .chainEither(
        (r) => RepositoryUtils.mapToModel(
          () => AuthResponseModel.fromMap(
            r.data as Map<String, dynamic>,
          ),
        ),
      );

  TaskEither<Failure, Response> makeLoginRequest(
    AuthRequestModel authRequestModel,
  ) => RestApiClient.request(
    requestType: RequestType.post,
    path: ApiEndpoints.login,
    body: authRequestModel.toMap(),
    options: Options(headers: {'Content-Type': 'application/json'}),
  );

  TaskEither<Failure, AuthResponseModel> saveUserToLocal(
    AuthResponseModel authResponseModel,
  ) {
    /// Sets Access Token received by api success.
    RestApiClient.setAuthorizationToken(
      authResponseModel.authToken ?? '',
    );
    getIt<IHiveService>().setAccessToken(
      authResponseModel.authToken ?? '',
    );

    /// To save UserDetailsModel in Local Hive

    final updatedModel = UserModel(
      name: 'user name',
      email: 'user email',
      profilePicUrl: '',
      id: int.parse(authResponseModel.id.toString()),
    );
    getIt<IHiveService>().setUserData(updatedModel).run();

    return TaskEither.right(authResponseModel);
  }

  @override
  TaskEither<Failure, AuthResponseModel> signup(
    AuthRequestModel authRequestModel,
  ) => makeSignUpRequest(authRequestModel)
      .chainEither(RepositoryUtils.checkStatusCode)
      .chainEither(
        (r) => RepositoryUtils.mapToModel(
          () => AuthResponseModel.fromMap(
            r.data as Map<String, dynamic>,
          ),
        ),
      )
      .flatMap(saveUserToLocal);

  TaskEither<Failure, Response> makeSignUpRequest(
    AuthRequestModel authRequestModel,
  ) => RestApiClient.request(
    requestType: RequestType.post,
    path: ApiEndpoints.signup,
    body: authRequestModel.toMap(),
    options: Options(headers: {'Content-Type': 'application/json'}),
  );

  @override
  TaskEither<Failure, bool> logout() =>
      makeLogoutRequest().flatMap((response) {
        return TaskEither<Failure, bool>.tryCatch(() async {
          await getIt<IHiveService>().clearData().run();
          return true;
        }, (error, _) => APIFailure(),);
      });

  TaskEither<Failure, Response> makeLogoutRequest() {
    return RestApiClient.request(
      requestType: RequestType.delete,
      path: ApiEndpoints.logout,
      // body: requestModel.toSocialSignInMap(),
    );
  }

  ///SOCIAL LOGIN
  @override
  TaskEither<Failure, AuthResponseModel> socialLogin({
    required AuthRequestModel requestModel,
  }) => mappingSocialLoginRequest(requestModel: requestModel);

  TaskEither<Failure, AuthResponseModel> mappingSocialLoginRequest({
    required AuthRequestModel requestModel,
  }) => makeSocialLoginRequest(requestModel: requestModel)
      .chainEither(RepositoryUtils.checkStatusCode)
      .chainEither(
        (response) => RepositoryUtils.mapToModel<AuthResponseModel>(
          () => AuthResponseModel.fromMap(
            response.data as Map<String, dynamic>,
          ),
        ),
      )
      .flatMap(saveUserToLocal);

  TaskEither<Failure, Response> makeSocialLoginRequest({
    required AuthRequestModel requestModel,
  }) {
    return RestApiClient.request(
      requestType: RequestType.post,
      path: ApiEndpoints.socialLogin,
      body: requestModel.toSocialSignInMap(),
    );
  }
}

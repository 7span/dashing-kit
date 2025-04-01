// ignore_for_file: require_trailing_commas
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
  TaskEither<Failure, Unit> login(AuthRequestModel authRequestModel);

  TaskEither<Failure, Unit> signup(AuthRequestModel authRequestModel);

  TaskEither<Failure, bool> logout();

  TaskEither<Failure, Unit> socialLogin({
    required AuthRequestModel requestModel,
  });
}

// ignore: comment_references
/// This repository connects with [IAuthService] for setting the data of the user
/// that is given by the API Response
class AuthRepository implements IAuthRepository {
  const AuthRepository();

  @override
  TaskEither<Failure, Unit> login(
    AuthRequestModel authRequestModel,
  ) => makeLoginRequest(authRequestModel)
      .chainEither(RepositoryUtils.checkStatusCode)
      .chainEither(
        (response) => RepositoryUtils.mapToModel(() {
          return AuthResponseModel.fromMap(
            response.data as Map<String, dynamic>,
          );
        }),
      )
      .map((model) {
        setAuthorizationHeader(model.id);
        return model;
      })
      .flatMap(saveUserToLocal);

  TaskEither<Failure, Response> makeLoginRequest(
    AuthRequestModel authRequestModel,
  ) => RestApiClient.request(
    requestType: RequestType.post,
    path: ApiEndpoints.login,
    body: authRequestModel.toMap(),
    options: Options(headers: {'Content-Type': 'application/json'}),
  );

  TaskEither<Failure, Unit> saveUserToLocal(
    AuthResponseModel authResponseModel,
  ) => getIt<IHiveService>()
      .setAccessToken(authResponseModel.id)
      .flatMap(
        (r) => getIt<IHiveService>().setUserData(
          UserModel(
            name: 'user name',
            email: 'user email',
            profilePicUrl: '',
            id: int.parse(authResponseModel.id),
          ),
        ),
      );

  @override
  TaskEither<Failure, Unit> signup(
    AuthRequestModel authRequestModel,
  ) => makeSignUpRequest(authRequestModel)
      .chainEither(RepositoryUtils.checkStatusCode)
      .chainEither(
        (r) => RepositoryUtils.mapToModel(() {
          /// as we are not getting proper response from mock api, we are directly returning AuthResponseModel
          /// response : { "id": 4,"token": "QpwL5tke4Pnpja7X4" }
          /// uncomment this code while api call integration
          //   return AuthResponseModel.fromMap(
          //   r.data as Map<String, dynamic>,
          // );
          return AuthResponseModel(
            email: 'eve.holt@reqres.in',
            id: (r.data as Map<String, dynamic>)['id'].toString(),
          );
        }),
      )
      .map((model) {
        setAuthorizationHeader(model.id);
        return model;
      })
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
        }, (error, _) => APIFailure());
      });

  TaskEither<Failure, Response>
  makeLogoutRequest() => getIt<IHiveService>().getUserData().fold(
    (l) => TaskEither.left(APIFailure()),
    (r) => RestApiClient.request(
      requestType: RequestType.delete,

      /// Mock api returns different id in response of authentication everytime.
      /// Since Hive will store those same different ids, this api will not work.
      path: '${ApiEndpoints.logout}/${r.first.id}',
    ),
  );

  @override
  TaskEither<Failure, Unit> socialLogin({
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
      .map((model) {
        setAuthorizationHeader(model.id);
        return model;
      })
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

  TaskEither<Failure, Unit> setAuthorizationHeader(String token) =>
      Either.tryCatch(
        () {
          RestApiClient.setAuthorizationToken(token);
          return unit;
        },
        (error, stackTrace) => UserTokenSaveFailure(),
      ).toTaskEither();
}

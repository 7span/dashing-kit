import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/app_constants.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/core/data/repository-utils/repository_utils.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_core/modules/auth/model/auth_request_model.dart';
import 'package:app_core/modules/auth/model/auth_response_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:fpdart/fpdart.dart';

/// This repository contains the contract for login and logout function
abstract interface class IAuthRepository {
  TaskEither<Failure, AuthResponseModel> login(
    AuthRequestModel authRequestModel,
  );

  TaskEither<Failure, AuthResponseModel> signup(
    AuthRequestModel authRequestModel,
  );

  Future<bool> logout();

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

  static final firebaseAuthInstance = FirebaseAuth.instance;

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
      )
      .flatMap(saveUserToLocal);

  TaskEither<Failure, Response> makeLoginRequest(
    AuthRequestModel authRequestModel,
  ) => RestApiClient.request(
    requestType: RequestType.post,
    path: AppConstants.login,
    body: authRequestModel.toMap(),
    options: Options(headers: {'Content-Type': 'application/json'}),
  );

  TaskEither<Failure, AuthResponseModel> saveUserToLocal(
    AuthResponseModel authResponseModel,
  ) {
    /// Sets Access Token received by api success.
    RestApiClient.setAuthorizationToken(authResponseModel.authToken!);

    /// To save UserDetailsModel in Local Hive

    /// final updatedModel = UserModel(
    ///  name: authResponseModel.userDetails?.firstName ?? '',
    ///   email: authResponseModel.userDetails?.email ?? '',
    ///   profilePicUrl: '',
    ///   id: authResponseModel.userDetails?.id ?? 0,
    /// );
    /// getIt<IHiveService>().setUserData(updatedModel).run();

    getIt<IHiveService>().setAccessToken(
      authResponseModel.authToken!,
    );
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
      );

  TaskEither<Failure, Response> makeSignUpRequest(
    AuthRequestModel authRequestModel,
  ) => RestApiClient.request(
    requestType: RequestType.post,
    path: AppConstants.signup,
    body: authRequestModel.toMap(),
    options: Options(headers: {'Content-Type': 'application/json'}),
  );

  @override
  Future<bool> logout() async {
    try {
      await Future<void>.delayed(const Duration(seconds: 2));

      ///Use this ifSignInWithGoogle is Integrated
      await firebaseAuthInstance.signOut();
      //clear auth tokens from the local storage
      await getIt<IHiveService>().clearData().run();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
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
      path: AppConstants.socialLogin,
      body: requestModel.toSocialSignInMap(),
    );
  }
}

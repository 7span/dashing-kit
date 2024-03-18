import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:fpdart/fpdart.dart';

import 'package:app_core/core/data/models/user_model.dart';
import 'package:app_core/core/data/services/hive.service.dart';

/// This repository contains the contract for login and logout function
abstract interface class IAuthRepository {
  TaskEither<Failure, Unit> login(String email, String password);

  Future<bool> logout();
}

/// This class contains the implementation for login and logout functions.
// ignore: comment_references
/// This repository connects with [IAuthService] for setting the data of the user
/// that is given by the API Response
class AuthRepository implements IAuthRepository {
  const AuthRepository();

  @override
  TaskEither<Failure, Unit> login(
    String email,
    String password,
  ) {
    final userModel = UserModel(
      name: 'cavin',
      email: 'demo@gmail.com',
      id: 1,
      profilePicUrl: 'profilePicUrl',
    );
    return getIt<IHiveService>()
        .setAccessToken('uniquetoken')
        .flatMap((_) => getIt<IHiveService>().setUserData(userModel));
  }

  @override
  Future<bool> logout() async {
    try {
      await Future<void>.delayed(const Duration(seconds: 2));

      //clear auth tokens from the local storage
      await getIt<IHiveService>().clearData().run();
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}

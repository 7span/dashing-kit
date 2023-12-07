import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:app_core/app/enum.dart';
import 'package:app_core/core/data/models/user_model.dart';
import 'package:app_core/core/domain/failure.dart';

/// This class is used for creating the contract for setting and getting the
/// user data, with the help of this class. Anyone can create their own
/// implementation for setting and getting the userdata.
abstract interface class IAuthService {
  /// This function is used for initializing the underlying database implementation for
  /// getting and setting the user data
  Future<Unit> init();

  /// This function is used for setting the access token that a user gets from
  /// the API and store it in the local database.
  TaskEither<Failure, Unit> setAccessToken(String accessToken);
  TaskEither<Failure, Unit> setUserData(UserModel userModel);
  Option<String> getAccessToken();
  Task<Unit> clearData();
  Either<Failure, List<UserModel>> getUserData();
}

final class _Keys {
  static const accessToken = 'accessToken';
}

/// This class is the implementation for [IAuthService]. In this implementation,
/// we're using Hive database because it provides a lot more features and functionalities
/// than other databases.
///
/// This class contains implementations for getting and setting userdata, tokens along with
/// proper error handling.
final class AuthService implements IAuthService {
  const AuthService();

  @override
  Future<Unit> init() async {
    log('Hive Init Called');

    /// initialize HIVE
    await Hive.initFlutter();

    /// for storing user data one user logs in
    Hive.registerAdapter(UserModelAdapter(), override: true);
    await Hive.openBox<UserModel>(HiveKeys.userData.value);

    /// for saving token separately
    await Hive.openBox<String>(HiveKeys.userToken.value);
    return unit;
  }

  @override
  Option<String> getAccessToken() {
    final box = Hive.box<String>(HiveKeys.userToken.value);
    final key = box.get(_Keys.accessToken);
    return key != null ? some(key) : none();
  }

  @override
  TaskEither<Failure, Unit> setAccessToken(String value) =>
      TaskEither<Failure, Unit>.tryCatch(
        () async {
          final box = Hive.box<String>(HiveKeys.userToken.value);
          await box.put(_Keys.accessToken, value);
          return unit;
        },
        (error, stackTrace) => UserTokenSaveFailure(
          error: error,
          stackTrace: stackTrace,
        ),
      );

  @override
  TaskEither<Failure, Unit> setUserData(UserModel userModel) =>
      TaskEither.tryCatch(
        () async {
          final box = Hive.box<UserModel>(HiveKeys.userData.value);
          await box.add(userModel);
          await userModel.save();
          return unit;
        },
        (error, stackTrace) => UserSaveFailure(
          error: error,
          stackTrace: stackTrace,
        ),
      );

  @override
  Either<Failure, List<UserModel>> getUserData() => Either.tryCatch(
        () {
          final box = Hive.box<UserModel>(HiveKeys.userData.value);
          final data = box.values;
          return data.toList();
        },
        (error, stackStrace) => HiveFailure(),
      );

  @override
  Task<Unit> clearData() => Task(
        () async {
          await Hive.deleteFromDisk();

          /// To re-open the boxes after closing it
          await init();
          return unit;
        },
      );
}

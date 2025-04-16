import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/enum.dart';
import 'package:app_core/core/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// This class is used for creating the contract for setting and getting the
/// user data, with the help of this class. Anyone can create their own
/// implementation for setting and getting the userdata.
abstract interface class IHiveService {
  /// This function is used for initializing the underlying database implementation for
  /// getting and setting the user data
  Future<Unit> init();

  TaskEither<Failure, Unit> setUserData(UserModel userModel);

  Task<Unit> clearData();

  Either<Failure, UserModel> getUserData();

  TaskEither<Failure, Unit> setPlayerId(String playerId);

  Option<String> getPlayerId();
}

final class _Keys {
  static const playerId = 'playerId';
}

/// This class is the implementation for [IHiveService]. In this implementation,
/// we're using Hive database because it provides a lot more features and functionalities
/// than other databases.
///
/// This class contains implementations for getting and setting userdata, tokens along with
/// proper error handling.
final class HiveService implements IHiveService {
  const HiveService();

  @override
  Future<Unit> init() async {
    log('Hive Init Called');

    /// initialize HIVE
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());

    await Hive.openBox<UserModel>(HiveKeys.userData.value);
    await Hive.openBox<String>(HiveKeys.userPlayerId.value);
    return unit;
  }

  @override
  TaskEither<Failure, Unit> setUserData(UserModel userModel) =>
      TaskEither.tryCatch(
        () async {
          final box = Hive.box<UserModel>(HiveKeys.userData.value);
          await box.add(userModel);
          await userModel.save();
          return unit;
        },
        (error, stackTrace) =>
            UserSaveFailure(error: error, stackTrace: stackTrace),
      );

  @override
  Either<Failure, UserModel> getUserData() => Either.tryCatch(
    () {
      final box = Hive.box<UserModel>(HiveKeys.userData.value);
      return box.values.toList().first;
    },
    (error, stackStrace) {
      return HiveFailure();
    },
  );

  @override
  Task<Unit> clearData() => Task(() async {
    await Hive.box<UserModel>(HiveKeys.userData.value).clear();
    await Hive.box<String>(HiveKeys.userPlayerId.value).clear();
    return unit;
  });

  @override
  Option<String> getPlayerId() {
    final box = Hive.box<String>(HiveKeys.userPlayerId.value);
    final key = box.get(_Keys.playerId);
    return key != null ? some(key) : none();
  }

  @override
  TaskEither<Failure, Unit> setPlayerId(String playerId) =>
      TaskEither<Failure, Unit>.tryCatch(
        () async {
          final box = Hive.box<String>(HiveKeys.userPlayerId.value);
          await box.put(_Keys.playerId, playerId);
          return unit;
        },
        (error, stackTrace) => UserTokenSaveFailure(
          error: error,
          stackTrace: stackTrace,
        ),
      );
}

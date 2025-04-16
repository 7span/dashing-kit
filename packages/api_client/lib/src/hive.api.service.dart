import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'hive_keys.dart';

final class _Keys {
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';
}

/// This class is the implementation for [HiveApiService]. In this implementation,
/// we're using Hive database for Token storage functionalities only.
///
/// This class contains implementations for getting and setting [tokens(refreshToken, accessToken)].
///
/// To access Tokens in your project module
///
/// It provides methods to fetch authentication tokens(access and refresh)
///and clear them during logout.
///
/// Retrieves the stored refresh token.
///
/// Example usage:
/// ```dart
/// String refreshToken = HiveApiService.instance.getRefreshToken();
/// ```
///
/// Retrieves the stored access token.
///
/// Example usage:
/// ```dart
/// String accessToken = HiveApiService.instance.getAccessToken();
/// ```
///
/// Clears both access and refresh tokens (e.g. used during logout).
///
/// Example usage:
/// ```dart
/// HiveApiService.instance.clearTokens();
/// ```
class HiveApiService {
  static final HiveApiService instance = HiveApiService._internal();

  const HiveApiService._internal();

  Future<Unit> init() async {
    log('HiveApiService Init Called');

    /// initialize HIVE
    await Hive.initFlutter();

    /// for saving token separately
    await Hive.openBox<String>(HiveKeys.userToken.value);

    await Hive.openBox<String>(HiveKeys.userRefreshToken.value);
    return unit;
  }

  Option<String> getAccessToken() {
    final box = Hive.box<String>(HiveKeys.userToken.value);
    final key = box.get(_Keys.accessToken);
    return key != null ? some(key) : none();
  }

  Option<String> getRefreshToken() {
    final box = Hive.box<String>(HiveKeys.userRefreshToken.value);
    final key = box.get(_Keys.refreshToken);
    return key != null ? some(key) : none();
  }

  Task<Unit> clearTokens() => Task(() async {
    await Hive.box<String>(HiveKeys.userToken.value).clear();
    await Hive.box<String>(HiveKeys.userRefreshToken.value).clear();
    return unit;
  });
}

class UserTokenSaveService {
  static final UserTokenSaveService instance =
      UserTokenSaveService._internal();

  const UserTokenSaveService._internal();

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

  TaskEither<Failure, Unit> setRefreshToken(
    String value,
  ) => TaskEither<Failure, Unit>.tryCatch(
    () async {
      final box = Hive.box<String>(HiveKeys.userRefreshToken.value);
      await box.put(_Keys.refreshToken, value);
      return unit;
    },
    (error, stackTrace) =>
        UserTokenSaveFailure(error: error, stackTrace: stackTrace),
  );
}

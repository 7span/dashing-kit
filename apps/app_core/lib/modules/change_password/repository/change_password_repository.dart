// ignore_for_file: one_member_abstracts

import 'package:api_client/api_client.dart';
import 'package:fpdart/fpdart.dart';

abstract class IChangePasswordRepository {
  TaskEither<Failure, Unit> changePassword();
}

class ChangePasswordRepository implements IChangePasswordRepository {
  @override
  TaskEither<Failure, Unit> changePassword() {
    return TaskEither.tryCatch(
      _updatePassword,
      APIFailure.new,
    );
  }

  Future<Unit> _updatePassword() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return unit;
  }
}

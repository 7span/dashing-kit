import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';

class LoginFormBloc extends FormBloc<String, String> {
  LoginFormBloc({required IAuthRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository {
    addFieldBlocs(fieldBlocs: [email, password]);
  }
  final IAuthRepository _authenticationRepository;

  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final password =
      TextFieldBloc(validators: [FieldBlocValidators.passwordMin6Chars]);

  @override
  FutureOr<void> onSubmitting() async {
    await Future<void>.delayed(const Duration(seconds: 3));

    final loginEither = await _authenticationRepository
        .login(
          email.value,
          password.value,
        )
        .run();
    loginEither.fold(
      (failure) => emitFailure(),
      (success) => emitSuccess(),
    );
  }
}

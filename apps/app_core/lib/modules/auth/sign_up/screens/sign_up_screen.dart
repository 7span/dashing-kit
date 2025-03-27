import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/domain/validators/confirm_password_validator.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/auth/sign_up/bloc/sign_up_bloc.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

@RoutePage()
class SignUpPage extends StatelessWidget implements AutoRouteWrapper {
  const SignUpPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => const AuthRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => SignUpBloc(
                  authenticationRepository: RepositoryProvider.of<AuthRepository>(context),
                ),
          ),
        ],
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(),
      body: BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) async {
          if (state.status.isFailure) {
            showAppSnackbar(
              context,
              '', //context.t.invalid_password_username,
              type: SnackbarType.failed,
            );
          } else if (state.status.isSuccess) {
            showAppSnackbar(context, context.t.sign_up_successful);
            await context.router.replaceAll([const HomeRoute()]);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Insets.large24),
          child: Column(
            spacing: Insets.large24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SlideAndFadeAnimationWrapper(
                delay: 100,
                child: Center(child: FlutterLogo(size: 100)),
              ),
              SlideAndFadeAnimationWrapper(delay: 200, child: AppText.XL(text: context.t.sign_up)),
              SlideAndFadeAnimationWrapper(delay: 300, child: _NameInput()),
              SlideAndFadeAnimationWrapper(delay: 300, child: _EmailInput()),
              SlideAndFadeAnimationWrapper(delay: 400, child: _PasswordInput()),
              SlideAndFadeAnimationWrapper(delay: 400, child: _ConfirmPasswordInput()),
              const SlideAndFadeAnimationWrapper(delay: 600, child: _CreateAccountButton()),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AppTextField(
          initialValue: state.name.value,
          label: context.t.name,
          keyboardType: TextInputType.name,
          onChanged: (name) => context.read<SignUpBloc>().add(SignUpNameChanged(name)),
          errorText: state.name.displayError != null ? context.t.common_validation_name : null,
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AppTextField(
          initialValue: state.email.value,
          label: context.t.email,
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => context.read<SignUpBloc>().add(SignUpEmailChanged(email)),
          errorText: state.email.displayError != null ? context.t.common_validation_email : null,
          autofillHints: const [AutofillHints.email],
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AppTextField.password(
          initialValue: state.password.value,
          label: context.t.password,
          textInputAction: TextInputAction.done,
          onChanged: (password) => context.read<SignUpBloc>().add(SignUpPasswordChanged(password)),
          errorText:
              state.password.displayError != null ? context.t.common_validation_password : null,
          autofillHints: const [AutofillHints.password],
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return AppTextField.password(
          initialValue: state.confirmPassword.value,
          label: context.t.confirm_password,
          textInputAction: TextInputAction.done,
          onChanged:
              (password) => context.read<SignUpBloc>().add(
                SignUpConfirmPasswordChanged(
                  confirmPassword: password,
                  password: state.password.value,
                ),
              ),
          errorText:
              state.confirmPassword.error == ConfirmPasswordValidationError.invalid
                  ? context.t.common_validation_confirm_password
                  : null,
          autofillHints: const [AutofillHints.password],
        );
      },
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return AppButton(
          isLoading: state.status.isInProgress,
          text: context.t.sign_up,
          onPressed: () {
            TextInput.finishAutofillContext();
            context.read<SignUpBloc>().add(const SignUpSubmitted());
          },
          isExpanded: true,
        );
      },
    );
  }
}

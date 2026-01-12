import 'package:api_client/api_client.dart';
import 'package:app_core/core/domain/validators/confirm_password_validator.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/change_password/bloc/cubit/change_password_cubit.dart';
import 'package:app_core/modules/profile/repository/profile_repository.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChangePasswordScreen extends StatelessWidget implements AutoRouteWrapper {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listenWhen: (prev, current) => prev.apiStatus != current.apiStatus,
        listener: (_, state) async {
          if (state.apiStatus == ApiStatus.error) {
            showAppSnackbar(context, context.t.failed_to_update, type: SnackbarType.failed);
          } else if (state.apiStatus == ApiStatus.loaded) {
            showAppSnackbar(context, context.t.update_successful);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Insets.large24),
          child: Column(
            spacing: Insets.large24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // VSpace.xxlarge40(),
              const SlideAndFadeAnimationWrapper(
                delay: 100,
                child: Center(child: FlutterLogo(size: 100)),
              ),
              VSpace.xxlarge40(),
              SlideAndFadeAnimationWrapper(
                delay: 200,
                child: AppText.XL(text: context.t.change_password),
              ),
              SlideAndFadeAnimationWrapper(delay: 400, child: _PasswordInput()),
              SlideAndFadeAnimationWrapper(delay: 400, child: _ConfirmPasswordInput()),
              const SlideAndFadeAnimationWrapper(delay: 600, child: _CreateAccountButton()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<ProfileRepository>(
      create: (_) => ProfileRepository(),
      child: BlocProvider<ChangePasswordCubit>(
        lazy: false,
        create: (context) => ChangePasswordCubit(RepositoryProvider.of<ProfileRepository>(context)),
        child: this,
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (previous, current) => previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return AppTextField.password(
          initialValue: state.confirmPassword.value,
          label: context.t.confirm_password,
          textInputAction: TextInputAction.done,
          onChanged:
              (password) => context.read<ChangePasswordCubit>().onConfirmPasswordChange(
                confirmPassword: password,
                password: state.password.value,
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

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AppTextField.password(
          initialValue: state.password.value,
          label: context.t.password,
          textInputAction: TextInputAction.done,
          onChanged: (password) => context.read<ChangePasswordCubit>().onPasswordChange(password),

          errorText:
              state.password.displayError != null ? context.t.common_validation_password : null,
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
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return AppButton(
          isLoading: state.apiStatus == ApiStatus.loading,
          text: context.t.update,
          onPressed: () async {
            TextInput.finishAutofillContext();
            await context.read<ChangePasswordCubit>().onSubmitPassword();
          },
          isExpanded: true,
        );
      },
    );
  }
}

import 'package:app_core/core/domain/validators/confirm_password_validator.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/change_password/bloc/change_password_bloc.dart';
import 'package:app_core/modules/change_password/bloc/change_password_event.dart';
import 'package:app_core/modules/change_password/bloc/change_password_state.dart';
import 'package:app_core/modules/change_password/repository/change_password_repository.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

@RoutePage()
class ChangePasswordScreen extends StatelessWidget implements AutoRouteWrapper {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(),
      body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listenWhen: (prev, current) => prev.status != current.status,
        listener: (_, state) async {
          if (state.status.isFailure) {
            showAppSnackbar(context, context.t.failed_to_update, type: SnackbarType.failed);
          } else if (state.status.isSuccess) {
            showAppSnackbar(context, context.t.update_successful);
            await context.maybePop();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Insets.large24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace.xxxxlarge80(),
              VSpace.large24(),
              const SlideAndFadeAnimationWrapper(
                delay: 100,
                child: Center(child: FlutterLogo(size: 100)),
              ),
              VSpace.xxlarge40(),
              VSpace.large24(),
              SlideAndFadeAnimationWrapper(
                delay: 200,
                child: AppText.XL(text: context.t.update_password),
              ),
              VSpace.large24(),
              SlideAndFadeAnimationWrapper(delay: 400, child: _PasswordInput()),
              VSpace.large24(),
              SlideAndFadeAnimationWrapper(delay: 400, child: _ConfirmPasswordInput()),
              VSpace.large24(),
              const SlideAndFadeAnimationWrapper(delay: 600, child: _CreateAccountButton()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<ChangePasswordRepository>(
      create: (_) => ChangePasswordRepository(),
      child: BlocProvider<ChangePasswordBloc>(
        lazy: false,
        create:
            (context) => ChangePasswordBloc(
              repository: RepositoryProvider.of<ChangePasswordRepository>(context),
            ),
        child: this,
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) => previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return AppTextField.password(
          initialValue: state.confirmPassword.value,
          label: context.t.confirm_password,
          textInputAction: TextInputAction.done,
          onChanged:
              (password) => context.read<ChangePasswordBloc>().add(
                OnConfirmPasswordChangeEvent(
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

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AppTextField.password(
          initialValue: state.password.value,
          label: context.t.password,
          textInputAction: TextInputAction.done,
          onChanged:
              (password) => context.read<ChangePasswordBloc>().add(OnPasswordChangeEvent(password)),
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
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      builder: (context, state) {
        return AppButton(
          isLoading: state.status.isInProgress,
          text: context.t.update,
          onPressed: () {
            TextInput.finishAutofillContext();
            context.read<ChangePasswordBloc>().add(const OnSubmitPasswordEvent());
          },
          isExpanded: true,
        );
      },
    );
  }
}

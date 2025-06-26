import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

@RoutePage()
class ForgotPasswordPage extends StatelessWidget implements AutoRouteWrapper {
  const ForgotPasswordPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider(
      create: (context) => const AuthRepository(),
      child: BlocProvider(
        create: (context) => ForgotPasswordBloc(authenticationRepository: RepositoryProvider.of<AuthRepository>(context)),
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) async {
          if (state.status.isFailure) {
            showAppSnackbar(context, state.errorMessage);
          } else if (state.status.isSuccess) {
            showAppSnackbar(context, context.t.reset_password_mail_sent);
            await context.pushRoute(VerifyOTPRoute(emailAddress: state.email.value));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Insets.large24),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace.xxxlarge66(),
                SlideAndFadeAnimationWrapper(delay: 100, child: Center(child: Assets.images.logo.image(width: 100))),
                VSpace.large24(),
                SlideAndFadeAnimationWrapper(
                  delay: 200,
                  child: Center(child: AppText.xsSemiBold(text: context.t.welcome, fontSize: 16)),
                ),
                VSpace.large24(),
                SlideAndFadeAnimationWrapper(delay: 300, child: _EmailInput()),
                VSpace.xxlarge40(),
                const SlideAndFadeAnimationWrapper(delay: 500, child: _ForgotPasswordButton()),
                VSpace.large24(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AppTextField(
          textInputAction: TextInputAction.done,
          initialValue: state.email.value,
          label: context.t.email,
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => context.read<ForgotPasswordBloc>().add(ForgotPasswordEmailChanged(email)),
          errorText: state.email.displayError != null ? context.t.common_validation_email : null,
          autofillHints: const [AutofillHints.email],
        );
      },
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        return AppButton(
          isLoading: state.status.isInProgress,
          text: context.t.reset_password,
          onPressed: () {
            TextInput.finishAutofillContext();
            context.read<ForgotPasswordBloc>().add(const ForgotPasswordSubmitted());
          },
          isExpanded: true,
        );
      },
    );
  }
}

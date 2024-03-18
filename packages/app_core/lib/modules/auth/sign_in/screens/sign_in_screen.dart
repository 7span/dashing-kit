// ignore_for_file: unused_element

import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/sign_in/bloc/sign_in_bloc.dart';
import 'package:app_translations/app_translations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:formz/formz.dart';

@RoutePage()
class SignInPage extends StatefulWidget implements AutoRouteWrapper {
  const SignInPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => const AuthRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignInBloc(
              authenticationRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
        ],
        child: this,
      ),
    );
  }

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignInBloc, SignInState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) async {
          if (state.status.isFailure) {
            showAppSnackbar(
              context,
              'Invalid username or password',
              type: SnackbarType.failed,
            );
          } else if (state.status.isSuccess) {
            showAppSnackbar(
              context,
              context.t.sign_in_successful,
            );
            await context.replaceRoute(const BottomNavigationBarRoute());
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Insets.large24),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace.xxxxlarge80(),
                VSpace.large24(),
                const SlideAndFadeAnimationWrapper(
                  delay: 100,
                  child: FlutterLogo(size: 100),
                ),
                VSpace.xxlarge40(),
                VSpace.large24(),
                SlideAndFadeAnimationWrapper(
                  delay: 200,
                  child: AppText.XL(text: context.t.sign_in),
                ),
                VSpace.large24(),
                SlideAndFadeAnimationWrapper(
                  delay: 300,
                  child: _EmailInput(),
                ),
                VSpace.large24(),
                SlideAndFadeAnimationWrapper(
                  delay: 400,
                  child: _PasswordInput(),
                ),
                VSpace.medium16(),
                VSpace.xxlarge40(),
                const SlideAndFadeAnimationWrapper(
                  delay: 500,
                  child: _LoginButton(),
                ),
                VSpace.large24(),
                const SlideAndFadeAnimationWrapper(
                  delay: 600,
                  child: _CreateAccountButton(),
                ),
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
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AppTextField(
          initialValue: state.email.value,
          label: context.t.email,
          keyboardType: TextInputType.emailAddress,
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (username) => context.read<SignInBloc>().add(SignInEmailChanged(username)),
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
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AppTextField.password(
          initialValue: state.password.value,
          label: context.t.password,
          isObscureText: state.obscureText,
          key: const Key('loginForm_passwordInput_textField'),
          textInputAction: TextInputAction.done,
          onChanged: (password) => context.read<SignInBloc>().add(SignInEmailChanged(password)),
          errorText:
              state.password.displayError != null ? context.t.common_validation_password : null,
          autofillHints: const [AutofillHints.password],
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return AppButton(
          padding: EdgeInsets.zero,
          isLoading: state.status.isInProgress,
          text: context.t.sign_in,
          onPressed: () {
            TextInput.finishAutofillContext();
            context.read<SignInBloc>().add(const SignInSubmitted());
          },
          isExpanded: true,
        );
      },
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();
  @override
  Widget build(BuildContext context) {
    return AppButton(
      padding: EdgeInsets.zero,
      buttonType: ButtonType.outlined,
      textColor: context.colorScheme.primary500,
      backgroundColor: context.colorScheme.white,
      text: 'Sign Up',
      onPressed: () {},
      isExpanded: true,
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:fitness_app/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:fitness_app/app/routes/app_router.dart';
import 'package:fitness_app/app/theme/spacing.dart';
import 'package:fitness_app/core/data/services/auth.service.dart';
import 'package:fitness_app/core/presentation/widgets/app_button.dart';
import 'package:fitness_app/core/presentation/widgets/custom_app_bar.dart';
import 'package:fitness_app/modules/auth/repository/auth_repository.dart';
import 'package:fitness_app/modules/auth/sign_in/bloc/login_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget implements AutoRouteWrapper {
  const LoginPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => const AuthService(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => LoginFormBloc(
          authenticationRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.login.tr()),
      body: FormBlocListener<LoginFormBloc, String, String>(
        onFailure: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Could not log in')),
            );
        },
        onSuccess: (context, state) => context.replaceRoute(const BottomNavigationBarRoute()),
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: Insets.large),
            shrinkWrap: true,
            children: [
              Text(context.tr(LocaleKeys.login_txt_account)),
              VSpace.small(),
              _EmailInput(),
              VSpace.small(),
              _PasswordInput(),
              VSpace.large(),
              _LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFieldBlocBuilder(
      textFieldBloc: context.read<LoginFormBloc>().email,
      keyboardType: TextInputType.emailAddress,
      key: const Key('loginForm_emailInput_textField'),
      decoration: const InputDecoration(labelText: 'Email'),
      errorBuilder: (context, error) {
        return 'Please enter a valid email';
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFieldBlocBuilder(
      textFieldBloc: context.read<LoginFormBloc>().password,
      key: const Key('loginForm_passwordInput_textField'),
      obscureText: true,
      decoration: const InputDecoration(labelText: 'password'),
      errorBuilder: (context, error) {
        return 'Please enter a valid password';
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormBloc, FormBlocState<String, String>>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          previous is FormBlocLoading && current is FormBlocLoading,
      builder: (context, state) {
        return AppButton(
          text: LocaleKeys.login.tr(),
          onPressed:
              state is! FormBlocSubmitting ? () => context.read<LoginFormBloc>().submit() : null,
          isExpanded: true,
          isEnabled: state is FormBlocSubmitting ? false : true,
        );
      },
    );
  }
}

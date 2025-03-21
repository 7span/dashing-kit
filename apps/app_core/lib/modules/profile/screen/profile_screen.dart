import 'package:api_client/api_client.dart';
import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/profile/bloc/profile_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget
    implements AutoRouteWrapper {
  const ProfileScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider(
      create: (context) => const AuthRepository(),
      child: BlocProvider(
        create:
            (context) => ProfileBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthRepository>(context),
            ),
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state.apiStatus == ApiStatus.error) {
          showAppSnackbar(
            context,
            state.errorMessage,
            type: SnackbarType.failed,
          );
        } else if (state.apiStatus == ApiStatus.loaded) {
          await context.router.replace(const SignInRoute());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: AppButton(
              isLoading: state.apiStatus == ApiStatus.loading,
              onPressed: () async {
                context.read<ProfileBloc>().add(const Logout());
              },
              text: 'Logout',
            ),
          ),
        );
      },
    );
  }
}

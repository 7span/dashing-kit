import 'package:api_client/api_client.dart';
import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/presentation/widgets/app_dialog.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/profile/bloc/profile_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget implements AutoRouteWrapper {
  const ProfileScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider(
      create: (context) => const AuthRepository(),
      child: BlocProvider(
        create: (context) => ProfileBloc(authenticationRepository: RepositoryProvider.of<AuthRepository>(context)),
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state.apiStatus == ApiStatus.error) {
          showAppSnackbar(context, state.errorMessage, type: SnackbarType.failed);
        } else if (state.apiStatus == ApiStatus.loaded) {
          await context.router.replace(const SignInRoute());
        }
      },
      builder: (context, state) {
        return AppScaffoldWidget(
          appBar: const CustomAppBar(title: 'My Profile'),
          body: Column(
            children: [
              VSpace.medium16(),
              AppButton(
                isLoading: state.apiStatus == ApiStatus.loading,

                /*  onPressed: () async {
                  context.read<ProfileBloc>().add(const Logout());
                },*/
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    useRootNavigator: false,
                    builder:
                        (_) => CustomAlertDialog(
                          buttonColor: context.colorScheme.error,
                          showAction: false,
                          positiveText: 'yes',
                          negativeText: 'No',
                          title: 'Logout',
                          content: 'Are you sure want to logout your account?',
                          onAction: (action) async {
                            if (action == DialogAction.positive) {
                              context.read<ProfileBloc>().add(const Logout());
                              await context.maybePop();
                            }
                            if (action == DialogAction.negative) {
                              await context.maybePop();
                            }
                          },
                        ),
                  );
                },
                text: 'Logout',
              ),
              VSpace.medium16(),
              AppButton(
                // isLoading: state.apiStatus == ApiStatus.loading,
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    useRootNavigator: false,
                    builder:
                        (_) => CustomAlertDialog(
                          buttonColor: context.colorScheme.error,
                          showAction: false,
                          positiveText: 'yes',
                          negativeText: 'No',
                          title: 'Delete My Account',
                          content: 'Are you sure want to delete your account?',
                          onAction: (action) async {
                            if (action == DialogAction.positive) {
                              await context.maybePop();
                            }
                            if (action == DialogAction.negative) {
                              await context.maybePop();
                            }
                          },
                        ),
                  );
                },
                text: 'Delete Account',
              ),
              AppButton(
                // isLoading: state.apiStatus == ApiStatus.loading,
                onPressed: () {},
                text: 'Change Password',
              ),
              AppButton(
                // isLoading: state.apiStatus == ApiStatus.loading,
                onPressed: () {},
                text: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

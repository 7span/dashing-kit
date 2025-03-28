import 'package:api_client/api_client.dart';
import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/presentation/widgets/app_dialog.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/profile/bloc/profile_cubit.dart';
import 'package:app_core/modules/profile/repository/profile_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget implements AutoRouteWrapper {
  const ProfileScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => const AuthRepository(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(),
        ),
      ],
      child: BlocProvider(
        create:
            (context) => ProfileCubit(
              RepositoryProvider.of<AuthRepository>(context),
              RepositoryProvider.of<ProfileRepository>(context),
            )..fetchProfileDetailsFromHive(),
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state.apiStatus == ApiStatus.error) {
          showAppSnackbar(
            context,
            state.errorMessage,
            type: SnackbarType.failed,
          );
        } else if (state.deleteApiStatus == ApiStatus.loaded ||
            state.logoutApiStatus == ApiStatus.loaded) {
          await context.router.replaceAll(const [SignInRoute()]);
        }
      },
      builder: (context, state) {
        return AppScaffold(
          appBar: const CustomAppBar(title: 'My Profile'),
          body: Padding(
            padding: const EdgeInsets.all(Insets.medium16),
            child: Column(
              spacing: Insets.medium16,
              children: [
                ProfileListTile(
                  onTap: () async {
                    await context.pushRoute(const EditProfileRoute());
                  },
                  title: 'My Profile',
                ),
                ProfileListTile(
                  title: 'Logout',
                  onTap: () {
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
                            content:
                                'Are you sure want to logout your account?',
                            onAction: (action) async {
                              if (action == DialogAction.positive) {
                                await context.read<ProfileCubit>().logout();
                              }
                              if (action == DialogAction.negative) {
                                if (context.mounted) {
                                  await context.maybePop();
                                }
                              }
                            },
                          ),
                    );
                  },
                ),
                ProfileListTile(
                  title: 'Delete Account',
                  onTap: () {
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
                            content:
                                'Are you sure want to delete your account?',
                            onAction: (action) async {
                              if (action == DialogAction.positive) {
                                await context
                                    .read<ProfileCubit>()
                                    .deleteUserAccount();
                              }
                              if (action == DialogAction.negative) {
                                if (context.mounted) {
                                  await context.maybePop();
                                }
                              }
                            },
                          ),
                    );
                  },
                ),
                ProfileListTile(title: 'Change Password', onTap: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({required this.title, required this.onTap, super.key});

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AppText.L(text: title),
      trailing: IconButton(
        onPressed: onTap,
        icon: const Icon(Icons.arrow_right_alt_outlined),
      ),
    );
  }
}

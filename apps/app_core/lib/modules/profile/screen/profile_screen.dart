import 'package:api_client/api_client.dart';
import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/presentation/widgets/app_dialog.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/profile/bloc/profile_bloc.dart';
import 'package:app_core/modules/profile/repository/profile_repository.dart';
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
            (context) => ProfileBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthRepository>(context),
              profileRepository:
                  RepositoryProvider.of<ProfileRepository>(context),
            )..add(const FetchProfileDetails()),
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
        } else if (state.shouldLogout) {
          await context.router.replaceAll(const [SignInRoute()]);
        }
      },
      builder: (context, state) {
        return AppScaffoldWidget(
          appBar: const CustomAppBar(title: 'My Profile'),
          body: Padding(
            padding: const EdgeInsets.all(Insets.medium16),
            child: Column(
              spacing: Insets.medium16,
              children: [
                ProfileInfo(onEditTap: () {}),
                AppButton(
                  isLoading: state.apiStatus == ApiStatus.loading,
                  text: 'Logout',
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
                            content:
                                'Are you sure want to logout your account?',
                            onAction: (action) async {
                              if (action == DialogAction.positive) {
                                context.read<ProfileBloc>().add(
                                  const Logout(),
                                );
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
                AppButton(
                  text: 'Delete Account',
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
                            content:
                                'Are you sure want to delete your account?',
                            onAction: (action) async {
                              if (action == DialogAction.positive) {
                                await context.maybePop();
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
          ),
        );
      },
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({ required this.onEditTap,super.key});

  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppNetworkImage(
              imageUrl: state.userModel?.profilePicUrl ?? '',
              imageHeight: 70,
            ),
            Column(
              spacing: Insets.medium16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.L(text: state.userModel?.name),
                AppText.L(text: state.userModel?.email),
              ],
            ),
            IconButton(
              onPressed: onEditTap,
              icon: const Icon(Icons.edit),
            ),
          ],
        );
      },
    );
  }
}

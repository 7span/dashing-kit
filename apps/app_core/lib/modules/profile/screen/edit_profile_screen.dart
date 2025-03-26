import 'package:api_client/api_client.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_core/modules/profile/bloc/profile_cubit.dart';
import 'package:app_core/modules/profile/repository/profile_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class EditProfileScreen extends StatelessWidget implements AutoRouteWrapper {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.editProfileStatus == ApiStatus.error) {
          showAppSnackbar(
            context,
            state.errorMessage,
            type: SnackbarType.failed,
          );
        } else if (state.editProfileStatus == ApiStatus.loaded) {
          showAppSnackbar(context, 'Profile Edited successfully');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const AppText.L(text: 'Edit Profile')),
          body:
              state.apiStatus == ApiStatus.loading
                  ? const Center(child: AppLoadingIndicator())
                  : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Insets.medium16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: Insets.medium16,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.medium16,
                          ),
                          child: AppNetworkImage(
                            imageUrl: state.userModel?.profilePicUrl,
                            imageHeight: 120,
                            imageWidth: 120,
                          ),
                        ),
                        AppTextField(
                          label: 'Name',
                          initialValue: state.userModel?.name,
                          backgroundColor: context.colorScheme.primary100,
                          onChanged: (value) {
                            context.read<ProfileCubit>().onNameChange(value);
                          },
                        ),
                        AppButton(
                          onPressed: () {
                            context.read<ProfileCubit>().onEditTap();
                          },
                          isExpanded: true,
                          text: 'Edit Profile',
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }

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
            )..makeProfileDetailApi(),
        child: this,
      ),
    );
  }
}

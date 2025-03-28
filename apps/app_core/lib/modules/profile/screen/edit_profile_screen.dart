// ignore_for_file: unused_element

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
        } else if ((state.isPermissionDenied ?? false) == true) {
          showAppSnackbar(
            context,
            'Please unable media permission',
            type: SnackbarType.failed,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const AppText.L(text: 'Edit Profile')),
          body:
              state.apiStatus == ApiStatus.loading
                  ? const Center(child: AppLoadingIndicator())
                  : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Insets.medium16),
                    child: Column(
                      spacing: Insets.medium16,
                      children: [
                        _ProfileImage(),
                        _NameTextFiled(),
                        _EditButton(),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.imageFile != current.imageFile,
      builder: (context, state) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium16),
              child:
                  state.imageFile != null
                      ? AppNetworkImage(
                        imageSource: AppImageSource.memory,
                        imageFile: state.imageFile,
                        imageHeight: 120,
                        imageWidth: 120,
                      )
                      : AppNetworkImage(
                        imageUrl: state.userModel?.profilePicUrl,
                        imageHeight: 120,
                        imageWidth: 120,
                      ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  context.read<ProfileCubit>().onAddImageTap();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NameTextFiled extends StatelessWidget {
  const _NameTextFiled();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return AppTextField(
          label: 'Name',
          initialValue: state.userModel?.name,
          backgroundColor: context.colorScheme.primary100,
          onChanged: (value) {
            context.read<ProfileCubit>().onNameChange(value);
          },
        );
      },
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return AppButton(
          isLoading: state.editProfileStatus == ApiStatus.loading,
          onPressed: () {
            context.read<ProfileCubit>().onEditTap();
          },
          isExpanded: true,
          text: 'Edit Profile',
        );
      },
    );
  }
}

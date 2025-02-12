import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/modules/profile/bloc/profile_bloc.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppNetworkImage(initials: 'bm', shape: BoxShape.circle),
            const SizedBox(height: 10),
            LogoutButtonWidget(
              onLogout: () async {
                if (context.mounted) {
                  await context.router.replaceAll([const SignInRoute()]);
                }
              },
            ),
            VSpace.small12(),
            AppButton(
              text: context.t.update_password,
              onPressed: () => context.pushRoute(const ChangePasswordRoute()),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({required this.onLogout, this.builder, super.key});

  final VoidCallback onLogout;
  final Widget Function(BuildContext context)? builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.isLoggedOut) {
            onLogout.call();
          }
        },
        child: Builder(
          builder: (context) {
            return builder?.call(context) ??
                AppButton(
                  text: context.t.logout,
                  onPressed:
                      () => context.read<ProfileBloc>().add(
                        UserProfileLogoutEvent(),
                      ),
                );
          },
        ),
      ),
    );
  }
}

import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/modules/auth/repository/auth_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppButton(
          onPressed: () async {
            await const AuthRepository().logout();
            if (context.mounted) {
              await context.replaceRoute(const SignInRoute());
            }
          },
          text: 'Logout',
        ),
      ),
    );
  }
}

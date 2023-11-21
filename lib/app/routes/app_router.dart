import 'package:auto_route/auto_route.dart';
import 'package:bloc_boilerplate/app/routes/route_guards/auth_guard.dart';
import 'package:bloc_boilerplate/core/presentation/widgets/image_cropper/custom_image_cropper.dart';
import 'package:bloc_boilerplate/modules/auth/sign_in/screens/login_screen.dart';
import 'package:bloc_boilerplate/modules/bottom_navigation_bar.dart';
import 'package:bloc_boilerplate/modules/home/screen/home_screen.dart';
import 'package:bloc_boilerplate/modules/profile/screen/profile_screen.dart';
import 'package:bloc_boilerplate/modules/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'app_router.gr.dart';

/// [Doc Link](abc)
@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: SplashRoute.page,
          guards: [
            AuthGuard(),
          ],
        ),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: CustomImageCropperRoute.page),
        AutoRoute(
          page: BottomNavigationBarRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
      ];
}

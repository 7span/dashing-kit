import 'package:app_core/modules/auth/sign_up/screens/sign_up_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:app_core/app/routes/route_guards/auth_guard.dart';
import 'package:app_core/modules/auth/sign_in/screens/sign_in_screen.dart';
import 'package:app_core/modules/bottom_navigation_bar.dart';
import 'package:app_core/modules/home/screen/home_screen.dart';
import 'package:app_core/modules/profile/screen/profile_screen.dart';
import 'package:app_core/modules/splash/splash_screen.dart';

part 'app_router.gr.dart';

/// [Doc Link](abc)
@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: SplashRoute.page,
          guards: [AuthGuard()],
        ),
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(
          page: BottomNavigationBarRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
      ];
}

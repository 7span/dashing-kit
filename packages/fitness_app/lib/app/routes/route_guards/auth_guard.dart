import 'package:auto_route/auto_route.dart';
import 'package:fitness_app/app/helpers/extensions/extensions.dart';
import 'package:fitness_app/app/routes/app_router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    if (resolver.isLoggedIn) {
      // if user is authenticated we continue
      resolver.next();
    } else {
      // we redirect the user to our login page
      // tip: use resolver.redirect to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.redirect(const LoginRoute());
    }
  }
}

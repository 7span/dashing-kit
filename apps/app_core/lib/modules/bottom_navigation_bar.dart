import 'package:app_core/app/routes/app_router.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BottomNavigationBarScreen extends StatelessWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      /// list of your tab routes
      /// routes used here must be declared as children
      /// routes of /dashboard
      routes: const [HomeRoute(), ProfileRoute()],
      transitionBuilder:
          (context, child, animation) => FadeTransition(
            opacity: animation,

            /// the passed child is technically our animated selected-tab page
            child: child,
          ),
      builder: (context, child) {
        /// obtain the scoped TabsRouter controller using context
        final tabsRouter = AutoTabsRouter.of(context);

        /// Here we're building our Scaffold inside of AutoTabsRouter
        /// to access the tabsRouter controller provided in this context
        return AppScaffold(
          body: child,
          bottomNavigationBar:
              context.topRouteMatch.meta['hideNavBar'] == true
                  ? null
                  : BottomNavigationBar(
                    currentIndex: tabsRouter.activeIndex,
                    onTap: tabsRouter.setActiveIndex,
                    items: [
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.list),
                        label: context.t.users,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.person),
                        label: context.t.profile,
                      ),
                    ],
                  ),
        );
      },
    );
  }
}

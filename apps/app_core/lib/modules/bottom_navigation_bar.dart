import 'package:app_core/app/helpers/extensions/extensions.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/app/helpers/logger_helper.dart';
import 'package:app_core/app/routes/app_router.dart';
import 'package:app_core/core/data/services/hive.service.dart';
import 'package:app_core/core/presentation/widgets/app_snackbar.dart';
import 'package:app_core/modules/home/bloc/home_bloc.dart';
import 'package:app_core/modules/home/repository/user_repository.dart';
import 'package:app_notification_service/notification_service.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class BottomNavigationBarScreen extends StatefulWidget implements AutoRouteWrapper {
  const BottomNavigationBarScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<ApiUserRepository>(
      create: (context) => ApiUserRepository(),
      child: BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(repository: context.read<ApiUserRepository>()),
        child: this,
      ),
    );
  }

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  final NotificationServiceInterface _notificationService = getIt<NotificationServiceInterface>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if player ID is already saved, if not, request permission
    if (!context.isPlayerIdSaved) {
      // Use Future.microtask to schedule this after the current build completes
      Future.microtask(_setupNotifications);
    } else {
      flog('OneSignal Player ID is already saved: ${context.playerId}');
    }
  }

  Future<void> _setupNotifications() async {
    var shouldRequestPermission = false;
    final status = await Permission.notification.status;
    // Show user consent dialog first
    if (!mounted) return;
    if (!context.isPlayerIdSaved || !status.isGranted ) {
      shouldRequestPermission = await _showNotificationConsentDialog();
    }

    if (shouldRequestPermission && mounted) {
      // Check current permission status
      if (status.isGranted) {
        // Permission already granted
        await _savePlayerIdAndNotify(true);
      } else if (status.isDenied) {
        // Request permission
        final result = await Permission.notification.request();
        if (result.isGranted && mounted) {
          await _savePlayerIdAndNotify(true);
        }
      } else if (status.isPermanentlyDenied) {
        // Show dialog to open settings
        if (mounted) {
          _showOpenSettingsDialog();
        }
      }
    }
  }

  Future<bool> _showNotificationConsentDialog() async {
    if (!mounted) return false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AppText.sSemiBold(text: 'Enable Notifications'),
          content: const AppText.regular10(
            text: 'We would like to send you notifications for important updates, alerts, and messages. Would you like to enable notifications?',
            maxLines: 4,),
          actions: <Widget>[
            TextButton(
              child: const Text('Not Now'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Allow'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _showOpenSettingsDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AppText.sSemiBold(text: 'Notification Disabled'),
          content: const AppText.regular10(
              text: 'Notifications are disabled. To receive important updates, alerts, and messages, please enable notifications in your device settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _savePlayerIdAndNotify(bool success) async {
    if (success) {
      try {
        await _notificationService.requestNotificationPermission();
        final playerId = await _notificationService.getNotificationSubscriptionId();

        if (playerId.isNotEmpty) {
          await getIt<IHiveService>().setPlayerId(playerId).run();

          if (mounted) {
            flog('OneSignal Player ID saved: $playerId');
            showAppSnackbar(
              context,
              'Notification permission enabled.',
            );
          }
        } else {
          flog('Failed to get player ID: empty string returned');
        }
      } catch (e) {
        flog('Error saving player ID: $e');
      }
    }
  }

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
        return AppScaffoldWidget(
          body: child,
          bottomNavigationBar:
          context.topRouteMatch.meta['hideNavBar'] == true
              ? null
              : BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.list), label: context.t.users),
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

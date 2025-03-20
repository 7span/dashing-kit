import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/extensions/extensions.dart';
import 'package:app_core/app/helpers/injection.dart';
import 'package:app_core/app/helpers/mixins/pagination_mixin.dart';
import 'package:app_core/modules/home/bloc/home_bloc.dart';
import 'package:app_core/modules/home/model/user_list_model.dart';
import 'package:app_core/modules/home/repository/user_repository.dart';
import 'package:app_notification_service/notification_service.dart';
import 'package:app_translations/app_translations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<ApiUserRepository>(
      create: (context) => ApiUserRepository(),
      child: BlocProvider<HomeBloc>(
        lazy: false,
        create:
            (context) => HomeBloc(
              repository: context.read<ApiUserRepository>(),
            )..safeAdd(const FetchUsersEvent()),
        child: this,
      ),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationServiceInterface _notificationService =
      getIt<NotificationServiceInterface>();
  bool _hasRequestedPermission = false;
  bool _didInitialCheck = false;
  // @override
  // void initState() {
  //   super.initState();
  //   _setupNotifications();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move permission request here instead of initState
    if (!_didInitialCheck) {
      _didInitialCheck = true;
      // Use Future.microtask to schedule this after the current build completes
      Future.microtask(() => _setupNotifications());
    }
  }

  Future<void> _setupNotifications() async {
    // You might want to check if the user is logged in before requesting permission
    // If they are, automatically request permission when the screen loads
    if (!_hasRequestedPermission) {
      // Cast to OneSignalService to access the consent dialog method
      final service = _notificationService as OneSignalService;
      final hasPermission = await service
          .requestNotificationPermissionWithConsent(context);
      setState(() {
        _hasRequestedPermission = true;
      });
      if (hasPermission) {
        // Maybe show a success snackbar or toast
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifications enabled successfully!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.homepage_title)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen:
                  (prev, current) =>
                      prev.status != current.status ||
                      prev.users.length != current.users.length,
              builder: (context, state) {
                switch (state.status) {
                  case ApiStatus.initial:
                  case ApiStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ApiStatus.loaded:
                    return _ListWidget(
                      hasReachedMax: state.hasReachedMax,
                      users: state.users,
                    );
                  case ApiStatus.error:
                    return Center(
                      child: Text(
                        context.t.user_error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  case ApiStatus.empty:
                    return Center(child: Text(context.t.empty_msg));
                }
              },
            ),
          ),
          InkWell(
            onTap: () {
              AutoTabsRouter.of(context).setActiveIndex(1);
            },
            child: Container(
              width: double.infinity,
              color: context.colorScheme.primary500,
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: Text(
                  'GO TO PROFILE',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListWidget extends StatefulWidget {
  const _ListWidget({
    required this.hasReachedMax,
    required this.users,
  });

  final bool hasReachedMax;
  final List<Data> users;

  @override
  State<_ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<_ListWidget>
    with PaginationService {
  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh:
          () async =>
              context.read<HomeBloc>().add(const FetchUsersEvent()),
      child: ListView.builder(
        controller: scrollController,
        itemCount:
            widget.users.length + (widget.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= widget.users.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: Insets.xxxxlarge80,
            ),
            child: Text(
              "${widget.users[index].firstName ?? ''} ${widget.users[index].lastName ?? ''}",
            ),
          );
        },
      ),
    );
  }

  @override
  void onEndScroll() {
    context.read<HomeBloc>().add(const LoadMoreUsersEvent());
  }
}

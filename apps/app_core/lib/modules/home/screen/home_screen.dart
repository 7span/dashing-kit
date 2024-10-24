import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/extensions/extensions.dart';
import 'package:app_core/app/helpers/mixins/pagination_mixin.dart';
import 'package:app_core/modules/home/bloc/home_bloc.dart';
import 'package:app_core/modules/home/repository/home_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<HomeRepository>(
      create: (context) => HomeRepository(),
      child: BlocProvider(
        lazy: false,
        create: (context) => HomeBloc(
          repository: RepositoryProvider.of<HomeRepository>(context),
        )..safeAdd(const HomeGetPostEvent(1)),
        child: this,
      ),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with PaginationService {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.username.isNotEmpty ? context.username : 'Home',
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.status) {
            case ApiStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ApiStatus.loaded:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: double.maxFinite,),
                  CircleAvatar(
                    backgroundImage: NetworkImage(state.homeData.avatar ?? ''),
                    radius: 100,
                  ),
                  AppText.XL(text: state.homeData.name,),
                  AppText.L(text: state.homeData.email,),
                  AppText.xs(text: state.homeData.role,),
                ],
              );
            case ApiStatus.initial:
              return const SizedBox.shrink();
            case ApiStatus.error:
            case ApiStatus.empty:
              return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }

  @override
  void onEndScroll() {
    context.read<HomeBloc>().add(const HomeGetPostEvent(1));
  }
}

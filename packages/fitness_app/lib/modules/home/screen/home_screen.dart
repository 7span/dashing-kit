import 'package:auto_route/auto_route.dart';
import 'package:fitness_ui/fitness_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitness_app/app/enum.dart';
import 'package:fitness_app/app/helpers/extensions/extensions.dart';
import 'package:fitness_app/app/helpers/mixins/pagination_mixin.dart';
import 'package:fitness_app/modules/home/bloc/home_bloc.dart';
import 'package:fitness_app/modules/home/repository/home_repository.dart';

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
        )..safeAdd(const HomeGetPostEvent()),
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
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.postsList.length + 1,
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (index == state.postsList.length) {
                    //showing loader at the bottom of list
                    return const Center(child: CircularProgressIndicator());
                  }
                  return InkWell(
                    onTap: () => context.read<HomeBloc>().add(const HomeDeletePostEvent()),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      margin: const EdgeInsets.all(Insets.small),
                      padding: const EdgeInsets.all(Insets.small),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.colorScheme.foreground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        state.postsList[index].title ?? '',
                        style: context.textTheme?.title,
                      ),
                    ),
                  );
                },
              );
            case ApiStatus.initial:
              return const SizedBox.shrink();
            case ApiStatus.error:
              return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }

  @override
  void onEndScroll() {
    context.read<HomeBloc>().add(const HomeGetPostEvent());
  }
}

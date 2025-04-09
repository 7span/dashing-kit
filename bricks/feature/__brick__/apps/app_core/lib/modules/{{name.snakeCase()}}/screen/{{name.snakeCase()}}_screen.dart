import 'package:api_client/api_client.dart';
import 'package:app_core/app/helpers/extensions/extensions.dart';
import 'package:app_core/app/helpers/mixins/pagination_mixin.dart';
import 'package:app_core/modules/{{name.snakeCase()}}/bloc/{{name.snakeCase()}}_bloc.dart';
import 'package:app_core/modules/{{name.snakeCase()}}/repository/{{name.snakeCase()}}_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class {{name.pascalCase()}}Screen extends StatefulWidget implements AutoRouteWrapper {
  const {{name.pascalCase()}}Screen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<{{name.pascalCase()}}Repository>(
          create: (context) => const {{name.pascalCase()}}Repository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => {{name.pascalCase()}}Bloc(
                  RepositoryProvider.of<{{name.pascalCase()}}Repository>(context),
                )..safeAdd(const Get{{name.pascalCase()}}Event()),
          ),
        ],
        child: this,
      ),
    );
  }

  @override
  State<{{name.pascalCase()}}Screen> createState() => _{{name.pascalCase()}}ScreenState();
}

class _{{name.pascalCase()}}ScreenState extends State<{{name.pascalCase()}}Screen>
    with PaginationService {
  late final ScrollController pageScrollController;

  @override
  void initState() {
    super.initState();
    pageScrollController = scrollController;
  }

  @override
  void dispose() {
    pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(title: '{{name.pascalCase()}}', leading: BackButton()),
      body: BlocBuilder<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
        buildWhen:
            (previous, current) => previous.apiStatus != current.apiStatus,
        builder: (context, state) {
          switch (state.apiStatus) {
            case ApiStatus.initial:
            case ApiStatus.loading:
              return const AppCircularProgressIndicator();
            case ApiStatus.empty:
              return EmptyScreen(
                showButton: false,
                title: 'No meowTicket was found!',
                subTitle:
                    'Keep yourself reminded of your tasks, so no pending task goes unnoticed!',
                buttonTitle: 'Create {{name.pascalCase()}}',
                onTap: () {},
              );
            case ApiStatus.error:
              return const Center(child: Text('Error'));
            case ApiStatus.loaded:
              return _{{name.pascalCase()}}View(scrollController: pageScrollController);
          }
        },
      ),
    );
  }

  @override
  void onEndScroll() {
    context.read<{{name.pascalCase()}}Bloc>().safeAdd(const LoadMore{{name.pascalCase()}}Event());
  }
}

class _{{name.pascalCase()}}View extends StatelessWidget {
  const _{{name.pascalCase()}}View({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
      builder: (context, state) {
        return AppRefreshIndicator(
          onRefresh:
              () async => context.read<{{name.pascalCase()}}Bloc>().add(
                const Get{{name.pascalCase()}}Event(),
              ),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount:
                !state.hasMorePages || (state.apiStatus == ApiStatus.loading)
                    ? state.{{name.camelCase()}}List!.length
                    : state.{{name.camelCase()}}List!.length + 1,
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.medium16,
              vertical: Insets.medium16,
            ),
            itemBuilder: (context, index) {
              ///! [!widget.isLoading] This condition is there because we don't need to show the indicator
              ///! when the user is seeing the shimmer effect for the fist time
              if (index >= state.{{name.camelCase()}}List!.length &&
                  (state.apiStatus == ApiStatus.loading)) {
                return const Center(
                  child: AppPadding.regular(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                  ),
                );
              } else {
                final model = state.{{name.camelCase()}}List![index];
                return {{name.pascalCase()}}ListTile(
                  id: model.dataId.toString(),
                  onTap: () {},
                );
              }
            },
            separatorBuilder: (context, index) => VSpace.xsmall8(),
          ),
        );
      },
    );
  }
}

class {{name.pascalCase()}}ListTile extends StatelessWidget {
  const {{name.pascalCase()}}ListTile({required this.id, required this.onTap, super.key});

  final String id;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return AnimatedGestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Insets.small12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.small8),
          color: context.colorScheme.white,
        ),
        child: AppText.subTitle10(text: id),
      ),
    );
  }
}

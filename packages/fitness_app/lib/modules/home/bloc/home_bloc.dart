import 'dart:async';

import 'package:fitness_app/app/enum.dart';
import 'package:fitness_app/modules/home/model/post_model.dart';
import 'package:fitness_app/modules/home/repository/home_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  HomeBloc({required this.repository}) : super(const HomeState.initial()) {
    /// Here, we're using droppable transformer, because it will process
    /// only one event and ignore (drop) any new events until the current event is done.
    on<HomeGetPostEvent>(_onHomeGetPostEvent, transformer: droppable());
    // on<HomeDeletePostEvent>(_onHomeDeletePostEvent);
  }
  final IHomeRepository repository;

  int _pageCount = 1;

  FutureOr<void> _onHomeGetPostEvent(
    HomeGetPostEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.hasReachedMax) return;

    /// If the user is coming for the first time then show the loader, it that's not the case
    /// that means user wants to more load data, which implies that they should have some data
    /// That's why we're not emitting the loading state in case the user has any data.
    state.status == ApiStatus.initial
        ? emit(const HomeState.loading())
        : emit(HomeState.loaded(state.postsList, false));
    final fetchPostEither = await repository.fetchPosts(page: _pageCount).run();
    fetchPostEither.fold(
      (error) => emit(const HomeState.error()),
      (result) {
        emit(
          HomeState.loaded(
            state.postsList.followedBy(result).toList(),
            false,
          ),
        );
        _pageCount++;
      },
    );
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    return HomeState.loaded(
      List<PostModel>.from(
        (json['postsList'] as List<dynamic>)
            // ignore: unnecessary_lambdas
            .map<PostModel>((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList(),
      ),
      false,
    );
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    switch (state.status) {
      case ApiStatus.loaded:
        return state.toJson();
      // ignore: no_default_cases
      default:
        return null;
    }
  }
}

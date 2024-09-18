import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/app_constants.dart';
import 'package:app_core/modules/home/model/home_model.dart';
import 'package:app_core/modules/home/repository/home_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  HomeBloc({required this.repository}) : super(const HomeState.initial()) {
    /// Here, we're using droppable transformer, because it will process
    /// only one event and ignore (drop) any new events until the current event is done.
    on<HomeGetPostEvent>(_onHomeGetDataEvent, transformer: droppable());
  }
  final IHomeRepository repository;

  FutureOr<void> _onHomeGetDataEvent(
    HomeGetPostEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());
    final fetchHomeScreenDataEither = await repository.getNowPlayingMovies(AppConstants.profile).run();
    fetchHomeScreenDataEither.fold(
      (error) => emit(const HomeState.error()),
      (result) => emit(HomeState.loaded(result)),
    );
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    return null;
    // return HomeState.loaded(
    //   List<Plan>.from(
    //     (json['postsList'] as List<dynamic>)
    //         .map<Plan>((json) => Plan.fromJson(json as Map<String, dynamic>))
    //         .toList(),
    //   ),
    //   true,
    // );
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    switch (state.status) {
      case ApiStatus.loaded:
      case ApiStatus.empty:
      // return state.toJson();
      case ApiStatus.initial:
      case ApiStatus.loading:
      case ApiStatus.error:
        return null;
    }
  }
}

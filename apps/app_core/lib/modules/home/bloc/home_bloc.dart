import 'package:api_client/api_client.dart';
import 'package:app_core/app/config/api_endpoints.dart';
import 'package:app_core/modules/home/model/post_response_model.dart';
import 'package:app_core/modules/home/repository/home_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.repository}) : super(const HomeState()) {
    on<FetchPostsEvent>(_fetchPosts);
    on<LoadMorePostsEvent>(
      _onLoadMorePosts,
      transformer: droppable(),
    );
  }

  final HomeRepository repository;

  Future<void> _fetchPosts(
    FetchPostsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState(apiStatus: ApiStatus.loading));

    final response = await repository.fetchPostData().run();

    response.fold(
      (error) => emit(state.copyWith(apiStatus: ApiStatus.error)),
      (response) {
        if (response.isEmpty) {
          emit(
            const HomeState(
              apiStatus: ApiStatus.empty,
              hasReachedMax: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              postList: response,
              apiStatus: ApiStatus.loaded,
              hasReachedMax: response.length < ApiEndpoints.pageSize,
            ),
          );
        }
      },
    );
  }

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.hasReachedMax) return;

    final response =
        await repository.fetchPostData(page: state.nextPage).run();

    response.fold(
      (error) => emit(state.copyWith(apiStatus: ApiStatus.error)),
      (response) {
        emit(
          state.copyWith(
            postList: List.of(state.postList)..addAll(response),
            apiStatus: ApiStatus.loaded,
            hasReachedMax: response.length < ApiEndpoints.pageSize,
          ),
        );
      },
    );
  }
}

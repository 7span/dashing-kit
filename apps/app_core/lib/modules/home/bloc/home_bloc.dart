import 'package:api_client/api_client.dart';
import 'package:app_core/modules/home/model/user_list_model.dart';
import 'package:app_core/modules/home/repository/user_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // Number of items per page

  HomeBloc({required this.repository}) : super(const HomeState()) {
    on<FetchUsersEvent>(_fetchUsers);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers, transformer: droppable());
  }

  final UserRepository repository;

  int _currentPage = 1;

  /// Fetch the next page of users
  Future<void> _fetchUsers(
    FetchUsersEvent event,
    Emitter<HomeState> emit,
  ) async {
    _currentPage = 1;

    emit(const HomeState(status: ApiStatus.loading));

    final response = await repository.fetchUsers(page: _currentPage).run();

    response.fold((error) => emit(state.copyWith(status: ApiStatus.error)), (
      response,
    ) {
      if (response.data.isEmpty) {
        emit(const HomeState(status: ApiStatus.empty, hasReachedMax: true));
      } else {
        emit(
          state.copyWith(
            users: response.data,
            status: ApiStatus.loaded,
            hasReachedMax: response.data.length < (response.perPage ?? 5),
          ),
        );
        _currentPage++;
      }
    });
  }

  Future<void> _onLoadMoreUsers(
    LoadMoreUsersEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state.hasReachedMax) return;

    final response = await repository.fetchUsers(page: _currentPage).run();

    response.fold((error) => emit(state.copyWith(status: ApiStatus.error)), (
      response,
    ) {
      emit(
        state.copyWith(
          users: List.of(state.users)..addAll(response.data),
          status: ApiStatus.loaded,
          hasReachedMax: response.data.length < (response.perPage ?? 5),
        ),
      );
      _currentPage++;
    });
  }
}

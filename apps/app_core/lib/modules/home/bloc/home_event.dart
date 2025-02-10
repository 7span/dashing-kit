part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class FetchUsersEvent extends HomeEvent {
  const FetchUsersEvent();
}

final class LoadMoreUsersEvent extends HomeEvent {
  const LoadMoreUsersEvent();
}

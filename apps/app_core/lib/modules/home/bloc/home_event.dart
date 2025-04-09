part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

final class FetchPostsEvent extends HomeEvent {
  const FetchPostsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadMorePostsEvent extends HomeEvent {
  const LoadMorePostsEvent();

  @override
  List<Object?> get props => [];
}

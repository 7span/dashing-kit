part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomeGetPostEvent extends HomeEvent {
  const HomeGetPostEvent();
}

final class HomeDeletePostEvent extends HomeEvent {
  const HomeDeletePostEvent();
}

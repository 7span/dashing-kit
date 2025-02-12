part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = ApiStatus.initial,
    this.users = const [],
    this.hasReachedMax = false,
  });

  final ApiStatus status;
  final List<Data> users; // The currently loaded users
  final bool hasReachedMax; // Whether all pages are loaded

  /// Copy the state with new values.

  @override
  List<Object?> get props => [status, users, hasReachedMax];

  HomeState copyWith({ApiStatus? status, List<Data>? users, bool? hasReachedMax}) {
    return HomeState(
      status: status ?? this.status,
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

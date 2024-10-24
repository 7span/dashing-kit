part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState._({
    this.homeData = const HomeModel(),
    this.status = ApiStatus.initial,
  });

  const HomeState.initial() : this._(status: ApiStatus.initial);
  const HomeState.loading() : this._(status: ApiStatus.loading);
  const HomeState.loaded(HomeModel homeData)
      : this._(
          status: ApiStatus.loaded,
          homeData: homeData,
        );
  const HomeState.error() : this._(status: ApiStatus.error);
  final HomeModel homeData;
  final ApiStatus status;

  HomeState copyWith({
    HomeModel? homeData,
    bool? hasReachedMax,
    ApiStatus? status,
  }) {
    return HomeState._(
      homeData: homeData ?? this.homeData,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [homeData, status];

  @override
  bool get stringify => true;
}

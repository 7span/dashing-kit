// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_positional_boolean_parameters
part of 'home_bloc.dart';

class HomeState extends Equatable {
  final HomeEntity homeData;
  final ApiStatus status;
  const HomeState._({
    this.homeData = const HomeEntity(),
    this.status = ApiStatus.initial,
  });

  const HomeState.initial() : this._(status: ApiStatus.initial);
  const HomeState.loading() : this._(status: ApiStatus.loading);
  const HomeState.loaded(HomeEntity homeData)
      : this._(
          status: ApiStatus.loaded,
          homeData: homeData,
        );
  const HomeState.error() : this._(status: ApiStatus.error);

  HomeState copyWith({
    HomeEntity? homeData,
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

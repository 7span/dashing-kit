part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.apiStatus = ApiStatus.initial,
    this.postList = const [],
    this.hasReachedMax = false,
  });

  final ApiStatus apiStatus;
  final List<PostResponseModel>
  postList; // The currently loaded users
  final bool hasReachedMax; // Whether all pages are loaded

  /// if API pagination starts with 1:
  /// ```dart
  /// int get nextPage =>
  ///     (list.length / pageSize).floor() + 1;
  ///```
  ///
  /// if API pagination starts with 0:
  /// ```dart
  /// int get nextPage =>
  ///     (list.length / pageSize).ceil();
  /// ```
  int get nextPage => (postList.length / ApiConstant.pageSize).floor() + 1;

  /// Copy the state with new values.

  @override
  List<Object?> get props => [apiStatus, postList, hasReachedMax];

  HomeState copyWith({
    ApiStatus? apiStatus,
    List<PostResponseModel>? postList,
    bool? hasReachedMax,
  }) {
    return HomeState(
      apiStatus: apiStatus ?? this.apiStatus,
      postList: postList ?? this.postList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

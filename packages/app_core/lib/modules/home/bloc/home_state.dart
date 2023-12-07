// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_positional_boolean_parameters
part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<PostModel> postsList;
  final bool hasReachedMax;
  final ApiStatus status;
  const HomeState._({
    this.postsList = const <PostModel>[],
    this.hasReachedMax = false,
    this.status = ApiStatus.initial,
  });

  const HomeState.initial() : this._(status: ApiStatus.initial);
  const HomeState.loading() : this._(status: ApiStatus.loading);
  const HomeState.loaded(List<PostModel> postList, bool hasReachedMax)
      : this._(
          status: ApiStatus.loaded,
          postsList: postList,
          hasReachedMax: hasReachedMax,
        );
  const HomeState.error() : this._(status: ApiStatus.error);

  HomeState copyWith({
    ApiStatus? status,
    List<PostModel>? postsList,
    bool? hasReachedMax,
  }) {
    return HomeState._(
      status: status ?? this.status,
      postsList: postsList ?? this.postsList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'postsList': postsList.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object?> get props => [postsList, hasReachedMax, status];

  @override
  bool get stringify => true;
}

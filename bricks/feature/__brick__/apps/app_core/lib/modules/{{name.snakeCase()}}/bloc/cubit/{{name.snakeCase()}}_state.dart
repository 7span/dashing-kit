part of '{{name.snakeCase()}}_cubit.dart';

final class {{name.pascalCase()}}State extends Equatable {
  const {{name.pascalCase()}}State({this.apiStatus = ApiStatus.initial});

  final ApiStatus apiStatus;

  @override
  List<Object> get props => [apiStatus];

  {{name.pascalCase()}}State copyWith({ApiStatus? apiStatus}) {
    return {{name.pascalCase()}}State(apiStatus: apiStatus ?? this.apiStatus);
  }
}

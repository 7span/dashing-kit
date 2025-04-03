part of '{{name.snakeCase()}}_bloc.dart';

final class {{name.pascalCase()}}State extends Equatable {
  const {{name.pascalCase()}}State({
    this.apiStatus = ApiStatus.initial,
    this.hasMorePages = true,
    this.{{name.camelCase()}}List,
  });
  
  final List<{{name.pascalCase()}}Model>? {{name.camelCase()}}List;
  final ApiStatus apiStatus;
  final bool hasMorePages;

  {{name.pascalCase()}}State copyWith({
    List<{{name.pascalCase()}}Model>? {{name.camelCase()}}List,
    ApiStatus? apiStatus,
    bool? hasMorePages,
  }) {
    return {{name.pascalCase()}}State(
      {{name.camelCase()}}List: {{name.camelCase()}}List ?? this.{{name.camelCase()}}List,
      apiStatus: apiStatus ?? this.apiStatus,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }

  @override
  List<Object?> get props => [{{name.camelCase()}}List, apiStatus, hasMorePages];

  @override
  bool get stringify => true;
}
